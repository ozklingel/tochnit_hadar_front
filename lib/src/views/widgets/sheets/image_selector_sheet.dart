import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/services/api/export_import/upload_file.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

void showImageSelector({
  required BuildContext context,
  required Future<bool> Function(String uploadUrl) onImageUploaded,
}) =>
    showModalBottomSheet(
      context: context,
      builder: (context) => _ImageSelectorSheet(
        onImageUploaded: onImageUploaded,
      ),
    );

class _ImageSelectorSheet extends ConsumerWidget {
  const _ImageSelectorSheet({
    required this.onImageUploaded,
  });

  final Future<bool> Function(String uploadUrl) onImageUploaded;

  static final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> updateImage(ImageSource? imageSource) async {
      if (imageSource != null) {
        final file = await picker.pickImage(source: imageSource);

        if (file == null) {
          return;
        }

        final uploadUrl = await ref.read(uploadXFileProvider(file).future);
        final result = await onImageUploaded(uploadUrl);

        if (result && context.mounted) {
          Navigator.pop(context);
        }
      }
    }

    return SizedBox(
      height: 180,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'תמונת פרופיל',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                  icon: const Icon(
                    FluentIcons.delete_24_regular,
                    color: AppColors.blue02,
                  ),
                  onPressed: () async => updateImage(null),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _InputOption(
                  icon: Icons.camera_alt_outlined,
                  option: 'מצלמה',
                  onPressed: () async => await updateImage(ImageSource.camera),
                ),
                _InputOption(
                  icon: Icons.image_outlined,
                  option: 'גלריה',
                  onPressed: () async => await updateImage(ImageSource.gallery),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InputOption extends StatelessWidget {
  const _InputOption({
    required this.icon,
    required this.option,
    required this.onPressed,
  });

  final IconData icon;
  final String option;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: AppColors.gray7,
          child: IconButton(
            icon: Icon(
              icon,
              color: AppColors.grey2,
            ),
            onPressed: onPressed,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(option),
        ),
      ],
    );
  }
}
