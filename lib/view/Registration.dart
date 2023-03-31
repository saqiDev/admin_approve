import 'dart:developer';
import 'dart:io';

import 'package:admin_approve/firebase_services.dart';
import 'package:admin_approve/view/home/home.dart';
import 'package:admin_approve/view/landing_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _formKey = GlobalKey<FormState>();

  final FirebaseServices _services = FirebaseServices();
  final _businessName = TextEditingController();
  final _phoneNo = TextEditingController();
  final _emailAddress = TextEditingController();
  final _pinCode = TextEditingController();
  final _address = TextEditingController();
  final _city = TextEditingController();


  // final _taxGPT = TextEditingController();

  String? _bName;
  // String? _taxStatus;
  XFile? _coverImage;
  XFile? _profileImage;
  String? _profileImgUrl;
  String? _coverImgUrl;

  final ImagePicker _picker = ImagePicker();

  Widget _formField(
      {TextEditingController? controller,
      String? label,
      TextInputType? type,
      String? Function(String?)? validator}) {
    return TextFormField(
      keyboardType: type,
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixText: controller == _phoneNo ? '+92' : null,
      ),
      validator: validator,
      onChanged: (value) {
        if (controller == _businessName) {
          setState(() {
            _bName = value;
          });
        }
      },
    );
  }

  Future<XFile?> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  _scaffold(messenge) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(messenge),
      action: SnackBarAction(
          label: 'Ok',
          onPressed: () {
            ScaffoldMessenger.of(context).clearSnackBars();
          }),
    ));
  }

  _saveToDB(){
    
                      if (_profileImage == null) {
                        return _scaffold('Prifile image is not added');
                      }
                      if (_coverImage == null) {
                        return _scaffold('Cover image is not added');
                      }
                      if (_formKey.currentState!.validate()) 
                    

                        EasyLoading.show(status: 'Please wait..');                       //// _coverImage.jpg
                    _services.uploadImage(_profileImage, 'vendors/${_services.user!.uid}/_coverImage').then((String? url){
                      if(url!=null ){
                        setState(() {
                          _profileImgUrl=url;
                        });
                      }
                    }).then((value) {
                                                _services.uploadImage(_coverImage, 'vendors/${_services.user!.uid}/_profileImage').then((String? url){
                      if(url!=null ){
                        setState(() {
                          _coverImgUrl=url;
                        }
                        );
                      }
                    }
                    );

                    }).then((value){
                      _services.addVender(
                        data: {
                          'coverImage':_coverImgUrl,
                          'profileImage': _profileImgUrl,
                          'Name'       : _businessName.text,
                          'phoneNo'    : '+92${_phoneNo.text}',
                          'emailAddress': _emailAddress.text,
                          'pinCode'     : _pinCode.text,
                          'address'     : _address.text,
                          'city'        : _city.text,
                          'approved'    : false, ///---- this is where admin can approve or decline  :D---------------------
                          'admin'    : false,
                          'uid'         : _services.user!.uid,
                          'time'        : DateTime.now(), 
                        }
                      ).then((value) {
                        EasyLoading.dismiss();
                        return Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (BuildContext context)=> const LandingScreen())
                        );
                      });

                    });



                    
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              //------first Box

            
              Container(
                height: 250,
                child: Stack(
                  children: [
                    _coverImage == null
                        ? Container(
                            height: 250,
                            color: Colors.orange,
                            child: TextButton(
                              child: const Center(
                                child: Text(
                                  "Tab to add image",
                                  style: TextStyle(color: Colors.black38),
                                ),
                              ),
                              onPressed: () {
                                _pickImage().then((value) {
                                  setState(() {
                                    _coverImage = value;
                                  });
                                });
                              },
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              _pickImage().then((value) {
                                setState(() {
                                  _coverImage = value;
                                });
                              });
                            },
                            child: Container(
                              height: 250,
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                image: DecorationImage(
                                    opacity: 100,
                                    image: FileImage(
                                      File(_coverImage!.path),
                                    ),
                                    fit: BoxFit.cover),
                              ),
                            ),
                          ),

                    //app bar
                    SizedBox(
                      height: 80,
                      child: AppBar(
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        actions: [
                          IconButton(
                            onPressed: () {
                              FirebaseAuth.instance.signOut();
                            },
                            icon: const Icon(Icons.exit_to_app),
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),

                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                _pickImage().then((value) {
                                  setState(() {
                                    _profileImage = value;
                                  });
                                });
                              },
                              child: Card(
                                elevation: 5,
                                //Profile image
                                child: _profileImage == null
                                    ? const SizedBox(
                                        height: 80,
                                        width: 80,
                                        child: Center(
                                            child: Icon(Icons.add_a_photo)),
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: SizedBox(
                                            height: 80,
                                            width: 80,
                                            child: Image.file(
                                              File(_profileImage!.path),
                                              fit: BoxFit.cover,
                                            )),
                                      ),
                              ),
                            ),
                            // ignore: prefer_const_constructors
                            SizedBox(width: 7),
                            //Shhop name
                            Flexible(
                              child: Text(
                                _bName == null ? "" : _bName!,
                                style: const TextStyle(
                                    fontSize: 25,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              //------- first box End

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 8),
                child: Column(
                  children: [
                    // name
                    _formField(
                        controller: _businessName,
                        label: 'Name',
                        type: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter name';
                          }
                        }),
                    // Phone no
                    _formField(
                        controller: _phoneNo,
                        label: 'Phone no',
                        type: TextInputType.phone,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Phone no';
                          }
                        }),
                    // Email
                    _formField(
                      controller: _emailAddress,
                      label: 'Email Address',
                      type: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Email address';
                        }
                        bool _isValid = (EmailValidator.validate(value));
                        if (_isValid == false) {
                          return 'Invalid Email';
                        }
                      },
                    ),

                    // SizedBox(
                    //   height: 10
                    // ),
                    // drop dwon buttton _taxStatus
                    // Row(
                    //   children: [
                    //     const Text(
                    //       "Tax Register :",
                    //       style: TextStyle(color: Colors.black45),
                    //     ),
                    //     Expanded(
                    //       child: DropdownButtonFormField(
                    //           value: _taxStatus,
                    //           hint: const Text('Select'),
                    //           items: <String>[ 'Yes', 'No',]
                    //           .map<DropdownMenuItem<String>>((String value) {
                    //             return DropdownMenuItem<String>(
                    //               value: value,
                    //               child: Text(value),
                    //             );
                    //           }).toList(),
                    //           onChanged: (String? value) {
                    //             setState(() {
                    //               _taxStatus == value;
                    //             });
                    //           }),
                    //     )
                    //   ],
                    // ),
                    // // Tax GST Number
                    // if(_taxStatus=="Yes")

                    //   _formField(
                    //     controller: _taxGPT,
                    //     label: 'GST Number',
                    //     type: TextInputType.text,
                    //     validator: (value) {
                    //       if (value!.isEmpty) {
                    //         return 'Enter GST Number';
                    //       }
                    //     },
                    //   ),

                    // pin code
                    _formField(
                      controller: _pinCode,
                      label: 'Pin Code',
                      type: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Pin Code';
                        }
                      },
                    ),
                    // address
                    _formField(
                      controller: _address,
                      label: 'Address',
                      type: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Address';
                        }
                      },
                    ),
                    // city
                    _formField(
                      controller: _city,
                      label: 'City',
                      type: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'City';
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        persistentFooterButtons: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      child: const Text(
                      "Register",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: _saveToDB,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
