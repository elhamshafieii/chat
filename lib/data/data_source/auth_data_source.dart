import 'dart:async';
import 'dart:io';

import 'package:chat/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class IAuthDataSource {
  Future<bool> isConnectToFirebase();
  Future signInWithPhone(String phoneNumber);
  Future verifyOtp(String verificationId, String userOTP);
  Future<UserModel> saveUserDataToFirebase(String name, File? profilePic);
  Future<UserModel?> getCurrentUserData();
  // Future<UserModel> getContactUserData(String contactUId);
  Future<void> setUserStatus(bool isOnline);
  Future<void> signOut();
  Future<String> changeProfilePic(File? profilePic);
}

class AuthFirebaseDataSource implements IAuthDataSource {
  final FirebaseAuth auth;
  final FirebaseFirestore fireStore;
  final FirebaseStorage storage;

  AuthFirebaseDataSource(
      {required this.storage, required this.fireStore, required this.auth});

  @override
  Future<bool> isConnectToFirebase() async {
    final result = await InternetAddress.lookup('firebase.google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future signInWithPhone(String phoneNumber) async {
    final completer = Completer();
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: ((PhoneAuthCredential credential) async {
        UserCredential authresult = await auth.signInWithCredential(credential);
        User? user = authresult.user;
        completer.complete(user);
      }),
      verificationFailed: (error) {
        completer.complete(error);
      },
      codeSent: (String verificationId, int? resendToken) {
        completer.complete(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) async {
        // completer.complete('timeout');
      },
    );
    return completer.future;
  }

  @override
  Future<UserModel?> verifyOtp(String verificationId, String userOTP) async {
    UserModel? userModel;
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: userOTP);
    await auth.signInWithCredential(credential);
    userModel = (await getCurrentUserData());
    if (userModel == null) {
      saveUserDataToFirebase('', null);
      userModel = (await getCurrentUserData())!;
    }
    return userModel;
  }

  @override
  Future<UserModel> saveUserDataToFirebase(
      String name, File? profilePic) async {
    String uid = auth.currentUser!.uid;
    String photoUrl = '';
    if (profilePic != null) {
      UploadTask uploadTask =
          storage.ref().child('profilePic/$uid').putFile(profilePic);
      TaskSnapshot snapshot = await uploadTask;
      photoUrl = await snapshot.ref.getDownloadURL();
    }
    final user = UserModel(
      name: name,
      uid: uid,
      profilePic: photoUrl,
      phoneNumber: auth.currentUser!.phoneNumber!,
      isOnline: true,
    );
    await fireStore.collection('users').doc(uid).set(user.toMap());
    return user;
  }

  @override
  Future<UserModel?> getCurrentUserData() async {
    var userData =
        await fireStore.collection('users').doc(auth.currentUser?.uid).get();
    UserModel? user;
    if (userData.exists) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }

  @override
  Future<void> setUserStatus(bool isOnline) async {
    await fireStore.collection('users').doc(auth.currentUser!.uid).update({
      'isOnline': isOnline,
    });
  }

  @override
  Future<void> signOut() async {
    await auth.signOut();
    ;
  }

  @override
  Future<String> changeProfilePic(File? profilePic) async {
    String uid = auth.currentUser!.uid;
    String photoUrl = '';
    if (profilePic != null) {
      UploadTask uploadTask =
          storage.ref().child('profilePic/$uid').putFile(profilePic);
      TaskSnapshot snapshot = await uploadTask;
      photoUrl = await snapshot.ref.getDownloadURL();
    }
    await fireStore
        .collection('users')
        .doc(uid)
        .update({'profilePic': photoUrl});
    ;
    return photoUrl;
  }

  // @override
  // Future<UserModel> getContactUserData(String contactUId) async {
  //   var userData = await fireStore.collection('users').doc(contactUId).get();
  //   UserModel user = UserModel.fromMap(userData.data()!);
  //   return user;
  // }
}
