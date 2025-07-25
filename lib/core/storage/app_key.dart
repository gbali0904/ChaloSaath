enum AppKey {
  onboardingSeen,
  isLogin,
  email,
  uid,
  userData,
  isFirstLaunch,
  googleData,
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
      case AppKey.email:
        return 'email';
      case AppKey.uid:
        return 'uid';
      case AppKey.isFirstLaunch:
        return 'isFirstLaunch';
      case AppKey.googleData:
        return 'googleData';
    }
  }
}
