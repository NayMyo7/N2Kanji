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
            const SizedBox(height: AppSizes.xl),
            const Text('Developer: Nay Myo Htet'),
            const Text('Email: nay.dragonboy@gmail.com'),
            const SizedBox(height: AppSizes.xl),
            const _CreditsSection(),
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
            'N2Kanji',
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

class _CreditsSection extends StatelessWidget {
  const _CreditsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Credits & Open Source',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: AppSizes.md),
        const Text('This app includes data from the following projects:'),
        const SizedBox(height: AppSizes.md),
        const Text('Kanji stroke order'),
        const Text('KanjiVG — CC BY-SA 3.0'),
        const Text('https://github.com/KanjiVG/kanjivg'),
        const SizedBox(height: AppSizes.md),
        const Text('Kanji dictionary'),
        const Text('KANJIDIC2 — EDRDG'),
        const Text('https://www.edrdg.org/wiki/index.php/KANJIDIC_Project'),
        const SizedBox(height: AppSizes.md),
        const Text('Example sentences'),
        const Text('Tatoeba Project — CC BY 2.0'),
        const Text('https://tatoeba.org'),
      ],
    );
  }
}
