enum AppKey {
  onboardingSeen,
  isLogin,
  userData,
}

extension AppKeyString on AppKey {
  String get value {
    switch (this) {
      case AppKey.onboardingSeen:
        return 'onboarding_seen';
      case AppKey.isLogin:
        return 'isLogin';
      case AppKey.userData:
        return 'userData';
    }
  }
}
