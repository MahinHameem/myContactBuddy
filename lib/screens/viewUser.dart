import 'dart:io';

import 'package:contact_buddy/model/user.dart';
import 'package:flutter/material.dart';

class ViewUser extends StatefulWidget {
  final User user;
  const ViewUser({super.key, required this.user});

  @override
  State<ViewUser> createState() => _ViewUserState();
}

class _ViewUserState extends State<ViewUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View User'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Full Details",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 43, 45, 46),
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Show image
                widget.user.image == null
                    ? const CircleAvatar(
                        radius: 50,
                        child: Icon(
                          Icons.person,
                          size: 50,
                        ),
                      )
                    : CircleAvatar(
                        radius: 50,
                        backgroundImage: FileImage(File(widget.user.image!)),
                      ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Name: ',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 109, 158, 131),
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      widget.user.name ?? '',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Number: ',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 109, 158, 131),
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      widget.user.phone ?? '',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Email: ',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 109, 158, 131),
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      widget.user.email ?? '',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
