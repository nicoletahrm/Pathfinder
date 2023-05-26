// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../../widgets/custom_nav_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool notificationsEnabled = true;
  bool darkModeEnabled = false;
  String language = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const SizedBox(height: 20),
          ListTile(
            title: const Text('Profile'),
            subtitle: const Text('Edit your personal information'),
            leading: const Icon(Icons.person),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to profile editing screen
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Notifications'),
            subtitle: const Text('Turn on/off push notifications'),
            leading: const Icon(Icons.notifications),
            trailing: Switch(
              value: notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  notificationsEnabled = value;
                });
              },
            ),
            onTap: () {
              setState(() {
                notificationsEnabled = !notificationsEnabled;
              });
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Dark mode'),
            subtitle: const Text('Switch to dark mode'),
            leading: const Icon(Icons.nightlight_round),
            trailing: Switch(
              value: darkModeEnabled,
              onChanged: (value) {
                setState(() {
                  darkModeEnabled = value;
                });
              },
            ),
            onTap: () {
              setState(() {
                darkModeEnabled = !darkModeEnabled;
              });
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Language'),
            subtitle: Text(language),
            leading: const Icon(Icons.language),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Show language selection dialog
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Select language'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RadioListTile<String>(
                          title: const Text('English'),
                          value: 'English',
                          groupValue: language,
                          onChanged: (value) {
                            setState(() {
                              language = value!;
                            });
                            Navigator.pop(context);
                          },
                        ),
                        RadioListTile<String>(
                          title: const Text('Spanish'),
                          value: 'Spanish',
                          groupValue: language,
                          onChanged: (value) {
                            setState(() {
                              language = value!;
                            });
                            Navigator.pop(context);
                          },
                        ),
                        RadioListTile<String>(
                          title: const Text('French'),
                          value: 'French',
                          groupValue: language,
                          onChanged: (value) {
                            setState(() {
                              language = value!;
                            });
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Logout'),
            leading: const Icon(Icons.logout),
            onTap: () {
              // Perform logout action
            },
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
