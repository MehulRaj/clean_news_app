import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/firebase/firebase_service.dart';
import '../../../../core/premium/premium_manager.dart';
import '../../../../core/theme/app_theme.dart';

class PremiumPage extends StatelessWidget {
  const PremiumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Go Premium'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.star,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            )
                .animate()
                .fadeIn()
                .scale(delay: 300.ms, duration: 500.ms),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Unlock Premium Features',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ).animate().fadeIn().slideY(
                  begin: 0.3,
                  delay: 500.ms,
                  duration: 500.ms,
                ),
            const SizedBox(height: AppSpacing.xxl),
            _buildFeatureCard(
              context,
              icon: Icons.block_flipped,
              title: 'Ad-Free Experience',
              description: 'Enjoy reading without any interruptions',
            ),
            _buildFeatureCard(
              context,
              icon: Icons.summarize,
              title: 'AI Article Summaries',
              description: 'Get instant summaries of any article',
            ),
            _buildFeatureCard(
              context,
              icon: Icons.record_voice_over,
              title: 'Text-to-Speech',
              description: 'Listen to articles while multitasking',
            ),
            _buildFeatureCard(
              context,
              icon: Icons.auto_awesome,
              title: 'Personalized Feed',
              description: 'AI-powered content recommendations',
            ),
            const SizedBox(height: AppSpacing.xxl),
            _PremiumPriceCard(
              price: '\$4.99',
              interval: 'month',
              onSubscribe: () => _handleSubscribe(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Icon(icon, size: 32),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn().slideX(
          begin: 0.3,
          delay: 700.ms,
          duration: 500.ms,
        );
  }

  Future<void> _handleSubscribe(BuildContext context) async {
    try {
      // Here you would implement your actual payment logic
      await sl<PremiumManager>().setPremiumStatus(true);
      await sl<FirebaseService>().updatePremiumStatus(true);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully upgraded to premium!'),
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }
}

class _PremiumPriceCard extends StatelessWidget {
  final String price;
  final String interval;
  final VoidCallback onSubscribe;

  const _PremiumPriceCard({
    required this.price,
    required this.interval,
    required this.onSubscribe,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.headlineMedium,
                children: [
                  TextSpan(
                    text: price,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: '/$interval',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            ElevatedButton(
              onPressed: onSubscribe,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              child: const Text('Subscribe Now'),
            ),
          ],
        ),
      ),
    ).animate().fadeIn().scale(delay: 900.ms, duration: 500.ms);
  }
}
