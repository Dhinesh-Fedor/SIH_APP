import 'package:flutter/material.dart';
import '../models/onboarding_model.dart';
import '../themes/app_theme.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingItem item;

  const OnboardingPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.network(
          item.image,
          width: SizeConfig.wp(kImageSize),
          height: SizeConfig.wp(kImageSize),
        ),
        SizedBox(height: kLargePadding),
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
        Padding(
          padding: EdgeInsets.symmetric(horizontal: kLargePadding * 0.75),
          child: Text(
            item.description,
            style: TextStyle(
              fontSize: SizeConfig.wp(kDescFontSize),
              color: kMediumGrayColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
