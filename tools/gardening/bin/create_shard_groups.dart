// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Outputs source code for `part` used by `shard2group.dart`. Usage:
// `dart bin/create_shard_groups.dart source.html >lib/src/shard_data.dart`.

import 'dart:io';
import 'dart:math' as math;

const String groupsStartMark = r"<td class='DevStatus Alt first";
const String groupsEndMark = r"<tr class='DevStatusSpacing'>";

List<String> findGroups(List<String> source) {
  List<String> result = <String>[];
  bool started = false;
  
  for (String line in source) {
    if (line.contains(groupsStartMark)) started = true;
    if (started) {
      if (line.contains(groupsEndMark)) break;
      String trimmed = line.trim();
      if (!trimmed.startsWith('<')) {
        result.add(trimmed);
      }
    }
  }
  return result;
}

const String shardsStartMark = groupsEndMark;
const String shardsEndMark = r"<td class='DevStatusBox";
const String shardsGroupStartMark = r"<td class='DevSlave Alt";
const String shardMark = '/builders/';

List<List<String>> findShards(List<String> source) {
  List<List<String>> result = <List<String>>[];
  List<String> shardResult;
  bool started = false;

  for (String line in source) {
    if (line.contains(shardsStartMark)) started = true;
    if (started) {
      if (line.contains(shardsEndMark)) {
        if (shardResult != null) result.add(shardResult);
        break;
      }
      String trimmed = line.trim();
      int buildersIndex = trimmed.indexOf(shardMark);
      if (buildersIndex >= 0) {
        int quoteIndex = trimmed.indexOf("'", buildersIndex);
        if (quoteIndex >= 0) {
          // Found a shard name, add it.
          shardResult.add(trimmed.substring(
              buildersIndex + shardMark.length, quoteIndex));
        } else {
          // Unexpected source formatting, skip.
        }
      } else if (trimmed.contains(shardsGroupStartMark)) {
        // This is a group separator, switch to next sublist.
        if (shardResult != null) result.add(shardResult);
        shardResult = <String>[];
      }
    }
  }
  return result;  
}

main(List<String> args) {
  if (args.length != 1) {
    print('Usage: dart create_shard_groups.dart <darto-source-file>');
    exit(1);
  }

  File dartoSourceFile = new File(args[0]);
  List<String> dartoSource = dartoSourceFile.readAsLinesSync();

  List<String> groups = findGroups(dartoSource);
  List<List<String>> shards = findShards(dartoSource);
  int groupCount = math.min(groups.length, shards.length);

  // Print the resulting Dart declaration.
  print("""
// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
//
// ----- Generated by create_shard_groups.dart, do not edit! -----

part of gardening.shard2group;

const Map<String, List<String>> shardGroups = const {
""");
  for (int i = 0; i < groupCount; i++) {
    print("  '${groups[i]}': const <String>[");
    for (String shard in shards[i]) {
      print("    '$shard',");
    }
    print("  ],");
  }
  print('};');
}
