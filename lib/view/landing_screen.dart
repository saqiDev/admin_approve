import 'package:admin_approve/firebase_services.dart';
import 'package:admin_approve/model/vender_model.dart';
import 'package:admin_approve/view/Registration.dart';
import 'package:admin_approve/view/admin.dart';
import 'package:admin_approve/view/admin_screen.dart';
import 'package:admin_approve/view/home/home.dart';
import 'package:admin_approve/view/login/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseServices _services = FirebaseServices();
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: _services.vender.doc(_services.user!.uid).snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.data!.exists) {
            return const Registration();
          }

    Vender vender =  Vender.fromJson(snapshot.data!.data() as Map<String, dynamic>);
    if(vender.approved == true){
      return Home();
      
      
    } 
    else if (vender.admin == true){
      return AdminScreen();
    }

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Container(
                    width: 80,
                    height:80,
                     
                   ),
                   const SizedBox(height:10),
                   Text(vender.Name!, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),

                   const SizedBox(height:10),
                 const  Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      'Your application sent to Admin \n Please wait \n Admin will contact you soon',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ),
                  SizedBox(height: 50),
                  OutlinedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                    ),
                    onPressed: () {
                      FirebaseAuth.instance
                          .signOut()
                          .then((value) => Get.to(const Login()));
                    },
                    child: Text(
                      "Sign Out",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
