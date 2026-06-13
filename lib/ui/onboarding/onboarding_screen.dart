import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_glance/application_services/settings_bloc.dart';
import 'package:news_glance/l10n/app_localizations.dart';
import 'package:news_glance/router/app_route.dart';
import 'package:news_glance/ui/onboarding/onboarding_illustration_one.dart';
import 'package:news_glance/ui/onboarding/onboarding_illustration_three.dart';
import 'package:news_glance/ui/onboarding/onboarding_illustration_two.dart';
import 'package:news_glance/ui/onboarding/onboarding_navigation_bar.dart';
import 'package:news_glance/ui/onboarding/onboarding_page_view.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations? l10n = AppLocalizations.of(context);

    if (l10n == null) {
      return const SizedBox.shrink();
    } else {
      return Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  children: <Widget>[
                    OnboardingPageView(
                      title: l10n.onboardingTitle1,
                      body: l10n.onboardingBody1,
                      illustration: const OnboardingIllustrationOne(),
                    ),
                    OnboardingPageView(
                      title: l10n.onboardingTitle2,
                      body: l10n.onboardingBody2,
                      illustration: const OnboardingIllustrationTwo(),
                    ),
                    OnboardingPageView(
                      title: l10n.onboardingTitle3,
                      body: l10n.onboardingBody3,
                      illustration: const OnboardingIllustrationThree(),
                    ),
                  ],
                ),
              ),
              OnboardingNavigationBar(
                currentPage: _currentPage,
                totalPages: 3,
                onNext: _onNext,
                onSkip: _onSkip,
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _onFinish();
    }
  }

  void _onSkip() {
    _onFinish();
  }

  void _onFinish() {
    context.read<SettingsBloc>().add(
      const SetOnboardingCompletedEvent(completed: true),
    );
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pushReplacementNamed(AppRoute.home.path);
    }
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }
}
