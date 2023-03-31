import 'package:admin_approve/model/vender_model.dart';
import 'package:admin_approve/view/login/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Admin extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  List<DocumentSnapshot> _users = [];

  @override
  void initState() {
    super.initState();
    _getNewUsers();
  }

  Future<void> _getNewUsers() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('approved', isEqualTo: false)
          .get();
      setState(() {
        _users = querySnapshot.docs;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $error'),
        ),
      );
    }
  }

  Future<void> _approveUser(DocumentSnapshot user) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.id)
          .update({'approved': true});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User approved!'),
        ),
      );
      _getNewUsers();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Screen', style: TextStyle(color: Colors.white),),
        actions: [
          IconButton(onPressed: (){ FirebaseAuth.instance
                          .signOut()
                          .then((value) => Get.to(const Login()));}, icon:const  Icon(Icons.logout))
        ],
      ),
      body: _users.isEmpty
          ? const Center(
              child: Text('No new users to approve'),
            )
          : ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                DocumentSnapshot user = _users[index];
                return ListTile(
                  title: Text(user[Vender]),
                  subtitle: Text(user['email']),
                  trailing: ElevatedButton(
                    onPressed: () => _approveUser(user),
                    child: Text('Approve'),
                  ),
                );
              },
            ),
    );
  }
}
