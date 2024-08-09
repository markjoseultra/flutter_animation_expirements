import 'package:flutter/material.dart';

class CustomImplicitAnimation extends StatefulWidget {
  const CustomImplicitAnimation({super.key});

  @override
  State<CustomImplicitAnimation> createState() =>
      _CustomImplicitAnimationState();
}

class _CustomImplicitAnimationState extends State<CustomImplicitAnimation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 50),
          duration: const Duration(seconds: 5),
          child: const Icon(Icons.refresh),
          builder: (context, angle, child) {
            return Transform.rotate(
              angle: angle,
              child: child,
            );
          },
        ),
      ),
    );
  }
}
