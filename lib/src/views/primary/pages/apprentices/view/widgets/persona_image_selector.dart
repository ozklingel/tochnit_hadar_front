import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/colors.dart';
import 'package:hadar_program/src/models/persona/persona.dto.dart';
import 'package:hadar_program/src/services/api/export_import/upload_file.dart';
import 'package:hadar_program/src/views/primary/pages/apprentices/controller/personas_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class PersonaImageSelector extends ConsumerWidget {
  const PersonaImageSelector(this.persona, {super.key});

  final PersonaDto persona;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ImagePicker picker = ImagePicker();
    Future<void> updateImage(ImageSource? imageSource) async {
      late final String uploadUrl;
      if (imageSource != null) {
        final file = await picker.pickImage(source: imageSource);
        if (file == null) return;
        uploadUrl = await ref.read(uploadXFileProvider(file).future);
      } else {
        uploadUrl = '';
      }
      final result = await ref
          .read(personasControllerProvider.notifier)
          .edit(persona: persona.copyWith(avatar: uploadUrl));
      if (result && context.mounted) Navigator.pop(context);
    }

    return SizedBox(
      width: 300,
      height: 160,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'תמונת פרופיל',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(FluentIcons.delete_24_regular),
                  onPressed: () async => updateImage(null),
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.gray7,
            child: IconButton(
              icon: Icon(icon),
              onPressed: onPressed,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(option),
          ),
        ],
      ),
    );
  }
}
