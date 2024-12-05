import 'dart:ui';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  //TODO: 1. Deklarasi Variable
  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  String _errorText = "";

  bool _isSignedIn = false;

  bool _obscurePassword = false;
    Future<Map<String, String>> _retrieveAndDecryptDataFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final encryptedUsername = prefs.getString('username') ?? '';
    final encryptedPassword = prefs.getString('password') ?? '';
    final keyString = prefs.getString('key') ?? '';
    final ivString = prefs.getString('iv') ?? '';

    if (keyString.isEmpty || ivString.isEmpty) {
      return {};
    }

    final key = encrypt.Key.fromBase64(keyString);
    final iv = encrypt.IV.fromBase64(ivString);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final decryptedUsername = encrypter.decrypt64(encryptedUsername, iv: iv);
    final decryptedPassword = encrypter.decrypt64(encryptedPassword, iv: iv);

    return {'username': decryptedUsername, 'password': decryptedPassword};
  }

  void _signIn() async {
    try {
      final username = _usernameController.text.trim();
      final password = _passwordController.text.trim();

      if (username.isEmpty || password.isEmpty) {
        setState(() {
          _errorText = 'Username dan password tidak boleh kosong';
        });
        return;
      }

      final data = await _retrieveAndDecryptDataFromPrefs();
      if (data.isEmpty) {
        setState(() {
          _errorText = 'Tidak ada kredensial tersimpan';
        });
        return;
      }

      if (username == data['username'] && password == data['password']) {
        Navigator.pushReplacementNamed(context, '/homescreen');
      } else {
        setState(() {
          _errorText = 'Username atau password salah';
        });
      }
    } catch (e) {
      setState(() {
        _errorText = 'Terjadi kesalahan: $e';
      });
    }
  }  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //TODO: 2. Pasang AppBar
      appBar: AppBar(title: Text("Sign-in"),
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
                  //TODO: 7.Pasang Elevated Button Sign In
                  SizedBox(height: 20,),
                  ElevatedButton(
                    onPressed: (){
                      _signIn();
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
                      text: 'Belum punya akun?',
                      style: const TextStyle(
                        color: Colors.deepPurple,
                        fontSize: 16,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Daftar disini!',
                          style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                          fontSize: 16,
                          ),
                          recognizer: TapGestureRecognizer()
                          ..onTap = (){
                            Navigator.pushNamed(context, '/signup');
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
