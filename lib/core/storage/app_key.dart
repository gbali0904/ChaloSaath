enum AppKey {
  onboardingSeen,
}

extension AppKeyString on AppKey {
  String get value {
    switch (this) {
      case AppKey.onboardingSeen:
        return 'onboarding_seen';
    }
  }
}
