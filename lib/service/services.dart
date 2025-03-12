import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseService{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      print("User logged in: ${userCredential.user?.email}");
      return userCredential.user;

    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User getCurrentUser() {
    return _auth.currentUser!;
  }

  getUserData(String userId) async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return userDoc.data();
  }

  Future<void> addNote(String title, String imageUrl) async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('noted')
          .add({
        'title': title,
        'image': imageUrl,
        'createdAt': FieldValue.serverTimestamp(), // Menyimpan timestamp
      });
    }
  }

  Stream<QuerySnapshot> getNotes() {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('noted')
          .orderBy('createdAt', descending: true)
          .snapshots();
    }
    return const Stream.empty();
  }

  Future<void> updateNote(String noteId, String newTitle, String newImageUrl) async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('noted')
          .doc(noteId)
          .update({
        'title': newTitle,
        'image': newImageUrl,
      });
    }
  }

  Future<void> deleteNote(String noteId) async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('noted')
          .doc(noteId)
          .delete();
    }
  }

  Future<void> loadProfile() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
    }
  }

  Future<void> updateProfile(String firstName, String lastName, String profileImageUrl) async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({
        'first_name': firstName,
        'last_name': lastName,
        'profileImageUrl': profileImageUrl,
      });
    }
  }

  Future<void> updateProfileImage(String profileImageUrl) async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({
        'profileImageUrl': profileImageUrl,
      });
    }
  }

  Future<void> updateProfileName(String firstName, String lastName) async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({
        'first_name': firstName,
        'last_name': lastName,
      });
    }
  }

  Future<void> updateProfileEmail(String email) async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      await FirebaseAuth.instance.currentUser?.updateEmail(email);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({
        'email': email,
      });
    }
  }

  Future<void> updateProfilePassword(String password) async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      await FirebaseAuth.instance.currentUser?.updatePassword(password);
    }
  }

  Future<void> deleteProfile() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .delete();
      await FirebaseAuth.instance.currentUser?.delete();
    }
  }

  Future<void> forgotPassword(String email) async {
    if (email.isEmpty) {
      throw Exception("Email tidak boleh kosong.");
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception("Email tidak terdaftar.");
      } else {
        throw Exception("Terjadi kesalahan. Silakan coba lagi.");
      }
    } catch (e) {
      throw Exception("Terjadi kesalahan yang tidak terduga.");
    }
  }

  Future<void> deleteAccount() async {
    await FirebaseAuth.instance.currentUser?.delete();
  }

  Future<void> changePassword(String newPassword) async {
    await FirebaseAuth.instance.currentUser?.updatePassword(newPassword);
  }

  // Mengirim email verifikasi
  Future<void> sendEmailVerification() async {
    User? user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  // Mengecek apakah email sudah diverifikasi
  bool isEmailVerified() {
    User? user = _auth.currentUser;
    return user?.emailVerified ?? false;
  }

  // Refresh status user (untuk mengecek apakah email sudah diverifikasi)
  Future<void> reloadUser() async {
    User? user = _auth.currentUser;
    await user?.reload();
  }

}
