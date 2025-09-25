import 'package:flutter/material.dart';
import '../models/onboarding_model.dart';
import '../widgets/onboarding_pages.dart';
import '../themes/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingItem> onboardingData = [
    OnboardingItem(
      image:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuASSU4G-rADVI1Hf0cgpHaiPwddvtjwgixMSovmXSOqKuVSj10L_SFHxZEAO2N7Od1bZB2ElOrDXQ7Pxv5ZmabrNtfKNSFJtIsCQZCbQ8xUMLDHQmGZ__UqE0zJZurtCQcbPgFNnizNNvHLe9pMvgCUP6ufIbdCdqbkIgaNrLGsZ_n2O0ooO1y2numn40pedUaFoucV-HXg4HBpwpfohhcoubWCGhQVlC_YBV2kJVKRsitFcnLBmumLrZ5AFG4n1whBuvlwE82u3DI',
      title: 'Confused about your next steps?',
      description:
          "Choosing the right path after Class 10/12 can be tough. We're here to help you navigate your options and find the perfect fit.",
    ),

    OnboardingItem(
      image:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBVq2a_TOcywmsiLTHADJmYyF_snfXm5eK6bk-2nfHEQFNXUi0wQJVf_nSWPBhAwA_9jGDBA1P4TiG6L6vC3fitDyGwzkj3iqndDBAOjhIgAVPP5N1FSGgFtP0cP6PXlI5VbaNrIobLY__Ry_O8UHFA2U1hV9K3sV6se8vyFsupRipkOUZDq5xE4x2V4FSu7o_3iHTX-duClAAxWTjcMT7x8HFVnN-4VOitT6Qhgp4wDLVYWlRrfRgXa24xWt7C2uU_tmg2Jgs6tOg',
      title: 'Guidance, Career Mapping, College Info',
      description:
          'We\'ll help you navigate your academic journey with personalized guidance, career mapping, and detailed college information.',
    ),
    OnboardingItem(
      image:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCCnJTijCR5Skbf_lzuOkqQpvmS94k2dBoXmeiRVvvo32KLWh3Wo2KHAqASRhudvxc0PRxxXdTvxn7TgDuyfZgDo8m3p_7_TSm59inMG0PE2MRHhXL6Jn20QMSa9bomQLADE5lOdJvnK729dng6o2-_3BJDsk_9G8Ojn3G2oYiGMP6rC6AntRI9LEXb97Uud5FLwzi2bkpHTpTyFmuLUamFMkdSgugsRgUeXkG3_KOGfdpNvA6aMc8VGZs7l_ywwaBHRcmKDJe7t2w',
      title: 'Explore Your Future',
      description:
          'Discover your potential with our aptitude quiz, explore diverse career paths, and browse our comprehensive college directory.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentPage < onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  void _onSkip() {
    _pageController.jumpToPage(onboardingData.length - 1);
  }

  bool get isLastPage => _currentPage == onboardingData.length - 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightBackgroundColor,
      body: SafeArea(
        child: Builder(
          builder: (context) {
            SizeConfig.init(context); // Now context is fully laid out

            return Padding(
              padding: EdgeInsets.all(kPadding),
              child: Column(
                children: [
                  // Progress Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(onboardingData.length, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        height: 8.0,
                        width: index == _currentPage ? 32.0 : 8.0,
                        decoration: BoxDecoration(
                          color: index == _currentPage
                              ? kPrimaryColor
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      );
                    }),
                  ),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: onboardingData.length,
                      physics:
                          const BouncingScrollPhysics(), // Enables mouse/touch swiping
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return OnboardingPage(item: onboardingData[index]);
                      },
                    ),
                  ),
                  // Action Buttons
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                        onPressed: isLastPage ? null : _onNext,
                        child: Text(
                          isLastPage ? 'Get Started →' : 'Next',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (!isLastPage)
                        TextButton(
                          onPressed: _onSkip,
                          child: const Text(
                            'Skip',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
