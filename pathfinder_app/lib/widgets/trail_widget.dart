import 'package:flutter/material.dart';
import '../models/trail.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../screens/trail_detail_screen.dart';
import '../utils/constant_colors.dart';

class TrailWidget extends StatelessWidget {
  final int index;
  final double margin;
  final Trail trail;

  const TrailWidget(
      {Key? key,
      required this.index,
      required this.margin,
      required this.trail})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String heroTag = 'trail_${trail.hashCode}_$index';
    ;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return FadeTransition(
                opacity: animation,
                child: TrailDetailScreen(
                  title: trail.title,
                  heroTag: heroTag,
                ),
              );
            },
          ),
        );
      },
      child: Stack(
        children: <Widget>[
          Hero(
            tag: heroTag,
            child: Container(
              height: 160.0,
              width: 700.0,
              margin: EdgeInsets.only(top: margin),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.0),
                image: DecorationImage(
                  image: AssetImage(trail.coverImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            height: 160.0,
            width: 700.0,
            margin: EdgeInsets.only(top: margin),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.0),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black87,
                ],
                stops: [
                  0.6,
                  0.9,
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 24.0,
            right: 24.0,
            child: GlassmorphicContainer(
              height: 32.0,
              width: 75.0,
              blur: 2.0,
              border: 0.0,
              borderRadius: 8.0,
              alignment: Alignment.center,
              linearGradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  kLightColor.withOpacity(0.4),
                  kLightColor.withOpacity(0.4),
                ],
              ),
              borderGradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  kLightColor.withOpacity(0.4),
                  kLightColor.withOpacity(0.4),
                ],
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  trail.difficulty.name,
                  style: const TextStyle(
                    fontSize: 18.0,
                    color: kLightColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 25.0,
            left: 24.0,
            width: MediaQuery.of(context).size.width / 2.6,
            child: Text(
              trail.title,
              style: const TextStyle(
                fontSize: 24.0,
                color: kLightColor,
                fontFamily: "ProximaNovaBold",
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
