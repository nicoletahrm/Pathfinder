import 'package:flutter/material.dart';
import 'package:pathfinder_app/screens/trail_details_screen.dart';
import '../models/trail.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../utils/constant_colors.dart';

class TrailsList extends StatelessWidget {
  final List<Trail> trails;

  const TrailsList({super.key, required this.trails});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 545.0,
      child: Expanded(
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: trails.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TrailDetailsScreen(
                    index: index,
                    title: trails[index].title,
                  ),
                ),
              ),
              child: Stack(
                children: <Widget>[
                  Hero(
                    tag: "trail$index",
                    child: Container(
                      height: 160.0,
                      width: 700.0,
                      margin: EdgeInsets.only(top: index == 0 ? 0 : 20.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14.0),
                        image: DecorationImage(
                          image: AssetImage(trails[index].coverImage),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 160.0,
                    width: 700.0,
                    margin: EdgeInsets.only(top: index == 0 ? 0 : 20.0),
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
                          trails[index].difficulty.name,
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
                      trails[index].title,
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
          },
        ),
      ),
    );
  }
}
