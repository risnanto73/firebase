import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mendapatkan user yang sedang login
    User? currentUser = FirebaseAuth.instance.currentUser;

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
        _onWillPop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Main Page"),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => _logout(context),
            ),
          ],
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Menampilkan informasi user yang sedang login
                if (currentUser != null)
                  Column(
                    children: [
                      Text(
                        "Hello, ${currentUser.displayName ?? 'User'}",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Email: ${currentUser.email}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/attendance');
                  },
                  child: const Text('Attendance'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/attendance/history');
                  },
                  child: const Text('History'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/attendance/leave');
                  },
                  child: const Text('Leave'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop(BuildContext context) async {
    return (await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to exit the app?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    )) ??
        false;
  }

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }
}
