import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';

class FirebaseServices {
  User? user = FirebaseAuth.instance.currentUser;
  final CollectionReference vender =
      FirebaseFirestore.instance.collection('vender');
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  var updateData;

Future<String> uploadImage(XFile? file, String? reference) async {
  try {
    File _file = File(file!.path);
    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref(reference);
    await ref.putFile(_file);
    String downloadURL = await ref.getDownloadURL();
    return downloadURL;
  } catch (error) {
    print('Error uploading image: $error');
    return ''; // Return an empty string if there's an error
  }
}


  Future<void> addVender({Map<String, dynamic>? data}) {
    // Call the user's CollectionReference to add a new user
    return vender.doc(user!.uid)
        .set(data)
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}
