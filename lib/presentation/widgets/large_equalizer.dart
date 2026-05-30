import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class LargeEqualizer extends StatefulWidget {
  final bool isPlaying;

  const LargeEqualizer({
    super.key,
    required this.isPlaying,
  });

  @override
  State<LargeEqualizer> createState() => _LargeEqualizerState();
}

class _LargeEqualizerState extends State<LargeEqualizer> with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _animations;
  final int barCount = 11;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      barCount,
      (index) => AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 300 + _random.nextInt(500)),
      ),
    );

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0.1, end: 0.4 + _random.nextDouble() * 0.6)
          .animate(CurvedAnimation(parent: controller, curve: Curves.easeInOutSine));
    }).toList();

    if (widget.isPlaying) {
      _startAnimations();
    }
  }

  void _startAnimations() {
    for (var i = 0; i < barCount; i++) {
      Future.delayed(Duration(milliseconds: _random.nextInt(200)), () {
        if (mounted && widget.isPlaying) {
          _controllers[i].repeat(reverse: true);
        }
      });
    }
  }

  void _stopAnimations() {
    for (var controller in _controllers) {
      controller.stop();
      controller.animateTo(0.1, duration: const Duration(milliseconds: 300));
    }
  }

  @override
  void didUpdateWidget(LargeEqualizer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying && !oldWidget.isPlaying) {
      _startAnimations();
    } else if (!widget.isPlaying && oldWidget.isPlaying) {
      _stopAnimations();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(barCount, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: AnimatedBuilder(
            animation: _animations[index],
            builder: (context, child) {
              return Container(
                width: 12,
                height: 120 * _animations[index].value,
                decoration: BoxDecoration(
                  color: AppColors.premiumGold,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.premiumGold.withOpacity(0.5),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
