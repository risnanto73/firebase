part of '../pages.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final FirebaseService _auth = FirebaseService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();

  bool _isLoading = false;
  bool _isObscureText = true;

  /// 🔹 Fungsi untuk mengubah password dengan validasi tambahan
  void _changePassword() async {
    setState(() => _isLoading = true);

    String currentPassword = _currentPasswordController.text.trim();
    String newPassword = _newPasswordController.text.trim();
    String confirmNewPassword = _confirmNewPasswordController.text.trim();

    // 🔹 Validasi input kosong
    if (currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmNewPassword.isEmpty) {
      _showSnackbar('Mohon isi semua kolom.');
      setState(() => _isLoading = false);
      return;
    }

    // 🔹 Validasi password baru dan konfirmasi
    if (newPassword != confirmNewPassword) {
      _showSnackbar('Password baru dan konfirmasi tidak cocok.');
      setState(() => _isLoading = false);
      return;
    }

    try {
      User? user = _firebaseAuth.currentUser;
      if (user == null) {
        _showSnackbar('Pengguna tidak ditemukan.');
        setState(() => _isLoading = false);
        return;
      }

      // 🔹 Re-authenticate pengguna dengan password saat ini
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);

      // 🔹 Periksa apakah password baru sama dengan password lama
      if (currentPassword == newPassword) {
        _showSnackbar('Password baru tidak boleh sama dengan password lama.');
        setState(() => _isLoading = false);
        return;
      }

      // 🔹 Update password baru di Firebase
      await user.updatePassword(newPassword);
      _showSnackbar('Password berhasil diperbarui.');

      // 🔹 Kosongkan input setelah sukses
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmNewPasswordController.clear();

      // 🔹 logout pengguna setelah berhasil mengubah password
      await _auth.signOut();
      Navigator.of(context).pushReplacementNamed('/login');
      _showSnackbar('Silakan login kembali dengan password baru Anda.');
    } on FirebaseAuthException catch (e) {
      _showSnackbar(e.message ?? 'Terjadi kesalahan.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// 🔹 Fungsi untuk menampilkan SnackBar
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ganti Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 16.0),
            const Text('Ganti Password', style: TextStyle(fontSize: 24.0)),
            const SizedBox(height: 16.0),
            const Text('Masukkan password baru Anda'),
            const SizedBox(height: 16.0),

            // 🔹 Input Password Saat Ini
            TextField(
              controller: _currentPasswordController,
              decoration: InputDecoration(
                labelText: 'Password Saat Ini',
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: IconButton(
                    icon: Icon(_isObscureText
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isObscureText = !_isObscureText;
                      });
                    },
                  ),
                ),
              ),
              obscureText: _isObscureText ? true : false,
            ),
            const SizedBox(height: 16.0),

            // 🔹 Input Password Baru
            TextField(
              controller: _newPasswordController,
              decoration: InputDecoration(
                labelText: 'Password Baru',
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: IconButton(
                    icon: Icon(_isObscureText
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isObscureText = !_isObscureText;
                      });
                    },
                  ),
                ),
              ),
              obscureText: _isObscureText ? true : false,
            ),
            const SizedBox(height: 16.0),

            // 🔹 Input Konfirmasi Password Baru
            TextField(
              controller: _confirmNewPasswordController,
              decoration: InputDecoration(
                labelText: 'Konfirmasi Password Baru',
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: IconButton(
                    icon: Icon(_isObscureText
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isObscureText = !_isObscureText;
                      });
                    },
                  ),
                ),
              ),
              obscureText: _isObscureText ? true : false,
            ),
            const SizedBox(height: 16.0),

            // 🔹 Tombol Change Password
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _changePassword,
                    child: const Text('Ganti Password'),
                  ),
          ],
        ),
      ),
    );
  }
}
