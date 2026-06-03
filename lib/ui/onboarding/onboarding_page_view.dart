import 'package:flutter/material.dart';
import 'package:news_glance/res/constants.dart' as constants;

class OnboardingPageView extends StatelessWidget {
  const OnboardingPageView({
    required this.title,
    required this.body,
    required this.illustration,
    super.key,
  });

  final String title;
  final String body;
  final Widget illustration;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: constants.maxContentWidth),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(flex: 3, child: illustration),
              const SizedBox(height: 40),
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                body,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
