import 'package:pathfinder_app/models/difficulty.dart';
import 'package:pathfinder_app/models/review_model.dart';

class Trail {
  final int id;
  final String title;
  final String description;
  final String coverImage;
  final List<String>? images;
  final double rating;
  final Duration time;
  final double routeLength;
  final Difficulty difficulty;
  final List<Review>? reviews;
  //marcaj traseu

  Trail({
    required this.id,
    this.images,
    this.rating = 0.0,
    required this.title,
    required this.description,
    required this.coverImage,
    required this.time,
    required this.routeLength,
    required this.difficulty,
    this.reviews,
  });

  final List<Trail> demoRoutes = [
    Trail(
        id: 1,
        title: "Cabana Malaiesti",
        description:
            "Valea Mălăiești este unul dintre cele mai frumoase, dar și cele mai populare locuri din Munții Bucegi în această perioadă din an. Accesul destul de facil și peisajele minunate, fac ca Valea Mălăiești să fie o destinație des aleasă pe parcursul verii. Sunt mai multe variante de trasee, de la 2-3 ore (ca cel prezentat acum), până la 4-5 (cum ar fi urcarea pe poteca și mai frumoasă – Pichetul Roșu – Take Ionescu), iar odată ajuns în Valea Mălăiești, dacă mai ai energie, poți continua să urci spre Vf. Omu prin Hornurile Mălăiești, sau să te îndrepți spre Brâna Caprelor ori Padina Crucii. Atenție însă că multe dintre zone rămân inaccesibile în condiții de siguranță chiar și în prima parte a verii, din cauza „limbilor” de zăpadă care se topesc mai greu și care pot fi periculoase.",
        coverImage: "assets/images/image2.jpg",
        time: const Duration(hours: 6),
        routeLength: 12,
        difficulty: Difficulty.easy)
  ];
}
