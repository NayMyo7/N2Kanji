import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/core.dart';

class RateAppDialog extends StatelessWidget {
  const RateAppDialog({super.key});

  static const String _androidUrl =
      'https://play.google.com/store/apps/details?id=com.dragondev.n2kanji';
  static const String _iosUrl = 'https://apps.apple.com/app/id6757802869';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.lg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.md),
              child: Image.asset(
                'assets/icons/ic_launcher.png',
                width: 72,
                height: 72,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: AppSizes.lg),
            Text(
              'Rate N2 Kanji',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: AppSizes.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => Icon(
                  Icons.star,
                  color: AppColors.favouriteActive,
                  size: 32,
                ),
              ),
            ),
            const SizedBox(height: AppSizes.lg),
            Text(
              'Enjoying N2 Kanji? Your feedback helps us improve and reach more learners!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
            ),
            const SizedBox(height: AppSizes.xl),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _launchAppStore(context),
                icon: const Icon(Icons.star, size: AppSizes.iconSizeSm),
                label: const Text('Rate Now'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textOnPrimary,
                  padding: const EdgeInsets.symmetric(vertical: AppSizes.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                  padding: const EdgeInsets.symmetric(vertical: AppSizes.md),
                ),
                child: const Text('Maybe Later'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchAppStore(BuildContext context) async {
    final platform = Theme.of(context).platform;
    final urlString = platform == TargetPlatform.iOS ? _iosUrl : _androidUrl;
    final url = Uri.parse(urlString);

    try {
      final canLaunch = await canLaunchUrl(url);
      if (!canLaunch) {
        if (context.mounted) _showErrorSnackBar(context);
        return;
      }

      await launchUrl(url, mode: LaunchMode.externalApplication);
      if (context.mounted) Navigator.of(context).pop();
    } catch (e) {
      if (context.mounted) _showErrorSnackBar(context);
    }
  }

  void _showErrorSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Could not open app store'),
        backgroundColor: AppColors.error,
      ),
    );
  }

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const RateAppDialog(),
    );
  }
}
