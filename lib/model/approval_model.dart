import 'package:cloud_firestore/cloud_firestore.dart';

class Vender {
 
  Vender({
  this.Name, 
  this.address, 
  this.approved, 
  this.admin,
  this.city, 
  this.coverImage, 
  this.emailAddress, 
  this.phoneNo, 
  this.pinCode, 
  this.profileImage, 
  this.time, 
  this.uid});

  



  Vender.fromJson(Map<String, Object?> json)
    : this(
        Name: json['Name']! as String,
        address: json['address']! as String,
        approved: json['approved']! as bool,
        admin: json['admin'] as bool?,
        city: json['city']! as String,
  coverImage: json['coverImage'] != null ? json['coverImage']! as String : "",

        emailAddress: json['emailAddress']! as String,
        phoneNo: json['phoneNo']! as String,
        pinCode: json['pinCode']! as String,
        profileImage: json['profileImage']! as String,
        time: json['time']! as Timestamp,
        uid: json['uid']! as String,
        
      );

  final String? Name;
  final String? address;
 final bool? approved;
   final bool? admin;
  final String? city;
  final String? coverImage;
  final String? emailAddress;
  final String? phoneNo;
  final String? pinCode;
  final String? profileImage;
  final Timestamp? time;
  final String? uid;



  Map<String, Object?> toJson() {
    return {
        'Name' : Name, 
        'address' : address, 
        'approved' :approved, 
        'admin' :admin, 
  'city' :city, 
  'coverImage' : coverImage ,
  'emailAddress' : emailAddress,
  'phoneNo' : phoneNo, 
  'pinCode' : pinCode,
   'profileImage' : profileImage, 
   'time' : time, 
  'uid' : uid,
    };
  }
}

