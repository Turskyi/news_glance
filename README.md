[![Stand With Ukraine](https://raw.githubusercontent.com/vshymanskyy/StandWithUkraine/main/banner-direct-single.svg)](https://stand-with-ukraine.pp.ua)
[![Build & upload to Firebase App Distribution](https://github.com/Turskyi/news_glance/actions/workflows/flutter_ci.yml/badge.svg?branch=dev&event=push)](https://appdistribution.firebase.dev/i/84a5fda691af5a9b)
[![Codemagic build status](https://api.codemagic.io/apps/65dd5f020e35003c3f27e19f/65dd5f020e35003c3f27e19e/status_badge.svg)](https://play.google.com/store/apps/details?id=com.turskyi.news_glance)
[![Code Quality](https://github.com/Turskyi/news_glance/actions/workflows/code-quality-tests.yml/badge.svg?branch=master&event=push)](https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo)
[![style: flutter lints](https://img.shields.io/badge/style-flutter__lints-blue)](https://pub.dev/packages/flutter_lints)
<img alt="GitHub commit activity" src="https://img.shields.io/github/commit-activity/m/Turskyi/news_glance">

# News Glance

News Glance is a flutter app that lets you access the latest news and insights
from your home screen widget. It uses AI to generate a conclusion from the news
headlines and allows you to view and share the articles.

## PROJECT SPECIFICATION

• Programming language: [Dart](https://dart.dev/);

• SDK: [Flutter](https://flutter.dev/);

• Interface: [Flutter](https://flutter.dev/docs/development/ui);

• Version control system: [Git](https://git-scm.com);

• Git Hosting Service: [GitHub](https://github.com);

• RESTful API: [News API](https://newsapi.org);

• CI/CD: [GitHub Actions](https://docs.github.com/en/actions) is used to deliver
new Android Package (APK) to
[Firebase App Distribution](https://firebase.google.com/docs/app-distribution)
after every push to any other than the **master**branch,
[Codemagic](https://codemagic.io/start/) is used to deliver new release app
bundle to **Google Play** after every merge (push) to **master** branch;

• State management approach: [BLoC](https://bloclibrary.dev);

• App testing platforms:
[Firebase App Distribution](https://appdistribution.firebase.dev/i/84a5fda691af5a9b);

**Code Readability:** code is easily readable with no unnecessary blank lines,
no unused variables or methods, and no commented-out code, all variables,
methods, and resource IDs are descriptively named such that another developer
reading the code can easily understand their function.

# Getting Started

## To create generated files, run:

```
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

## Screenshots:

<!--suppress CheckImageSize -->
<img src="screenshots/home_no_conclusion_20240228.png" width="400"  alt="screenshot">
<img src="screenshots/home_20240228.png" width="400"  alt="screenshot">
<img src="screenshots/home_widget_20240228.png" width="400"  alt="screenshot">

## Screen Recording:

<img src="screen_recordings/screen_recording_20240228.gif" width="400"  alt="screenshot">

## Credits

This project is based on the codelab
[Adding a Home Screen widget to your Flutter App](https://codelabs.developers.google.com/flutter-home-screen-widgets)
by Leigha Jarett and Eric Windmill.

## Download

<a href="https://play.google.com/store/apps/details?id=com.turskyi.news_glance" target="_blank">
<img src="https://play.google.com/intl/en_gb/badges/static/images/badges/en_badge_web_generic.png" width=240  alt="google play badge"/>
</a>
