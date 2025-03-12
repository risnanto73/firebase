part of '../pages.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseService _auth = FirebaseService();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  bool _isLoading = false;
  bool _isEmailVerified = false;
  String? _profileImageUrl;
  File? _selectedImage;

  @override
  void initState() {
    _loadUserData();
    _checkEmailVerification();
    super.initState();
  }

  void _checkEmailVerification() async {
    setState(() => _isLoading = true);

    await _auth.reloadUser(); // Refresh user data
    _isEmailVerified = _auth.isEmailVerified();

    setState(() => _isLoading = false);
  }

  // Mengirim ulang email verifikasi
  void _sendVerificationEmail() async {
    setState(() => _isLoading = true);

    try {
      await _auth.sendEmailVerification();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email verifikasi telah dikirim!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengirim email verifikasi: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() => _isLoading = false);
  }

  //load user data
  void _loadUserData() async {
    User? user = _auth.getCurrentUser();
    String userId = user.uid;
    Map<String, dynamic> userData = await _auth.getUserData(userId);

    _firstNameController.text = userData['first_name'];
    _lastNameController.text = userData['last_name'];
    _profileImageUrl = userData['profileImageUrl'];

    setState(() {});
  }

  //update profile
  void _updateProfile() async {
    setState(() {
      _isLoading = true;
    });

    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;

    await _auth.updateProfileName(firstName, lastName);

    setState(() {
      _isLoading = false;
    });
  }

  /// 🔹 Fungsi Upload Gambar dari Galeri
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      _uploadProfileImage(File(pickedFile.path));
    }
  }

  /// 🔹 Upload Gambar ke Firebase Storage
  Future<void> _uploadProfileImage(File imageFile) async {
    setState(() => _isLoading = true);

    String userId = FirebaseAuth.instance.currentUser!.uid;
    Reference storageRef =
        FirebaseStorage.instance.ref().child('profile_images/$userId.jpg');

    UploadTask uploadTask = storageRef.putFile(imageFile);
    TaskSnapshot snapshot = await uploadTask;
    String imageUrl = await snapshot.ref.getDownloadURL();

    await _auth.updateProfileImage(imageUrl);

    setState(() {
      _profileImageUrl = imageUrl;
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile picture updated!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile Page')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🔹 Foto Profil
            // 🔹 Foto Profil (Dapat Diklik untuk Upload)
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _selectedImage != null
                        ? FileImage(_selectedImage!)
                        : (_profileImageUrl != null
                            ? NetworkImage(_profileImageUrl!) as ImageProvider
                            : null),
                    child: (_profileImageUrl == null && _selectedImage == null)
                        ? const Icon(Icons.person, size: 50)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white,
                      child:
                          Icon(Icons.camera_alt, size: 20, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 🔹 Input Nama Depan
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(labelText: "First Name"),
            ),
            const SizedBox(height: 10),

            // 🔹 Input Nama Belakang
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: "Last Name"),
            ),
            const SizedBox(height: 20),

            // 🔹 Tombol Update Profile
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      _updateProfile();
                    },
                    child: const Text("Update Profile"),
                  ),

            // 🔹 Tombol Logout
            ElevatedButton(
              onPressed: () {
                _auth.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text("Logout"),
            ),
            // 🔹 Tombol Ganti Password
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/change-password');
              },
              child: const Text("Change Password"),
            ),
            if (!_isEmailVerified) ...[
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning, color: Colors.red),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Email Anda belum diverifikasi. Silakan periksa email Anda!',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    //   button refresh
                    IconButton(
                        onPressed: () {
                          _checkEmailVerification();
                        },
                        icon: const Icon(Icons.refresh)),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _sendVerificationEmail,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Kirim Ulang Email Verifikasi'),
              ),
            ],
            if (_isEmailVerified) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check, color: Colors.green),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Email Anda sudah diverifikasi. Terima kasih!',
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
