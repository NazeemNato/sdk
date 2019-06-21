// Copyright (c) 2019, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/src/dart/element/handle.dart';
import 'package:nnbd_migration/src/decorated_type.dart';
import 'package:nnbd_migration/src/node_builder.dart';
import 'package:nnbd_migration/src/nullability_node.dart';

/// Responsible for building and maintaining information about nullability
/// decorations related to the class hierarchy.
///
/// For instance, if one class is a subclass of the other, we record the
/// nullabilities of all the types involved in the subclass relationship.
class DecoratedClassHierarchy {
  final VariableRepository _variables;

  final NullabilityGraph _graph;

  /// Cache for speeding up the computation of
  /// [_getGenericSupertypeDecorations].
  final Map<ClassElement, Map<ClassElement, DecoratedType>>
      _genericSupertypeDecorations = {};

  DecoratedClassHierarchy(this._variables, this._graph);

  /// Retrieves a [DecoratedType] describing how [class_] implements
  /// [superclass].
  ///
  /// If [class_] does not implement [superclass], raises an exception.
  ///
  /// Note that the returned [DecoratedType] will have a node of `never`,
  /// because the relationship between a class and its superclass is not
  /// nullable.
  DecoratedType getDecoratedSupertype(
      ClassElement class_, ClassElement superclass) {
    assert(class_ is! ClassElementHandle);
    assert(superclass is! ClassElementHandle);
    if (superclass.typeParameters.isEmpty) {
      return DecoratedType(superclass.type, _graph.never);
    }
    return _getGenericSupertypeDecorations(class_)[superclass] ??
        (throw StateError('Unrelated types'));
  }

  /// Computes a map whose keys are all the superclasses of [class_], and whose
  /// values indicate how [class_] implements each superclass.
  Map<ClassElement, DecoratedType> _getGenericSupertypeDecorations(
      ClassElement class_) {
    var decorations = _genericSupertypeDecorations[class_];
    if (decorations == null) {
      // Call ourselves recursively to compute how each of [class_]'s direct
      // superclasses relates to all of its transitive superclasses.
      decorations = _genericSupertypeDecorations[class_] = {};
      var decoratedDirectSupertypes =
          _variables.decoratedDirectSupertypes(class_);
      for (var entry in decoratedDirectSupertypes.entries) {
        var superclass = entry.key;
        var decoratedSupertype = entry.value;
        var supertype = decoratedSupertype.type as InterfaceType;
        // Compute a type substitution to determine how [class_] relates to
        // this specific [superclass].
        var argumentTypes = supertype.typeArguments;
        var parameterTypes =
            supertype.typeParameters.map((p) => p.type).toList();
        Map<TypeParameterElement, DecoratedType> substitution = {};
        for (int i = 0; i < argumentTypes.length; i++) {
          substitution[supertype.typeParameters[i]] =
              decoratedSupertype.typeArguments[i];
        }
        // Apply that substitution to the relation between [superclass] and
        // each of its transitive superclasses, to determine the relation
        // between [class_] and the transitive superclass.
        var recursiveSupertypeDecorations =
            _getGenericSupertypeDecorations(superclass);
        for (var entry in recursiveSupertypeDecorations.entries) {
          var undecoratedResult =
              entry.value.type.substitute2(argumentTypes, parameterTypes);
          decorations[entry.key] ??=
              entry.value.substitute(substitution, undecoratedResult);
        }
        // Also record the relation between [class_] and its direct
        // superclass.
        decorations[superclass] ??= decoratedSupertype;
      }
    }
    return decorations;
  }
}