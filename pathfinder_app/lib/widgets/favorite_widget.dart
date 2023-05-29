// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pathfinder_app/models/user.dart';
import 'package:pathfinder_app/repositories/trail_respository.dart';

class FavoriteButton extends StatefulWidget {
  final String title;

  const FavoriteButton({super.key, required this.title});

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton>
    with SingleTickerProviderStateMixin {
  final user = FirebaseAuth.instance.currentUser;
  final TrailRepository _trailRepository = TrailRepository();
  late AnimationController _animationController;
  late Animation<double> _animation;
  late bool isTrailAdded = false;
  late List<String>? favoriteTrails; // Add a list of strings

  Future<void> toggleTrailAdded() async {
    setState(() {
      isTrailAdded = !isTrailAdded;
    });

    if (isTrailAdded) {
      favoriteTrails!.add(widget.title);

      // Update the trail repository with the new list of favorite trails
      await _trailRepository.updateFavoriteTrails(user?.email, favoriteTrails!);

      // Show "Trail Added" dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Trail Added'),
            content: const Text('The trail has been added to your favorites.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      favoriteTrails!.remove(widget.title);

      // Update the trail repository with the new list of favorite trails
      await _trailRepository.updateFavoriteTrails(user?.email, favoriteTrails!);

      // Show "Trail Removed" dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Trail Removed'),
            content:
                const Text('The trail has been removed from your favorites.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void init() async {
    favoriteTrails = await _trailRepository.getFavoriteTrails(user!.email);

    setState(() {
      if (favoriteTrails!.contains(widget.title)) {
        isTrailAdded = true;
      } else {
        isTrailAdded = false;
      }
    });

    print(user!.email);
    print(favoriteTrails);
  }

  @override
  void initState() {
    super.initState();
    init();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_animationController.isCompleted) {
          _animationController.reverse();
        } else {
          _animationController.forward();
        }
        toggleTrailAdded();
      },
      child: ScaleTransition(
        scale: _animation,
        child: Icon(
          isTrailAdded ? Icons.favorite : Icons.favorite_border,
          color: isTrailAdded ? Colors.red : Colors.grey,
          size: 40.0,
        ),
      ),
    );
  }
}
