import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

@immutable
class GeoCoor {
  final double lng;
  final double lat;

  const GeoCoor({required this.lng, required this.lat});

  factory GeoCoor.fromJson(Map<String, dynamic> data) {
    return GeoCoor(lat: data["lat"] ?? 0.0, lng: data['lng'] ?? 0.0);
  }
}

@immutable
class Wonder {
  final String id;
  final String name;
  final String description;
  final String address;
  final String image;
  final GeoCoor geolocation;

  const Wonder({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.image,
    required this.geolocation,
  });

  factory Wonder.fromJson(Map<String, dynamic> data) {
    return Wonder(
        id: data["id"] ?? "",
        name: data['name'] ?? "",
        description: data['description'] ?? "",
        address: data['address'] ?? "",
        image: data['image'] ?? "",
        geolocation: GeoCoor.fromJson(data['geolocation']));
  }
}

class AdvanceParallaxAnimation extends StatefulWidget {
  const AdvanceParallaxAnimation({super.key});

  @override
  State<AdvanceParallaxAnimation> createState() =>
      _AdvanceParallaxAnimationState();
}

class _AdvanceParallaxAnimationState extends State<AdvanceParallaxAnimation> {
  List<Wonder> _renderWonders = [];

  Future<void> loadData() async {
    String jsonString =
        await rootBundle.loadString("assets/json/seven_wonders_of_nature.json");

    final data = jsonDecode(jsonString);

    List<Wonder> wonders = [];

    for (var wonder in data) {
      wonders.add(Wonder.fromJson(wonder));
    }

    setState(() {
      _renderWonders = wonders;
    });
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: _renderWonders.map((wonder) {
          return LocationListItem(
            key: Key(wonder.id),
            name: wonder.name,
            imageUrl: wonder.image,
            country: wonder.address,
          );
        }).toList(),
      ),
    );
  }
}

@immutable
class LocationListItem extends StatelessWidget {
  LocationListItem({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.country,
  });

  final String imageUrl;
  final String name;
  final String country;

  final GlobalKey _backgroundImageKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: AspectRatio(
        aspectRatio: 16 / 8,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              _buildParallaxBackground(context),
              _buildGradient(),
              _buildTitleAndSubtitle(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParallaxBackground(
    BuildContext context,
  ) {
    return Flow(
      delegate: ParallaxFlowDelegate(
        listItemContext: context,
        scrollable: Scrollable.of(context),
        backgroundImageKey: _backgroundImageKey,
      ),
      children: [
        Image.network(
          key: _backgroundImageKey,
          imageUrl,
          fit: BoxFit.cover,
        ),
      ],
    );
  }

  Widget _buildGradient() {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.6, 0.95],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleAndSubtitle(BuildContext context) {
    return Positioned(
      left: 20,
      bottom: 20,
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 1.3,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              country,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ParallaxFlowDelegate extends FlowDelegate {
  final ScrollableState scrollable;
  final BuildContext listItemContext;
  final GlobalKey backgroundImageKey;

  ParallaxFlowDelegate({
    required this.scrollable,
    required this.listItemContext,
    required this.backgroundImageKey,
  }) : super(repaint: scrollable.position);

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
    return BoxConstraints.tightFor(
      width: constraints.maxWidth,
    );
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    // Calculate the position of this list item within the viewport.
    final scrollableBox = scrollable.context.findRenderObject() as RenderBox;
    final listItemBox = listItemContext.findRenderObject() as RenderBox;
    final listItemOffset = listItemBox.localToGlobal(
        listItemBox.size.centerLeft(Offset.zero),
        ancestor: scrollableBox);

    // Determine the percent position of this list item within the
    // scrollable area.
    final viewportDimension = scrollable.position.viewportDimension;
    final scrollFraction =
        (listItemOffset.dy / viewportDimension).clamp(0.0, 1.0);

    // Calculate the vertical alignment of the background
    // based on the scroll percent.
    final verticalAlignment = Alignment(0.0, scrollFraction * 2 - 1);

    // Convert the background alignment into a pixel offset for
    // painting purposes.
    final backgroundSize =
        (backgroundImageKey.currentContext!.findRenderObject() as RenderBox)
            .size;
    final listItemSize = context.size;
    final childRect =
        verticalAlignment.inscribe(backgroundSize, Offset.zero & listItemSize);

    // Paint the background.
    context.paintChild(
      0,
      transform:
          Transform.translate(offset: Offset(0.0, childRect.top)).transform,
    );
  }

  @override
  bool shouldRepaint(ParallaxFlowDelegate oldDelegate) {
    return scrollable != oldDelegate.scrollable ||
        listItemContext != oldDelegate.listItemContext ||
        backgroundImageKey != oldDelegate.backgroundImageKey;
  }
}
