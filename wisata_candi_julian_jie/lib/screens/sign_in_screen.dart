import 'dart:ui';

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

  void _signIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String savedUsername = prefs.getString('username')??'';
    final String savedPassword = prefs.getString('password')??'';
    final String enteredUsername = _usernameController.text.trim();
    final String enteredPassword = _passwordController.text.trim();

    if( enteredUsername.isEmpty || enteredPassword.isEmpty){
      setState(() {
        _errorText = 'Nama Pengguna dan Kata sandi harus diisi';
      });
      return;
    }
    if( savedUsername.isEmpty || savedPassword.isEmpty){
      setState(() {
        _errorText = 'Pengguna belum terdaftar. Silahkan daftar terlebih dahulu';
      });
      return;
    }

    if(enteredUsername == savedUsername && enteredPassword == savedPassword) {
      setState(() {
        _errorText = '';
        _isSignedIn = true;
        prefs.setBool('isSignIn', true);
      });
      //Pemanggilan untuk menghapus semua halaman dalam tumpukan navigasi
      WidgetsBinding.instance.addPostFrameCallback((_){
        Navigator.of(context).popUntil((route)=>route.isFirst);
      });
      //Sign In berhasil, navigasi ke layar utama
      WidgetsBinding.instance.addPostFrameCallback((_){
        Navigator.pushReplacementNamed(context, '/homescreen');
      });
    }else {
      setState(() {
        _errorText = 'Nama Pengguna atau Kata Sandi Salah.';
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
