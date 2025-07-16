import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class SplitVideoService {
  static Future<List<SplitVideoItem>> getSplitVideoItems() async {
    final directory = await getExternalStorageDirectory();
    if (directory == null) return [];

    final moviesDir = Directory("${directory.path}/Movies");
    if (!await moviesDir.exists()) return [];

    final files = moviesDir
        .listSync()
        .whereType<File>()
        .where((file) => file.path.endsWith(".mp4"))
        .toList();

    files.sort((a, b) => b.path.compareTo(a.path));

    final Map<String, Map<String, String>> grouped = {};

    for (var file in files) {
      final name = file.path.split('/').last;
      final base = name
          .replaceAll("_Front.mp4", "")
          .replaceAll("_Back.mp4", "");

      final isFront = name.contains("_Front");
      final isBack = name.contains("_Back");

      if (!grouped.containsKey(base)) {
        grouped[base] = {"front": "", "back": ""};
      }

      if (isFront) {
        grouped[base]!["front"] = file.path;
      } else if (isBack) {
        grouped[base]!["back"] = file.path;
      }
    }

    final List<SplitVideoItem> validItems = [];

    for (final entry in grouped.entries) {
      final frontPath = entry.value["front"]!;
      final backPath = entry.value["back"]!;

      if (frontPath.isEmpty || backPath.isEmpty) continue;

      final frontPlayable = await _isPlayable(frontPath);
      final backPlayable = await _isPlayable(backPath);

      if (frontPlayable && backPlayable) {
        validItems.add(SplitVideoItem(frontPath: frontPath, backPath: backPath));
      }
    }

    return validItems;
  }

  // static Future<List<SplitVideoItem>> getSplitVideoItems() async {
  //   final directory = await getExternalStorageDirectory();
  //   if (directory == null) return [];
  //
  //   final moviesDir = Directory("${directory.path}/Movies");
  //   if (!await moviesDir.exists()) return [];
  //
  //   final files = moviesDir
  //       .listSync()
  //       .whereType<File>()
  //       .where((file) => file.path.endsWith(".mp4"))
  //       .toList();
  //
  //   files.sort((a, b) => b.path.compareTo(a.path));
  //
  //   final Map<String, Map<String, String>> grouped = {};
  //   for (var file in files) {
  //     final name = file.path.split('/').last;
  //     final base = name
  //         .replaceAll("_Front.mp4", "")
  //         .replaceAll("_Back.mp4", "");
  //
  //     final isFront = name.contains("_Front");
  //     final isBack = name.contains("_Back");
  //
  //     grouped.putIfAbsent(base, () => {"front": "", "back": ""});
  //
  //     if (isFront) {
  //       grouped[base]!["front"] = file.path;
  //     } else if (isBack) {
  //       grouped[base]!["back"] = file.path;
  //     }
  //   }
  //
  //   final List<SplitVideoItem> validItems = [];
  //
  //   for (final entry in grouped.entries) {
  //     final rawFrontPath = entry.value["front"]!;
  //     final rawBackPath = entry.value["back"]!;
  //
  //     String frontPath = "";
  //     String backPath = "";
  //
  //     if (rawFrontPath.isNotEmpty && await _isPlayable(rawFrontPath)) {
  //       frontPath = rawFrontPath;
  //     }
  //
  //     if (rawBackPath.isNotEmpty && await _isPlayable(rawBackPath)) {
  //       backPath = rawBackPath;
  //     }
  //
  //     if (frontPath.isNotEmpty || backPath.isNotEmpty) {
  //       validItems.add(SplitVideoItem(frontPath: frontPath, backPath: backPath));
  //     }
  //   }
  //
  //   return validItems;
  // }


  static Future<List<SplitVideoItem>> getSplitVideoItemsnoCheck() async {
    final directory = await getExternalStorageDirectory();
    if (directory == null) return [];

    final moviesDir = Directory("${directory.path}/Movies");
    if (!await moviesDir.exists()) return [];

    final files = moviesDir
        .listSync()
        .whereType<File>()
        .where((file) => file.path.endsWith(".mp4"))
        .toList();

    files.sort((a, b) => b.path.compareTo(a.path)); // Newest first

    final Map<String, Map<String, String>> grouped = {};

    for (var file in files) {
      final name = file.path.split('/').last;
      final base = name
          .replaceAll("_Front.mp4", "")
          .replaceAll("_Back.mp4", "");

      final isFront = name.contains("_Front");
      final isBack = name.contains("_Back");

      if (!grouped.containsKey(base)) {
        grouped[base] = {"front": "", "back": ""};
      }

      if (isFront) {
        grouped[base]!["front"] = file.path;
      } else if (isBack) {
        grouped[base]!["back"] = file.path;
      }
    }

    final List<SplitVideoItem> items = [];

    grouped.forEach((key, value) {
      if (value["front"]!.isNotEmpty && value["back"]!.isNotEmpty) {
        items.add(SplitVideoItem(
          frontPath: value["front"]!,
          backPath: value["back"]!,
        ));
      }
    });

    return items;
  }


  static Future<bool> _isPlayable(String path) async {
    try {
      final controller = VideoPlayerController.file(File(path));
      await controller.initialize();
      final duration = controller.value.duration;
      await controller.dispose();

      return duration.inSeconds > 0;
    } catch (_) {
      return false;
    }
  }

  static Future<void> cleanInvalidRecordings() async {
    final directory = await getExternalStorageDirectory();
    if (directory == null) return;

    final moviesDir = Directory("${directory.path}/Movies");
    if (!await moviesDir.exists()) return;

    final files = moviesDir
        .listSync()
        .whereType<File>()
        .where((file) => file.path.endsWith(".mp4"))
        .toList();

    final Map<String, Map<String, String>> grouped = {};

    for (var file in files) {
      final name = file.path.split('/').last;
      final base = name
          .replaceAll("_Front.mp4", "")
          .replaceAll("_Back.mp4", "");

      final isFront = name.contains("_Front");
      final isBack = name.contains("_Back");

      if (!grouped.containsKey(base)) {
        grouped[base] = {"front": "", "back": ""};
      }

      if (isFront) {
        grouped[base]!["front"] = file.path;
      } else if (isBack) {
        grouped[base]!["back"] = file.path;
      }
    }

    for (final entry in grouped.entries) {
      final frontPath = entry.value["front"]!;
      final backPath = entry.value["back"]!;

      final hasFront = frontPath.isNotEmpty;
      final hasBack = backPath.isNotEmpty;

      bool deleteFront = false;
      bool deleteBack = false;

      if (!hasFront || !hasBack) {
        // Delete orphaned file
        deleteFront = !hasBack;
        deleteBack = !hasFront;
      } else {
        // Check playability
        final frontPlayable = await _isPlayable(frontPath);
        final backPlayable = await _isPlayable(backPath);

        deleteFront = !frontPlayable;
        deleteBack = !backPlayable;
      }

      if (deleteFront && frontPath.isNotEmpty) {
        try {
          await File(frontPath).delete();
        } catch (_) {}
      }

      if (deleteBack && backPath.isNotEmpty) {
        try {
          await File(backPath).delete();
        } catch (_) {}
      }
    }
  }



  static Future<void> deleteSplitVideo(SplitVideoItem item) async {
    try {
      final frontFile = File(item.frontPath);
      final backFile = File(item.backPath);

      if (await frontFile.exists()) {
        await frontFile.delete();
      }

      if (await backFile.exists()) {
        await backFile.delete();
      }
    } catch (e) {
      print('Error deleting split video: $e');
    }
  }
}

class SplitVideoItem {
  final String frontPath;
  final String backPath;
  SplitVideoItem({required this.frontPath, required this.backPath});
}

