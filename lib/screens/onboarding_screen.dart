import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:islamic_habits/l10n/generated/app_localizations.dart';
import 'package:islamic_habits/utility/constants.dart';

/// First-run welcome tour. Shown once from LoadingScreen, gated by a
/// SharedPreferences flag, and dismissed with Skip or the final button.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<_OnboardingSlide> _slides(AppLocalizations l10n) => <_OnboardingSlide>[
        _OnboardingSlide(
          title: l10n.onboardingWelcomeTitle,
          body: l10n.onboardingWelcomeBody,
          isLogo: true,
        ),
        _OnboardingSlide(
          title: l10n.onboardingHabitsTitle,
          body: l10n.onboardingHabitsBody,
          icon: Icons.checklist_rounded,
          image: 'assets/onboarding/today.png',
        ),
        _OnboardingSlide(
          title: l10n.onboardingPrayerTitle,
          body: l10n.onboardingPrayerBody,
          icon: Icons.mosque_outlined,
          image: 'assets/onboarding/prayer_times.png',
        ),
        _OnboardingSlide(
          title: l10n.onboardingRemindersTitle,
          body: l10n.onboardingRemindersBody,
          icon: Icons.notifications_active_outlined,
          image: 'assets/onboarding/add_habit.png',
        ),
        _OnboardingSlide(
          title: l10n.onboardingStatsTitle,
          body: l10n.onboardingStatsBody,
          icon: Icons.insights_rounded,
          image: 'assets/onboarding/statistics.png',
        ),
      ];

  void _next(int lastIndex) {
    if (_page >= lastIndex) {
      _finish();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 360),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _finish() => Navigator.of(context).pop(true);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final slides = _slides(l10n);
    final isLast = _page == slides.length - 1;
    return Scaffold(
      backgroundColor: kBrandNavy,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Color(0xFF1A3B6F),
              kBrandNavy,
              Color(0xFF060B14),
            ],
            stops: <double>[0.0, 0.55, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                child: Row(
                  children: <Widget>[
                    if (_page == 0)
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          l10n.appTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    const Spacer(),
                    TextButton(
                      onPressed: _finish,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white70,
                      ),
                      child: Text(l10n.onboardingSkip),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: slides.length,
                  onPageChanged: (index) => setState(() => _page = index),
                  itemBuilder: (context, index) =>
                      _SlidePage(slide: slides[index]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 4, 24, 20),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List<Widget>.generate(slides.length, (i) {
                        final active = i == _page;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 8,
                          width: active ? 24 : 8,
                          decoration: BoxDecoration(
                            color: active ? Colors.white : Colors.white38,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => _next(slides.length - 1),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: kBrandNavy,
                          minimumSize: const Size.fromHeight(54),
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(isLast
                                ? l10n.onboardingGetStarted
                                : l10n.onboardingNext),
                            if (!isLast) ...[
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward_rounded, size: 20),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingSlide {
  final String title;
  final String body;
  final IconData? icon;

  /// Screenshot captured from the running app and shown inside a phone frame.
  final String? image;
  final bool isLogo;

  const _OnboardingSlide({
    required this.title,
    required this.body,
    this.icon,
    this.image,
    this.isLogo = false,
  });
}

class _SlidePage extends StatelessWidget {
  final _OnboardingSlide slide;
  const _SlidePage({required this.slide});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 10),
      // The visual takes every pixel left over by the caption: the title and
      // body are a fixed block at the bottom of the page, while the
      // screenshot scales to fill the space above them.
      child: Column(
        children: <Widget>[
          Expanded(
            child: LayoutBuilder(
              builder: (context, imageConstraints) {
                // The phone frame adds 6px of padding plus a 1.2px border on
                // every side; reserve a little extra so it never overflows.
                const double chrome = 16;
                final double maxWidth =
                    math.max(0.0, imageConstraints.maxWidth - chrome);
                final double maxHeight =
                    math.max(0.0, imageConstraints.maxHeight - chrome);

                if (slide.isLogo) {
                  final double logoSize = math
                      .min(maxWidth * 0.62, maxHeight * 0.72)
                      .clamp(104.0, 220.0)
                      .toDouble();
                  return Center(child: _LogoBadge(size: logoSize));
                }

                if (slide.image != null) {
                  const double screenshotRatio = 1344 / 2992;
                  double imageHeight = maxHeight;
                  double imageWidth = imageHeight * screenshotRatio;
                  if (imageWidth > maxWidth) {
                    imageWidth = maxWidth;
                    imageHeight = imageWidth / screenshotRatio;
                  }
                  return Center(
                    child: _PhoneFrame(
                      image: slide.image!,
                      width: imageWidth,
                      height: imageHeight,
                    ),
                  );
                }

                final double badgeSize = math
                    .min(maxWidth, maxHeight)
                    .clamp(96.0, 180.0)
                    .toDouble();
                return Center(
                  child: _IconBadge(icon: slide.icon, size: badgeSize),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Text(
            slide.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
              height: 1.18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            slide.body,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 15,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _LogoBadge extends StatelessWidget {
  final double size;
  const _LogoBadge({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(size * 0.07),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.28),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/branding/logo.png',
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  final IconData? icon;
  final double size;
  const _IconBadge({this.icon, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Icon(
        icon ?? Icons.auto_awesome,
        size: size * 0.46,
        color: Colors.white,
      ),
    );
  }
}

/// Real in-app screenshot presented in a subtle phone-shaped frame.
class _PhoneFrame extends StatelessWidget {
  final String image;
  final double width;
  final double height;

  const _PhoneFrame({
    required this.image,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFF0B0B0B),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.white24, width: 1.2),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.38),
            blurRadius: 26,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          image,
          width: width,
          height: height,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.medium,
        ),
      ),
    );
  }
}
