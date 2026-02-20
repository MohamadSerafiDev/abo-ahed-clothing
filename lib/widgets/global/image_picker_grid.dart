import 'dart:io';

import 'package:abo_abed_clothing/core/utils/light_theme.dart';
import 'package:abo_abed_clothing/core/utils/text_styles.dart';
import 'package:abo_abed_clothing/widgets/global/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

/// A reusable media picker grid with gallery/camera support for images & videos.
///
/// Features:
/// - Horizontal scrollable media preview with remove button
/// - Video files show a play-icon overlay
/// - Add-media area with counter
/// - Bottom-sheet source chooser (gallery images+videos / camera photo / camera video)
/// - Configurable [maxFiles] and [maxFileSizeBytes]
class MediaPickerGrid extends StatefulWidget {
  /// Currently selected media files (managed externally).
  final List<File> files;

  /// Called whenever the file list changes.
  final ValueChanged<List<File>> onChanged;

  /// Maximum number of files allowed.
  final int maxFiles;

  /// Maximum file size in bytes per file.
  final int maxFileSizeBytes;

  /// Image quality for compression (0–100). Only applies to images.
  final int imageQuality;

  /// Maximum pixel width when compressing. Only applies to images.
  final double maxWidth;

  const MediaPickerGrid({
    super.key,
    required this.files,
    required this.onChanged,
    this.maxFiles = 10,
    this.maxFileSizeBytes = 10 * 1024 * 1024,
    this.imageQuality = 80,
    this.maxWidth = 1200,
  });

  @override
  State<MediaPickerGrid> createState() => _MediaPickerGridState();
}

class _MediaPickerGridState extends State<MediaPickerGrid> {
  final ImagePicker _picker = ImagePicker();

  // ── Helpers ──

  static const _videoExtensions = {
    '.mp4',
    '.mov',
    '.avi',
    '.mkv',
    '.wmv',
    '.flv',
    '.webm',
    '.3gp',
  };

  bool _isVideo(File file) {
    final ext = file.path.split('.').last.toLowerCase();
    return _videoExtensions.contains('.$ext');
  }

  int get _remaining => widget.maxFiles - widget.files.length;

  Future<bool> _checkSize(File file) async {
    if (await file.length() > widget.maxFileSizeBytes) {
      AppSnackbar.showError(message: 'file_too_large'.tr);
      return false;
    }
    return true;
  }

  // ── Pick Actions ──

  /// Pick images & videos from gallery using pickMultipleMedia.
  Future<void> _pickFromGallery() async {
    if (_remaining <= 0) {
      AppSnackbar.showError(message: 'max_files_reached'.tr);
      return;
    }

    final picked = await _picker.pickMultipleMedia();

    if (picked.isNotEmpty) {
      final toAdd = <File>[];
      for (final xf in picked.take(_remaining)) {
        final file = File(xf.path);
        if (await _checkSize(file)) toAdd.add(file);
      }
      if (toAdd.isNotEmpty) {
        widget.onChanged([...widget.files, ...toAdd]);
      }
    }
  }

  /// Take a photo from camera.
  Future<void> _takePhoto() async {
    if (_remaining <= 0) {
      AppSnackbar.showError(message: 'max_files_reached'.tr);
      return;
    }

    final picked = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: widget.imageQuality,
      maxWidth: widget.maxWidth,
    );

    if (picked != null) {
      final file = File(picked.path);
      if (await _checkSize(file)) {
        widget.onChanged([...widget.files, file]);
      }
    }
  }

  /// Record a video from camera.
  Future<void> _recordVideo() async {
    if (_remaining <= 0) {
      AppSnackbar.showError(message: 'max_files_reached'.tr);
      return;
    }

    final picked = await _picker.pickVideo(source: ImageSource.camera);

    if (picked != null) {
      final file = File(picked.path);
      if (await _checkSize(file)) {
        widget.onChanged([...widget.files, file]);
      }
    }
  }

  void _removeFile(int index) {
    final updated = List<File>.from(widget.files)..removeAt(index);
    widget.onChanged(updated);
  }

  // ── Bottom Sheet ──

  void _showSourceSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppLightTheme.backgroundWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.photo_library_outlined,
                  color: AppLightTheme.goldPrimary,
                ),
                title: Text('gallery'.tr),
                subtitle: Text('images_and_videos'.tr),
                onTap: () {
                  Navigator.pop(context);
                  _pickFromGallery();
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.camera_alt_outlined,
                  color: AppLightTheme.goldPrimary,
                ),
                title: Text('take_photo'.tr),
                onTap: () {
                  Navigator.pop(context);
                  _takePhoto();
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.videocam_outlined,
                  color: AppLightTheme.goldPrimary,
                ),
                title: Text('record_video'.tr),
                onTap: () {
                  Navigator.pop(context);
                  _recordVideo();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Build ──

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Media preview list
        if (widget.files.isNotEmpty) ...[
          SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: widget.files.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, index) => _buildMediaTile(index),
            ),
          ),
          const SizedBox(height: 12),
        ],

        // Add-media button
        GestureDetector(
          onTap: _showSourceSheet,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              color: AppLightTheme.surfaceGrey,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppLightTheme.dividerColor),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.add_photo_alternate_outlined,
                  size: 36,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 8),
                Text(
                  'add_media'.tr,
                  style: TextStyles.bodyMedium(
                    isDark: false,
                  ).copyWith(color: Colors.grey[500]),
                ),
                const SizedBox(height: 4),
                Text(
                  '${widget.files.length} / ${widget.maxFiles}',
                  style: TextStyles.bodyMedium(
                    isDark: false,
                  ).copyWith(color: Colors.grey[400], fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMediaTile(int index) {
    final file = widget.files[index];
    final isVid = _isVideo(file);

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: isVid
              ? Container(
                  width: 120,
                  height: 120,
                  color: Colors.black87,
                  child: const Center(
                    child: Icon(
                      Icons.play_circle_outline,
                      color: Colors.white70,
                      size: 40,
                    ),
                  ),
                )
              : Image.file(file, width: 120, height: 120, fit: BoxFit.cover),
        ),
        // Remove button
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => _removeFile(index),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(4),
              child: const Icon(Icons.close, color: Colors.white, size: 16),
            ),
          ),
        ),
        // Video badge
        if (isVid)
          Positioned(
            bottom: 4,
            left: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'VIDEO',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ── Backward-compatible alias ──
typedef ImagePickerGrid = MediaPickerGrid;
