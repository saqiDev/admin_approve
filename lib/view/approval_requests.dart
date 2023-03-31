import 'dart:developer';

import 'package:admin_approve/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../model/approval_model.dart';

class ApprovalRequest extends StatelessWidget {
  const ApprovalRequest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseServices _service = FirebaseServices();

    Widget _approvalRequestData({int? flex, String? text, Widget? widget}) {
      return Expanded(
        flex: flex!,
        child: Container(
          height: 50,
          decoration:
              BoxDecoration(border: Border.all(color: Colors.grey.shade300)),
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: widget ??
                  Text(
                    text!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )),
        ),
      );
    }

    return StreamBuilder<QuerySnapshot>(
        stream: _service.vender.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LinearProgressIndicator();
          }

          return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.size,
              itemBuilder: (context, index) {
                Vender venderData = Vender.fromJson(
                    snapshot.data!.docs[index].data() as Map<String, dynamic>);
                return Row(
                  children: [
                    _approvalRequestData(
                      flex: 2,
                      text: venderData.Name.toString(),
                    ),
                    _approvalRequestData(
                        flex: 2,
                        widget: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: venderData.approved!
                                  ? Colors.green
                                  : Colors.red),
                          child: Text(
                            venderData.approved! ? 'Approved' : "Reject",
                            style: const TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Map<String, dynamic> data = {
                              'approved': !venderData.approved!
                            };

                            FirebaseFirestore.instance
                                .collection('vender')
                                .doc(venderData.uid)
                                .update(data)
                                .then((value) => Get.snackbar(
                                      'Profile Update',
                                      venderData.approved!
                                          ? "Your Profile Rejected"
                                          : "Your Profile Approved",
                                      colorText: Colors.white,
                                      backgroundColor: Colors.lightBlue,
                                      icon: const Icon(Icons.add_alert),
                                    ));
                          },
                        )),
                  ],
                );
              });
        });
  }
}
