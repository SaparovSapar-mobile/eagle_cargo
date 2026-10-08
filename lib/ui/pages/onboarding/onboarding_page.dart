import 'package:flutter/material.dart';
import 'package:eagle_cargo/core/preferences/preference_keys.dart';
import 'package:eagle_cargo/core/preferences/preferences_util.dart';
import 'package:eagle_cargo/core/routes/routes.dart';
import 'package:eagle_cargo/core/utils/palette.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<_OnboardData> pages = [
    _OnboardData(
      title: "Fast Air Freight",
      subtitle: "Move your packages fast and safely via global air networks.",
      image: "assets/images/air.jpg",
    ),
    _OnboardData(
      title: "Reliable Road Transport",
      subtitle: "Secure road freight delivery with real-time tracking.",
      image: "assets/images/truck.jpg",
    ),
    _OnboardData(
      title: "Global Sea Freight",
      subtitle: "Best rates for large cargo with worldwide sea shipping.",
      image: "assets/images/sea.jpg",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: pages.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemBuilder: (context, index) {
              return _buildOnboard(pages[index]);
            },
          ),

          // Indicator + Bottom Button
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: Column(
              children: [
                SmoothPageIndicator(
                  controller: _controller,
                  count: pages.length,
                  effect: ExpandingDotsEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    activeDotColor: Palette.primaryLight,
                    dotColor: Colors.white38,
                  ),
                ),

                const SizedBox(height: 20),

                // Animated "Get Started" button
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnboard(_OnboardData data) {
    return Stack(
      children: [
        Positioned.fill(child: Image.asset(data.image, fit: BoxFit.cover)),

        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 255 * 0.7),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),

        Positioned(
          bottom: 120,
          left: 24,
          right: 24,
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                data.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                data.subtitle,
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 40),

              // NEXT BUTTON
              GestureDetector(
                onTap: () {
                  if (_currentPage < pages.length - 1) {
                    _controller.animateToPage(
                      _currentPage + 1,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    PreferenceManager.instance
                        .setBoolValue(PreferenceKeys.IS_FIRST_APP, false)
                        .then((value) {
                          if (!mounted) return;
                          Navigator.pushReplacementNamed(context, Routes.login);
                        });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 255 * 0.15),
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Palette.primary,
                        ),
                        child: const Icon(
                          Icons.local_shipping,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _currentPage < pages.length - 1
                            ? "Next"
                            : "Get Started",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OnboardData {
  final String title;
  final String subtitle;
  final String image;

  _OnboardData({
    required this.title,
    required this.subtitle,
    required this.image,
  });
}
