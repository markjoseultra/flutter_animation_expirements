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

class BasicParallaxAnimation extends StatefulWidget {
  const BasicParallaxAnimation({super.key});

  @override
  State<BasicParallaxAnimation> createState() => _BasicParallaxAnimationState();
}

class _BasicParallaxAnimationState extends State<BasicParallaxAnimation> {
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
  const LocationListItem({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.country,
  });

  final String imageUrl;
  final String name;
  final String country;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              _buildParallaxBackground(context),
              _buildGradient(),
              _buildTitleAndSubtitle(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParallaxBackground(BuildContext context) {
    return Positioned.fill(
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
      ),
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

  Widget _buildTitleAndSubtitle() {
    return Positioned(
      left: 20,
      bottom: 20,
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
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
