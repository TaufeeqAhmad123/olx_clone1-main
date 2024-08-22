// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:olx_clone1/screens/login_page.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  User? _user;
  String _name = '';
  String _address = '';
  String _cnic = '';
  String? _photoUrl;
  bool _isEditing = false;
  String? _currentLocation;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cnicController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    _user = _auth.currentUser;

    if (_user != null) {
      final userDoc =
          await _firestore.collection('users').doc(_user!.uid).get();
      if (userDoc.exists) {
        setState(() {
          _name = userDoc['name'] ?? '';
          _address = userDoc['address'] ?? '';
          _cnic = userDoc['cnic'] ?? '';
          _photoUrl = userDoc['image'] ?? '';

          _nameController.text = _name;
          _addressController.text = _address;
          _cnicController.text = _cnic;
        });
      }
    }
  }

  Future<void> _updateProfilePicture() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      final String fileName = 'profile_pictures/${_user!.uid}';
      final  uploadTask = _storage.ref(fileName).putFile(imageFile);

      final TaskSnapshot snapshot = await uploadTask;
      final  photoUrl = await snapshot.ref.getDownloadURL();
      print('This i simage url$photoUrl');
    // return photoUrl;

      setState(() {
        _photoUrl = photoUrl;
      });
Map<String,dynamic> json = {'image':photoUrl};
      await updateField(json);
    }
  }

  Future<void> updateField(Map<String,dynamic> json)async{
    try{
      await _firestore.collection('users').doc(_user!.uid).update(json);

    }catch(e){
      print('Error in updating field');
    }
  }


  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentLocation = "${position.latitude}, ${position.longitude}";
        _addressController.text = _currentLocation!;
      });
    } catch (e) {
      // Handle the error if location services are not enabled or permissions are denied.
    }
  }

  Future<void> _saveUserData() async {
    if (_user != null && _validateCNIC(_cnicController.text)) {
      await _firestore.collection('users').doc(_user!.uid).set({
        'name': _nameController.text,
        'address': _addressController.text,
        'cnic': _cnicController.text,
        'image': ''
      }, SetOptions(merge: true));

      setState(() {
        _name = _nameController.text;
        _address = _addressController.text;
        _cnic = _cnicController.text;
        _isEditing = false;
      });

      Navigator.of(context).pop(); // Go back after saving
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid CNIC')),
      );
    }
  }

  bool _validateCNIC(String cnic) {
    // Pakistani CNIC should be 13 digits long
    return RegExp(r'^\d{13}$').hasMatch(cnic);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        backgroundColor: Colors.lightBlue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: _updateProfilePicture,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _photoUrl != null
                    ? NetworkImage(_photoUrl!)
                    : const AssetImage('assets/images/myprofile_icon.png')
                        as ImageProvider,
                child: _photoUrl == null
                    ? const Icon(Icons.camera_alt, size: 40)
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            _isEditing
                ? Column(
                    children: [
                      _buildTextField('Name', _nameController),
                      const SizedBox(height: 16),
                      _buildTextField('Address', _addressController),
                      const SizedBox(height: 16),
                      _buildTextField('CNIC', _cnicController, isCnic: true),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _getCurrentLocation,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlue,
                        ),
                        child: const Text('Use Current Location'),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _saveUserData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlue,
                        ),
                        child: const Text('Save'),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      _buildProfileItem('Name', _name, CupertinoIcons.person),
                      const SizedBox(height: 8),
                      _buildProfileItem(
                          'Email', _user?.email ?? '', CupertinoIcons.mail),
                      const SizedBox(height: 8),
                      _buildProfileItem(
                          'Address', _address, CupertinoIcons.location),
                      const SizedBox(height: 8),
                      _buildProfileItem(
                          'CNIC', _cnic, CupertinoIcons.creditcard),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isEditing = true;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlue,
                        ),
                        child: const Text('Edit'),
                      ),
                    ],
                  ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut().then((_) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Log Out',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isCnic = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        fillColor: Colors.lightBlue.shade50,
        filled: true,
        errorText: isCnic && !_validateCNIC(controller.text)
            ? 'Please enter a valid CNIC'
            : null,
      ),
      keyboardType: isCnic ? TextInputType.number : TextInputType.text,
      maxLength: isCnic ? 13 : null,
    );
  }

  Widget _buildProfileItem(String title, String value, IconData iconData) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            color: Colors.lightBlue.withOpacity(.2),
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(iconData, color: Colors.lightBlue),
        title: Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black)),
        subtitle: Text(value, style: const TextStyle(color: Colors.grey)),
      ),
    );
  }
}
