import '../data/onboarding_model.dart';

class GetOnboardingData {
  List<OnboardingModel> call() {
    return [
      OnboardingModel(
        image: "assets/onbording_1.png",
        title: "Car Pool",
        desc: "Ride together and reduce the number of vehicles on the road.",
      ),
      OnboardingModel(
        image: "assets/onbording_2.png",
        title: "Save Time & Money",
        desc: "Split fuel and toll costs and arrive faster with shared rides.",
      ),
      OnboardingModel(
        image: "assets/onbording_3.png",
        title: "Eco-Friendly",
        desc: "Help the planet by lowering carbon emissions.",
      ),
      OnboardingModel(
        image: "assets/onbording_4.png",
        title: "Eco-Friendly",
        desc: "Help the planet by lowering carbon emissions.",
      ),
    ];
  }
}
