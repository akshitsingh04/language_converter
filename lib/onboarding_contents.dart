class OnboardingContents {
  final String title;
  final String image;
  final String desc;

  OnboardingContents({
    required this.title,
    required this.image,
    required this.desc,
  });
}

List<OnboardingContents> contents = [
  OnboardingContents(
    title: "Get your language translated",
    image: "assets/images/photo4.png",
    desc: "Easily translate text between languages in real-time.",
  ),
  OnboardingContents(
    title: "Translate on the Go",
    image: "assets/images/photo2.png",
    desc:
    "Quickly convert phrases or sentences wherever you are.",
  ),
  OnboardingContents(
    title: "Get seamless experience",
    image: "assets/images/photo3.png",
    desc:
    "Effortlessly translate text and get results in seconds.",
  ),
];