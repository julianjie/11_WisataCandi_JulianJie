import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  //TODO: 1. Deklarasi Variable
  final TextEditingController _useNameController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _errorText = "";
  bool _isSignedIn = false;
  bool _obscurePassword = false;

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
                    controller: _useNameController,
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
                    onPressed: (){}, 
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
                          ..onTap = (){},   
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
