import 'dart:io';

import 'package:contact_buddy/model/user.dart';
import 'package:contact_buddy/screens/addUser.dart';
import 'package:contact_buddy/screens/editUSer.dart';
import 'package:contact_buddy/screens/viewUser.dart';
import 'package:contact_buddy/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _searchController = TextEditingController();
  late List<User> _userList;
  final _userService = UserService();
  getAllUserDetails() async {
    _userList = <User>[];
    var users = await _userService.ReadUser();
    users.forEach((user) {
      setState(() {
        var userModel = User();
        userModel.id = user['id'];
        userModel.name = user['name'];
        userModel.phone = user['phone'];
        userModel.email = user['email'];
        userModel.image = user['image'];
        _userList.add(userModel);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getAllUserDetails();
  }

  _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  _deleteFormDialog(BuildContext context, userId) {
    return showDialog(
        context: context,
        builder: (param) {
          return AlertDialog(
            title: const Text(
              'Are you sure?',
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                ),
                onPressed: () async {
                  var result = await _userService.deleteUser(userId);
                  if (result != null) {
                    Navigator.pop(context);
                    getAllUserDetails();
                    _showSuccessSnackBar('Deleted Successfully');
                  }
                },
                child: const Text('Delete'),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.yellow,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close'),
              )
            ],
          );
        });
  }
void _showErrorSnackBar(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ),
  );
}
Future<void> _exportContacts() async {
  try {
    final List<List<dynamic>> rows = [];
    
    // Add header row
    rows.add(['Name', 'Phone']);

    // Add contact details
    _userList.forEach((user) {
      rows.add([user.name ?? '', user.phone ?? '']);
    });

    // Generate CSV data
    final String csv = const ListToCsvConverter().convert(rows);

    // Get the directory to save the file
    const String dir = "/storage/emulated/0/Download";
    const String path = '$dir/contacts.csv';

    // Write to file
    File file = File(path);
    await file.writeAsString(csv);

    // Show a success message
    _showSuccessSnackBar('Contacts exported to $path');
  } catch (e) {
    print('Error exporting contacts: $e');
    _showErrorSnackBar('Error exporting contacts');
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Contact'),
          //search bar and input field
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Search'),
                          content: TextField(
                            controller: _searchController,
                            decoration: const InputDecoration(
                                hintText: 'Search by name, email or phone'),
                          ),
                          actions: [
                            TextButton(
                                onPressed: () async {
                                  var search = _searchController.text;
                                  var result =
                                      await _userService.dataSearch(search);
                                  //set state and change data type
                                  //clear list
                                  _userList.clear();
                                  var users = result;
                                  users.forEach((user) {
                                    setState(() {
                                      var userModel = User();
                                      userModel.id = user['id'];
                                      userModel.name = user['name'];
                                      userModel.phone = user['phone'];
                                      userModel.email = user['email'];
                                      userModel.image = user['image'];
                                      _userList.add(userModel);
                                    });
                                  });
                                  Navigator.pop(context);
                                },
                                child: const Text('Search')),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel'))
                          ],
                        );
                      });
                },
                icon: const Icon(Icons.search)),
                IconButton(
                  onPressed: () async {
                    await _exportContacts();
                  },
                  icon: const Icon(Icons.download_for_offline_outlined),
          )
          ],
        ),
        body:_userList.isEmpty
        ? Center(
      child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.network('https://lottie.host/f47379ec-1dc4-4f84-92ae-c3a63e546b1b/lu5yvJf6fh.json'),
                  Text(
                    'No contacts to display',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
    ): 
            ListView.builder(
            itemCount: _userList.length,
            itemBuilder: (context, index) {
              //return card
              return Card(
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewUser(
                                  user: _userList[index],
                                )));
                  },
                  //show image if available
                  leading: _userList[index].image != null
                      ? CircleAvatar(
                          backgroundImage:
                              FileImage(File(_userList[index].image!)),
                        )
                      : const CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                  title: Text(_userList[index].name ?? ''),
                  subtitle: Text(_userList[index].phone ?? ''),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditUser(
                                          user: _userList[index],
                                        ))).then((data) {
                              if (data != null) {
                                getAllUserDetails();
                                _showSuccessSnackBar(
                                    'Contact Updated Successfully');
                              }
                            });
                          },
                          icon: const Icon(Icons.edit, color: Color.fromARGB(255, 173, 158, 19))),
                      IconButton(
                          onPressed: () {
                            _deleteFormDialog(context, _userList[index].id);
                          },
                          icon: const Icon(Icons.delete, color: Colors.red)),
                    ],
                  ),
                ),
              );
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                    context, MaterialPageRoute(builder: (context) => AddUser()))
                .then((data) {
              if (data != null) {
                getAllUserDetails();
                _showSuccessSnackBar('Contact Added Successfully');
              }
            });
          },
          child: const Icon(Icons.add, color: Colors.black),
        ));
  }
}
