import 'package:flutter/material.dart';

class CustomExplicitAnimation extends StatefulWidget {
  const CustomExplicitAnimation({super.key});

  @override
  State<CustomExplicitAnimation> createState() =>
      _CustomExplicitAnimationState();
}

class _CustomExplicitAnimationState extends State<CustomExplicitAnimation> {
  TimeType timeType = TimeType.day;

  ShapeType bannerShape = ShapeType.circle;

  void handleOnpressed() {
    setState(() {
      timeType = timeType == TimeType.day ? TimeType.night : TimeType.day;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            AnimatedSDayNightBanner(
              timeType: timeType,
              shapeType: bannerShape,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: handleOnpressed, child: const Text("CHANGE")),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      bannerShape = bannerShape == ShapeType.circle
                          ? ShapeType.square
                          : ShapeType.circle;
                    });
                  },
                  child: Text(bannerShape == ShapeType.circle
                      ? "SWITCH TO SQUARE"
                      : "SWITCH TO CIRCLE")),
            )
          ],
        ));
  }
}

enum TimeType { day, night }

enum ShapeType { circle, square }

class AnimatedSDayNightBanner extends StatefulWidget {
  final TimeType timeType;
  final ShapeType? shapeType;
  const AnimatedSDayNightBanner(
      {super.key, required this.timeType, this.shapeType = ShapeType.circle});

  @override
  State<AnimatedSDayNightBanner> createState() =>
      _AnimatedSDayNightBannerState();
}

class _AnimatedSDayNightBannerState extends State<AnimatedSDayNightBanner>
    with TickerProviderStateMixin {
  late final AnimationController _cloud1AnimationController =
      AnimationController(
    duration: const Duration(seconds: 70),
    vsync: this,
  )..repeat(reverse: true);

  late final AnimationController _cloud2AnimationController =
      AnimationController(
    duration: const Duration(seconds: 30),
    vsync: this,
  )..repeat(reverse: true);

  late final AnimationController _cloud3AnimationController =
      AnimationController(
    duration: const Duration(seconds: 90),
    vsync: this,
  )..repeat(reverse: true);

  late final AnimationController _sunAnimationController = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  );

  late final AnimationController _moonAnimationController = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  );

  @override
  void dispose() {
    _cloud1AnimationController.dispose();
    _cloud2AnimationController.dispose();
    _cloud3AnimationController.dispose();
    _sunAnimationController.dispose();
    _moonAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.timeType == TimeType.day) {
      _sunAnimationController.forward();
    } else {
      _sunAnimationController.reverse();
    }

    if (widget.timeType == TimeType.night) {
      _moonAnimationController.forward();
    } else {
      _moonAnimationController.reverse();
    }

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft:
              Radius.circular(widget.shapeType == ShapeType.circle ? 100 : 0),
          bottomRight:
              Radius.circular(widget.shapeType == ShapeType.circle ? 100 : 0),
        ),
        child: Stack(
          children: [
            //BACKGROUND
            AnimatedSwitcher(
              duration: const Duration(seconds: 2),
              child: widget.timeType == TimeType.day
                  ? Image.asset(
                      key: const ValueKey("day_bg"),
                      "assets/images/bg_only_day.png",
                      width: double.infinity,
                      height: 270,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      key: const ValueKey("day_night"),
                      "assets/images/bg_only_night.png",
                      width: double.infinity,
                      height: 270,
                      fit: BoxFit.cover,
                    ),
            ),

            //SUN MOON
            PositionedTransition(
              rect: RelativeRectTween(
                begin: RelativeRect.fromSize(
                  const Rect.fromLTWH(-500, 10, 10, 10),
                  const Size(190, 190),
                ),
                end: RelativeRect.fromSize(
                  const Rect.fromLTWH(220, 10, 10, 10),
                  const Size(190, 190),
                ),
              ).animate(CurvedAnimation(
                parent: _sunAnimationController,
                curve: Curves.elasticInOut,
              )),
              child: Image.asset(
                "assets/images/sun.png",
                width: 100,
                height: 100,
              ),
            ),
            PositionedTransition(
              rect: RelativeRectTween(
                begin: RelativeRect.fromSize(
                  const Rect.fromLTWH(500, 10, 10, 10),
                  const Size(190, 190),
                ),
                end: RelativeRect.fromSize(
                  const Rect.fromLTWH(220, 10, 10, 10),
                  const Size(190, 190),
                ),
              ).animate(CurvedAnimation(
                parent: _moonAnimationController,
                curve: Curves.elasticInOut,
              )),
              child: Image.asset(
                "assets/images/moon.png",
                width: 100,
                height: 100,
              ),
            ),

            //MOVING CLOUDS
            PositionedTransition(
              rect: RelativeRectTween(
                begin: RelativeRect.fromSize(
                  const Rect.fromLTWH(0, 0, 10, 10),
                  const Size(250, 250),
                ),
                end: RelativeRect.fromSize(
                  const Rect.fromLTWH(500, 0, 10, 10),
                  const Size(250, 250),
                ),
              ).animate(CurvedAnimation(
                parent: _cloud3AnimationController,
                curve: Curves.linear,
              )),
              child: SizedBox(
                width: 100,
                height: 100,
                child: Cloud(
                  dayCloudAsset: "assets/images/cloud_3.png",
                  nightCloudAsset: "assets/images/cloud_3_night.png",
                  timeType: widget.timeType,
                  width: 200,
                  height: 200,
                ),
              ),
            ),
            PositionedTransition(
              rect: RelativeRectTween(
                begin: RelativeRect.fromSize(
                  const Rect.fromLTWH(0, 100, 10, 10),
                  const Size(250, 250),
                ),
                end: RelativeRect.fromSize(
                  const Rect.fromLTWH(500, 100, 10, 10),
                  const Size(250, 250),
                ),
              ).animate(CurvedAnimation(
                parent: _cloud1AnimationController,
                curve: Curves.linear,
              )),
              child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Cloud(
                    dayCloudAsset: "assets/images/cloud_1.png",
                    nightCloudAsset: "assets/images/cloud_1_night.png",
                    timeType: widget.timeType,
                    width: 200,
                    height: 200,
                  )),
            ),
            PositionedTransition(
              rect: RelativeRectTween(
                begin: RelativeRect.fromSize(
                  const Rect.fromLTWH(0, 200, 10, 10),
                  const Size(250, 250),
                ),
                end: RelativeRect.fromSize(
                  const Rect.fromLTWH(500, 200, 10, 10),
                  const Size(250, 250),
                ),
              ).animate(CurvedAnimation(
                parent: _cloud2AnimationController,
                curve: Curves.linear,
              )),
              child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Cloud(
                    dayCloudAsset: "assets/images/cloud_2.png",
                    nightCloudAsset: "assets/images/cloud_2_night.png",
                    timeType: widget.timeType,
                    width: 200,
                    height: 200,
                  )),
            ),

            //STATIC CLOUDS
            Positioned(
              right: -50,
              bottom: 0,
              // child: Cloud(
              //   key: const Key("static_cloud_1"),
              //   dayCloudAsset: "assets/images/cloud_3.png",
              //   nightCloudAsset: "assets/images/cloud_3_night.png",
              //   timeType: widget.timeType,
              //   width: 200,
              //   height: 200,
              // ),
              child: AnimatedSwitcher(
                duration: const Duration(seconds: 2),
                child: widget.timeType == TimeType.day
                    ? Image.asset(
                        key: const ValueKey("static_cloud_1_day"),
                        "assets/images/cloud_3.png",
                        width: 200,
                        height: 200,
                        fit: BoxFit.contain,
                      )
                    : Image.asset(
                        key: const ValueKey("static_cloud_1_night"),
                        "assets/images/cloud_3_night.png",
                        width: 200,
                        height: 200,
                        fit: BoxFit.contain,
                      ),
              ),
            ),
            Positioned(
              left: -50,
              top: -50,
              child: Cloud(
                key: const Key("static_cloud_2"),
                dayCloudAsset: "assets/images/cloud_4.png",
                nightCloudAsset: "assets/images/cloud_4_night.png",
                timeType: widget.timeType,
                width: 200,
                height: 200,
              ),
            ),
            Positioned(
              key: const Key("static_cloud_3"),
              left: -100,
              bottom: -50,
              child: Cloud(
                dayCloudAsset: "assets/images/cloud_2.png",
                nightCloudAsset: "assets/images/cloud_2_night.png",
                timeType: widget.timeType,
                width: 200,
                height: 200,
              ),
            ),
          ],
        ),
      );
    });
  }
}

class Cloud extends StatefulWidget {
  final TimeType timeType;
  final String dayCloudAsset;
  final String nightCloudAsset;
  final double width;
  final double height;

  const Cloud({
    super.key,
    required this.timeType,
    required this.dayCloudAsset,
    required this.nightCloudAsset,
    required this.width,
    required this.height,
  });

  @override
  State<Cloud> createState() => _CloudState();
}

class _CloudState extends State<Cloud> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(seconds: 2),
      child: widget.timeType == TimeType.day
          ? Image.asset(
              key: ValueKey("${widget.dayCloudAsset}_day"),
              widget.dayCloudAsset,
              width: widget.width,
              height: widget.height,
              fit: BoxFit.contain,
            )
          : Image.asset(
              key: ValueKey("${widget.dayCloudAsset}_night"),
              widget.nightCloudAsset,
              width: widget.width,
              height: widget.height,
              fit: BoxFit.contain,
            ),
    );
  }
}
