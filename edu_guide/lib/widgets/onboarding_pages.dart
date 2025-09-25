import 'package:flutter/material.dart';
import '../models/onboarding_model.dart';
import '../themes/app_theme.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingItem item;
  final int currentPage;
  final int totalPages;

  const OnboardingPage({
    super.key,
    required this.item,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    final double imageHeight = SizeConfig.hp(
      0.42,
    ); // Increased from 0.32 to 0.42

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Top: Full-width, fixed-height background image
        SizedBox(
          height: imageHeight,
          width: double.infinity,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: currentPage == totalPages - 1
                  ? Colors
                        .transparent // Transparent on last page
                  : kLightBackgroundColor, // App background on others
              image: DecorationImage(
                image: NetworkImage(item.image),
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
          ),
        ),
        // Middle: Title and description centered
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item.title,
                style: TextStyle(
                  fontSize: SizeConfig.wp(kTitleFontSize),
                  fontWeight: FontWeight.bold,
                  color: kDarkGrayColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: kPadding),
              Text(
                item.description,
                style: TextStyle(
                  fontSize: SizeConfig.wp(kDescFontSize),
                  color: kMediumGrayColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        // Spacer to push indicators and buttons to the bottom
        const Spacer(),
        // Bottom: Page indicators
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(totalPages, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                height: 8.0,
                width: index == currentPage ? 32.0 : 8.0,
                decoration: BoxDecoration(
                  color: index == currentPage
                      ? kPrimaryColor
                      : Colors.grey[300],
                  borderRadius: BorderRadius.circular(4.0),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
