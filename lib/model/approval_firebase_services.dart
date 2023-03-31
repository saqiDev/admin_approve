import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  CollectionReference vender = FirebaseFirestore.instance.collection('vender');

  Future<void> updateData(
      {CollectionReference? reference,
      Map<String, dynamic>? data,
      String? docName}) async {
    try {
      await reference!.doc(docName).update(data!);
    } catch (e) {
      print("Error updating data: $e");
    }
  }
}
