import 'package:flutter/material.dart';
import '../screens/events_screen.dart';
import '../screens/home_screen.dart';
import '../screens/profile/profile_screen.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.0,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -15),
            blurRadius: 20,
            color: const Color(0xFFDADADA).withOpacity(0.15),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
          top: true,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.home_outlined,
                  size: 30,
                  color: Colors.black54,
                ),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomeScreen())),
              ),
              IconButton(
                  icon: const Icon(
                    Icons.people_alt,
                    size: 30,
                    color: Colors.black54,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EventsScreen()));
                  }),
              IconButton(
                icon: const Icon(
                  Icons.hiking_outlined,
                  size: 30,
                  color: Colors.black54,
                ),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomeScreen())),
              ),
              IconButton(
                icon: const Icon(
                  Icons.perm_identity_outlined,
                  size: 30,
                  color: Colors.black54,
                ),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfileScreen())),
              ),
            ],
          )),
    );
  }
}
