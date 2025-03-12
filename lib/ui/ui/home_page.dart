part of '../pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final FirebaseService _auth = FirebaseService();

  String? userId;
  late Future<Map<String, dynamic>> userData;

  @override
  void initState() {
    super.initState();
    User? user = _auth.getCurrentUser();

    userId = user.uid;
    userData = _getUserData(userId!);
  }

  Future<Map<String, dynamic>> _getUserData(String userId) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();

    if (!userDoc.exists) {
      return {}; // Jika user tidak ditemukan, kembalikan map kosong
    }

    return userDoc.data() as Map<String, dynamic>;
  }

  void signOut() async {
    await _auth.signOut();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<Map<String, dynamic>>(
          future: userData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return const Center(
                child: Text('Error loading data'),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('User not found'),
              );
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('Welcome ${snapshot.data!['first_name'] ?? 'User'}'),
                Text('Email: ${snapshot.data!['email']}'),
                Text('User ID: $userId'),
                Text('Last Name: ${snapshot.data!['last_name']}'),
                Text('Role: ${snapshot.data!['role']}'),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/attendance/main');
                      },
                      child: Text(
                        "Attedance",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amberAccent,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/noted');
                      },
                      child: Text(
                        "Notes",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/profile');
                      },
                      child: Text(
                        "Profile",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: signOut,
                  child: const Text('Sign Out'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
