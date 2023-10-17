import 'dart:io';

import 'package:chat/data/data_source/auth_data_source.dart';
import 'package:chat/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

final authRepository = AuthRepository(
    dataSource: AuthFirebaseDataSource(
        auth: FirebaseAuth.instance,
        fireStore: FirebaseFirestore.instance,
        storage: FirebaseStorage.instance));

abstract class IAuthRepository {
  Future<bool> isConnectToFirebase();
  Future signInWithPhone(String phoneNumber);
  Future verifyOtp(String verificationId, String userOTP);
  Future<void> saveUserDataToFirebase(String name, File? profilePic);
  Future<UserModel?> getCurrentUserData();
  // Future<UserModel> getContactUserData(String contactUId);
  Future<void> setUserStatus(bool isOnline);
   Future<void> signOut();
}

class AuthRepository implements IAuthRepository {
  final IAuthDataSource dataSource;

  AuthRepository({required this.dataSource});

  @override
  Future<bool> isConnectToFirebase() async {
    return await dataSource.isConnectToFirebase();
  }

  @override
  Future signInWithPhone(String phoneNumber) async {
    final output = await dataSource.signInWithPhone(phoneNumber);
    return output;
  }

  @override
  Future verifyOtp(
    String verificationId,
    String userOTP,
  ) async {
    final output = await dataSource.verifyOtp(verificationId, userOTP);
    return output;
  }

  @override
  Future<void> saveUserDataToFirebase(String name, File? profilePic) async {
    return await dataSource.saveUserDataToFirebase(name, profilePic);
  }

  @override
  Future<UserModel?> getCurrentUserData() async {
    return await dataSource.getCurrentUserData();
  }

  @override
  Future<void> setUserStatus(bool isOnline) async {
    await dataSource.setUserStatus(isOnline);
  }
  
  @override
  Future<void> signOut() async{
    await dataSource.signOut();
  }

  // @override
  // Future<UserModel> getContactUserData(String contactUId) async {
  //   return dataSource.getContactUserData(contactUId);
  // }
}
