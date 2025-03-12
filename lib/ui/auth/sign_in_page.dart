part of '../pages.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  bool isObscure = true;

  final _emailController = TextEditingController();
  final _email2Controller = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseService _authService = FirebaseService();

  void _login(BuildContext context) async {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isNotEmpty && password.isNotEmpty) {
      final user = await _authService.signIn(email, password);
      if (user != null) {
        Navigator.pushReplacementNamed(context, '/home');
        print('Login Success');
       ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login Success ${user.email}'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        print('Login Failed');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login Failed'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      print('Please fill all fields');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all fields'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _forgotPassword() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Forgot Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _email2Controller,
                decoration: InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                String email = _email2Controller.text.trim();

                if (email.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Email tidak boleh kosong!'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                try {
                  await _authService.forgotPassword(email);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Reset Password Link Sent to Your Email'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } on Exception catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Send'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 50),
            Container(
              height: 200,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage(assetImageLogin),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Text(
                textWelcome,
                textAlign: TextAlign.start,
                style: welcome,
              ),
            ),
            SizedBox(height: 5),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Text(
                textWelcome2,
                style: welcome2,
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: emailHint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Icon(Icons.email, size: 20),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: passwordHint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Icon(Icons.lock, size: 20),
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: IconButton(
                      icon: Icon(isObscure
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          isObscure = !isObscure;
                        });
                      },
                    ),
                  ),
                ),
                obscureText: isObscure? true : false,
                textInputAction: TextInputAction.done,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: Text(
                        signUp,
                        style: TextStyle(color: colorPrimary),
                        maxLines: 1,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                  SizedBox(
                    child: TextButton(
                      onPressed: () {
                        _forgotPassword();
                      },
                      child: Text(
                        forgotPassword,
                        style: TextStyle(color: colorPrimary),
                        maxLines: 1,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: ElevatedButton(
                onPressed: () {
                  _login(context);
                },
                child: Text(
                  signIn,
                  style: welcome2.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(colorPrimary),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Text(
                orSignInWith,
                textAlign: TextAlign.center,
                style: welcome2,
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      print('Login with Google');
                    },
                    child: Row(
                      children: [
                        Container(
                          height: 25,
                          width: 25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: AssetImage(assetGoogleLogo),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          google,
                          style: welcome2.copyWith(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      print('Login with Facebook');
                    },
                    child: Row(
                      children: [
                        Container(
                          height: 25,
                          width: 25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: AssetImage(assetFacebookLogo),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          facebook,
                          style: welcome2.copyWith(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
