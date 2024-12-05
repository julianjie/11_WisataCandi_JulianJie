import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wisata_candi_julian_jie/widgets/profile_item_info.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class ProfileScreen  extends StatefulWidget {
  const ProfileScreen ({super.key});

  @override
  State<ProfileScreen > createState() =>  _ProfileScreenState();
}

class _ProfileScreenState extends State <ProfileScreen > {
  //TODO: 1. Deklarasikan varibale yang dibutuhkan

  bool isSignedIn = false;
  String fullName = "Dummy";
  String userName = "Dummy";
  int favoriteCandiCount = 0;

  Future<Map<String, String>> _retrieveAndDecryptDataFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final encryptedUsername = prefs.getString('username') ?? '';
    final encryptedPassword = prefs.getString('password') ?? '';
    final encryptedFullname = prefs.getString('fulname') ?? '';
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
    final decryptedFullName = encrypter.decrypt64(encryptedFullname, iv: iv);

    return {'username': decryptedUsername, 'password': decryptedPassword, 'fulname': decryptedFullName};
  }

  void _loadUserData() async {
    final data = await _retrieveAndDecryptDataFromPrefs();
    setState(() {
      fullName = data['fulname'] ?? 'Nama belum diatur';
      userName = data['username'] ?? 'Pengguna belum diatur';
    });
  }
  //TODO: 5. Implementasi fungsi SignIn
  void signIn(){
    // setState(() {
    //   isSignedIn = !isSignedIn;
    // });
    Navigator.pushNamed(context, '/signin');
  }
  //TODO: 6. Implementasi fungsi SignOut
  void signOut() async {
    // setState(() {
    //   isSignedIn = !isSignedIn;
    // });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Hapus semua data dari SharedPreferences
    setState(() {
      isSignedIn = false;
      fullName = " DummyName";
      userName = " DummyUsername";
      favoriteCandiCount = 0;
    });
    Navigator.pushReplacementNamed(context, '/signin');
  }
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            color: Colors.deepPurple,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                // Header Profile
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 200 - 50),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.deepPurple,
                              width: 2,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                AssetImage('images/placeholder_image.png'),
                          ),
                        ),
                        if (isSignedIn)
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.camera_alt,
                              color: Colors.deepPurple[50],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Divider(color: Colors.deepPurple[100]),
                const SizedBox(height: 4),
                // Informasi Pengguna
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: const Row(
                        children: [
                          Icon(Icons.lock, color: Colors.amber),
                          SizedBox(width: 8),
                          Text(
                            'Pengguna',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Text(
                        ': $userName',
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Divider(color: Colors.deepPurple[100]),
                const SizedBox(height: 4),
                ProfileItemInfo(
                  icon: Icons.person,
                  label: 'Name',
                  value: fullName,
                  iconColor: Colors.blue,
                  showEditIcon: isSignedIn,
                  onEditPressed: () {
                    debugPrint('Icon Edit Ditekan');
                  },
                ),
                const SizedBox(height: 4),
                Divider(color: Colors.deepPurple[100]),
                const SizedBox(height: 10),
                ProfileItemInfo(
                  icon: Icons.favorite,
                  label: 'Favorite',
                  value: favoriteCandiCount > 0
                      ? '$favoriteCandiCount candi'
                      : 'Belum ada',
                  iconColor: Colors.red,
                ),
                const SizedBox(height: 4),
                Divider(color: Colors.deepPurple[100]),
                const SizedBox(height: 10),
                // Tombol Sign In/Sign Out
                isSignedIn
                    ? TextButton(onPressed: signOut, child: const Text('Sign Out'))
                    : TextButton(onPressed: signIn, child: const Text('Sign In')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}