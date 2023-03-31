import 'package:admin_approve/view/approval_requests.dart';
import 'package:admin_approve/view/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Widget _rowHeader({int? flex,  String? text,}){
      return Expanded(flex: flex!, child: Container( 
        decoration: BoxDecoration(
          border: Border.all(color: Color.fromARGB(255, 251, 168, 0)),
          color: Color.fromARGB(255, 255, 224, 177)
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: Text(text!, style: TextStyle(fontWeight: FontWeight.bold),),  ),
        ),
      ));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin Screen',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance
                    .signOut()
                    .then((value) => Get.to(const Login()));
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(children: [
            Center(child: Text("Requests for approval")),
      
            //
           SizedBox(height: 20),
      
            //row
            Row(
              children: [
                 _rowHeader( flex: 2, text: 'Names'),
                 _rowHeader( flex: 2  , text: 'Request'),
      
            
      
              ],
            ),
            ApprovalRequest(),
          ]),
        ),
      ),
    );
  }
}
