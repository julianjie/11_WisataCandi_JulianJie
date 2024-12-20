import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  //TODO: 1. Deklarasi Variable
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _errorText = "";
  bool _isSignedIn = false;
  bool _obscurePassword = false;

  //TODO: 6. membuat Fungsi SignUp
  void _signUp() async {
    final String name = _usernameController.text.trim();
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (password.length < 8 ||
        !RegExp(r'[A-Z]').hasMatch(password) ||
        !RegExp(r'[a-z]').hasMatch(password) ||
        !RegExp(r'[0-9]').hasMatch(password) ||
        !RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password)) {
      setState(() {
        _errorText = 'Minimal 8 karakter, kombinasi huruf, angka, simbol';
      });
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final key = encrypt.Key.fromLength(32);
    final iv = encrypt.IV.fromLength(16);
    final Encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encryptedName = Encrypter.encrypt(name, iv: iv);
    final encryptedUsername = Encrypter.encrypt(username, iv: iv);
    final encryptedPassword = Encrypter.encrypt(password, iv: iv);

    prefs.setString('username', Encrypter.encrypt(username, iv: iv).base64);
    prefs.setString('fulname', Encrypter.encrypt(name, iv: iv).base64);
    prefs.setString('password', Encrypter.encrypt(password, iv: iv).base64);
    prefs.setString('key', key.base64);
    prefs.setString('iv', iv.base64);

    Navigator.pushReplacementNamed(context, '/signin');
  }
  //TODO: 7. membuat fungsi Dispose
  void dispose(){
    super.dispose();
    _usernameController.dispose();
    _namaController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //TODO: 2. Pasang AppBar
      appBar: AppBar(title: Text("Sign Up"),
      ),
      //TODO: 3. Pasang Body
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              child: Column(
                //TODO: 4. Atur MainAxisAlignment dan CrossAxisAlignment
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //TODO: 9. Pasang TextFormField Nama
                  TextFormField(
                    controller: _namaController,
                    decoration: const InputDecoration(
                      labelText: "Nama",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20,),
                  //TODO: 5.Pasang TextFormField Nama Pengguna
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: "Nama Pengguna",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  //TODO: 6.Pasang TextFormField Nama Kata Sandi
                  SizedBox(height: 20,),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: "Kata Sandi",
                      errorText: _errorText.isNotEmpty? _errorText : null,
                      border: OutlineInputBorder(),
                      suffixIcon:IconButton(
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        }, 
                        icon: Icon( _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                      ), 
                    ),
                    obscureText: _obscurePassword,
                  ),
                  //TODO: 7.Pasang Elevated Button Sign Up
                  SizedBox(height: 20,),
                  ElevatedButton(
                    onPressed: (){
                      _signUp();
                    }, 
                    child: const Text('Sign-in'),
                  ),
                  //TODO: 8. Pasang Text Button Sign Up
                  // TextButton(
                  //   onPressed: () {}, 
                  //   child: const Text('Belum punya akun?'), 
                  // ),
                  RichText(
                    text: TextSpan(
                      text: 'Sudah punya akun?',
                      style: const TextStyle(
                        color: Colors.deepPurple,
                        fontSize: 16,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Masuk disini!',
                          style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                          fontSize: 16,
                          ),
                          recognizer: TapGestureRecognizer()
                          ..onTap = (){
                            Navigator.pushReplacementNamed(context, '/signin');
                          },   
                        ),
                      ],      
                    ),
                  )
                ],
              )
            ),
          ),
        ),
      ),
    );
  }
}
