part of '../pages.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  bool _isLoading = false;

  final FirebaseService _auth = FirebaseService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();

  final List<Map<String, String>> _roles = [
    {"label": "Admin", "value": "ADMIN"},
    {"label": "User", "value": "USER"},
  ];
  String? _selectedRole;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        User? user = await _auth.signUp(
          _emailController.text,
          _passwordController.text,
        );

        if (user != null) {
          await _firestore.collection('users').doc(user.uid).set({
            'first_name': _firstNameController.text,
            'last_name': _lastNameController.text,
            'email': _emailController.text,
            'role': _selectedRole,
          });

          Navigator.pushReplacementNamed(context, '/home');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Pendaftaran berhasil"),
            ),
          );

        }
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: "Nama Depan"),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return "Nama depan tidak boleh kosong";
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: "Nama Belakang"),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return "Nama belakang tidak boleh kosong";
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: "Email"),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return "Email tidak boleh kosong";
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return "Masukkan email yang valid";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Pilih Role",
                  border: OutlineInputBorder(),
                ),
                value: _selectedRole,
                items: _roles.map((role) {
                  return DropdownMenuItem<String>(
                    value: role["value"], // Ambil value (ADMIN/USER)
                    child: Text(role["label"]!), // Tampilkan label (Admin/User)
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRole = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return "Silakan pilih role";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: "Password"),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return "Password tidak boleh kosong";
                  if (value.length < 6) return "Password minimal 6 karakter";
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: "Konfirmasi Password"),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return "Konfirmasi password tidak boleh kosong";
                  if (value != _passwordController.text)
                    return "Password tidak cocok";
                  return null;
                },
              ),
              SizedBox(height: 24),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _signUp,
                      child: Text("Daftar"),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                      ),
                    ),
              SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: Text("Sudah punya akun? Login di sini"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
