import 'dart:io';
import 'package:contact_buddy/model/user.dart';
import 'package:contact_buddy/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  var _nameController = TextEditingController();
  var _emailController = TextEditingController();
  var _phoneController = TextEditingController();
  bool _validateUser = false;
  bool _validatePhone = false;
  var _userService = UserService();
  //image picker
  final picker = ImagePicker();
  XFile? image;
  //get image from gallery function
  void getImage() {
    picker.pickImage(source: ImageSource.gallery).then((value) {
      setState(() {
        image = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Contacts'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  '+ Add New Contact',
                  style: TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    // use image picker
                    getImage();
                  },
                  child: CircleAvatar(
                    radius: 50,
                    // show xfile image
                    backgroundImage: image != null ? FileImage(File(image!.path)) : null,
                    child: image == null
                        ? const Icon(
                            Icons.add,
                            size: 50,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Name',
                      hintText: 'Type Name',
                      errorText:
                          _validateUser ? 'Name Can\'t Be Empty' : null),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Number',
                      hintText: 'Type Number',
                      errorText:
                          _validatePhone ? 'Number Can\'t Be Empty' : null),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Type Email',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Color.fromARGB(255, 20, 100, 0),
                        ),
                        onPressed: () async {
                          setState(() {
                            _nameController.text.isEmpty
                                ? _validateUser = true
                                : _validateUser = false;
                            _phoneController.text.isEmpty
                                ? _validatePhone = true
                                : _validatePhone = false;
                          });
                          if (_validateUser == false &&
                              _validatePhone == false) {
                            // print('Data Can Save');
                            var _user = User();
                            _user.name = _nameController.text;
                            _user.phone = _phoneController.text;
                            _user.email = _emailController.text;
                            _user.image = image?.path ?? '';
                            print(_user.image);
                            var result = await _userService.SaveUser(_user);
                            Navigator.pop(context, result);
                          }
                        },
                        child: const Text('Save')),
                    const SizedBox(
                      width: 10,
                    ),
                    TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Color.fromARGB(255, 255, 4, 0),
                        ),
                        onPressed: () {
                          _nameController.clear();
                          _phoneController.clear();
                          _emailController.clear();
                        },
                        child: const Text('Clear'))
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
