import 'package:flutter/material.dart';

import '../../core/core.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: ListView(
          children: [
            const _AboutHeader(),
            const SizedBox(height: AppSizes.lg),
            _DeveloperSection(),
            const SizedBox(height: AppSizes.lg),
            _ResourceSection(),
            const SizedBox(height: AppSizes.lg),
            const _OpenSourceSection(),
          ],
        ),
      ),
    );
  }
}

class _AboutHeader extends StatelessWidget {
  const _AboutHeader();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.lg),
            child: Image.asset(
              'assets/icons/ic_launcher.png',
              width: 96,
              height: 96,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'N2 Kanji',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: AppSizes.xs),
          Text('Version 3.0.0', style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _DeveloperSection extends StatelessWidget {
  const _DeveloperSection();

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Developer',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoRow(
            icon: Icons.person,
            label: 'Name',
            value: 'Nay Myo Htet',
          ),
          const SizedBox(height: AppSizes.sm),
          _InfoRow(
            icon: Icons.email,
            label: 'Email',
            value: 'nay.dragonboy@gmail.com',
          ),
        ],
      ),
    );
  }
}

class _ResourceSection extends StatelessWidget {
  const _ResourceSection();

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Resource',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoRow(
            icon: Icons.book,
            label: 'Textbook',
            value: '日本語総まとめ N2 漢字',
          ),
          const SizedBox(height: AppSizes.sm),
          _InfoRow(
            icon: Icons.description,
            label: 'Publisher',
            value: 'Ask Publishing',
          ),
        ],
      ),
    );
  }
}

class _OpenSourceSection extends StatelessWidget {
  const _OpenSourceSection();

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Open Source',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ResourceItem(
            title: 'Kanji stroke order',
            subtitle: 'KanjiVG — CC BY-SA 3.0',
            url: 'https://github.com/KanjiVG/kanjivg',
          ),
          const SizedBox(height: AppSizes.md),
          _ResourceItem(
            title: 'Kanji dictionary',
            subtitle: 'KANJIDIC2 — EDRDG',
            url: 'https://www.edrdg.org/wiki/index.php/KANJIDIC_Project',
          ),
          const SizedBox(height: AppSizes.md),
          _ResourceItem(
            title: 'Example sentences',
            subtitle: 'Tatoeba Project — CC BY 2.0',
            url: 'https://tatoeba.org',
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        border: Border.all(color: AppColors.divider),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
            ),
            const SizedBox(height: AppSizes.md),
            child,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: AppSizes.iconSizeSm,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: AppSizes.sm),
        Text(
          '$label: ',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ],
    );
  }
}

class _ResourceItem extends StatelessWidget {
  const _ResourceItem({
    required this.title,
    required this.subtitle,
    required this.url,
  });

  final String title;
  final String subtitle;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
        ),
        const SizedBox(height: AppSizes.xs),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        const SizedBox(height: AppSizes.xs),
        Text(
          url,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.primary,
                decoration: TextDecoration.underline,
              ),
        ),
      ],
    );
  }
}
