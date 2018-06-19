// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// This library exports all API from Kernel's ast.dart that can be used
/// throughout fasta.
library fasta.kernel_ast_api;

export 'package:kernel/ast.dart'
    show
        AssertStatement,
        AsyncMarker,
        Block,
        BreakStatement,
        Catch,
        CheckLibraryIsLoaded,
        Class,
        Constructor,
        ConstructorInvocation,
        ContinueSwitchStatement,
        DartType,
        DynamicType,
        EmptyStatement,
        Expression,
        ExpressionStatement,
        Field,
        FunctionDeclaration,
        FunctionNode,
        FunctionType,
        Initializer,
        InvalidType,
        LabeledStatement,
        Let,
        Library,
        Location,
        Member,
        MethodInvocation,
        Name,
        NamedExpression,
        NamedType,
        Node,
        Procedure,
        ProcedureKind,
        PropertySet,
        Rethrow,
        ReturnStatement,
        Statement,
        StaticGet,
        StaticSet,
        StringConcatenation,
        SuperInitializer,
        SuperMethodInvocation,
        SuperPropertySet,
        SwitchCase,
        Throw,
        TreeNode,
        TypeParameter,
        TypeParameterType,
        VariableDeclaration,
        VariableGet,
        VariableSet,
        VoidType,
        setParents;

export 'kernel_shadow_ast.dart'
    show
        AssertInitializerJudgment,
        AssertStatementJudgment,
        BreakJudgment,
        ShadowCascadeExpression,
        ShadowComplexAssignment,
        ShadowConstructorInvocation,
        ShadowContinueSwitchStatement,
        ShadowDeferredCheck,
        ShadowExpressionStatement,
        ShadowFactoryConstructorInvocation,
        ShadowFieldInitializer,
        ShadowForInStatement,
        ShadowFunctionDeclaration,
        ShadowFunctionExpression,
        ShadowIfNullExpression,
        ShadowIfStatement,
        ShadowIllegalAssignment,
        ShadowIndexAssign,
        ShadowInvalidInitializer,
        LabeledStatementJudgment,
        ShadowLogicalExpression,
        ShadowLoopAssignmentStatement,
        ShadowMethodInvocation,
        ShadowNamedFunctionExpression,
        ShadowNullAwareMethodInvocation,
        ShadowNullAwarePropertyGet,
        ShadowPropertyAssign,
        ShadowPropertyGet,
        ShadowRedirectingInitializer,
        ShadowReturnStatement,
        ShadowStaticAssignment,
        ShadowStaticGet,
        ShadowStaticInvocation,
        ShadowSuperInitializer,
        ShadowSuperMethodInvocation,
        ShadowSuperPropertyGet,
        ShadowSwitchStatement,
        ShadowSyntheticExpression,
        VariableAssignmentJudgment,
        ShadowVariableDeclaration,
        VariableGetJudgment,
        ShadowYieldStatement,
        NamedExpressionJudgment;
