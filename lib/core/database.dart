import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Database {
  static String? userUid;
  FirebaseFirestore? firestore;
  initiliase() {
    firestore = FirebaseFirestore.instance;
  }

  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> create(
      String username, String email, String address, String contact) async {
    try {
      await firestore!
          .collection("ServiceProvider")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        "username": username,
        "email": email,
        "address": address,
        "contact": contact,
      });
    } catch (e) {
      print(e);
    }
  }

  Future postDetailsToFirestore(String image, String emailtxt, String passtxt,
      String username, String address, String cell, String role) async {
    await _auth.createUserWithEmailAndPassword(
        email: emailtxt, password: passtxt);
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    await firebaseFirestore.collection("admin").doc(user!.uid).set({
      'username': username,
      'email': emailtxt,
      'address': address,
      'contact': cell,
      'role': role
    });
  }

  Future postUserDetailsToFirestore(
      String? image,
      String emailtxt,
      String passtxt,
      String username,
      String address,
      String cell,
      String role) async {
    await _auth.createUserWithEmailAndPassword(
        email: emailtxt, password: passtxt);
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    await firebaseFirestore.collection(role).doc(user!.uid).set({
      'image': image == null ? 'abcd' : image,
      'username': username,
      'email': emailtxt,
      'address': address,
      'contact': cell,
      'role': role
    });
  }

  Future RegisterDoc(
      String image,
      String name,
      String category,
      String experience,
      String cell,
      String days,
      String from,
      String to,
      String proficiency,
      String shortinfo,
      String desc) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    await firebaseFirestore.collection('doctor').add({
      'image': image,
      'name': name,
      'category': category,
      'experience': experience,
      'contact': cell,
      'days': days,
      'from': from,
      'to': to,
      'Proficiency': proficiency,
      'shortinfo': shortinfo,
      'desc': desc
    });
  }

  Future EditDoc(
      String image,
      String name,
      String category,
      String experience,
      String cell,
      String days,
      String from,
      String to,
      String proficiency,
      String shortinfo,
      String desc,
      String docid) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    await firebaseFirestore.collection('doctor').doc(docid).update({
      'image': image,
      'name': name,
      'category': category,
      'experience': experience,
      'contact': cell,
      'days': days,
      'from': from,
      'to': to,
      'Proficiency': proficiency,
      'shortinfo': shortinfo,
      'desc': desc
    });
  }

  Future<void> SetAppointment(String docname, String docid, String uid,
      String time, String date, String status) async {
    try {
      await firestore!.collection("appointments").doc().set({
        "docname": docname,
        "docid": docid,
        "patientid": uid,
        "time": time,
        "date": date,
        "status": status
      });
    } catch (e) {
      print(e);
    }
  }

  Future<List> read() async {
    QuerySnapshot querySnapshot;
    List docs = [];
    try {
      querySnapshot =
          await FirebaseFirestore.instance.collection('doctor').get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          Map a = {
            "id": doc.id,
            "category": doc["category"],
            "contact": doc["contact"],
            "days": doc["days"],
            "experience": doc["experience"],
            "from": doc["from"],
            "image": doc['image'],
            "name": doc["name"],
            "to": doc["to"],
          };
          docs.add(a);
        }
        return docs;
      }
    } catch (e) {
      print(e);
    }
    return docs;
  }

  Future<List> readEntry() async {
    QuerySnapshot querySnapshot;
    List docs = [];
    try {
      querySnapshot = await firestore!
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('newEntry')
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          Map a = {
            "id": doc.id,
            "from": doc['from'],
            "to": doc["to"],
            "project": doc["project"],
            "additionalInfo": doc["additionalInfo"],
            "date": doc["date"]
          };
          docs.add(a);
        }
        return docs;
      }
    } catch (e) {
      print(e);
    }
    return docs;
  }

  Future readUser() async {
    var querySnapshot;
    try {
      querySnapshot = await firestore!
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      if (querySnapshot.isNotEmpty) {
        return querySnapshot;
      }
    } catch (e) {
      print(e);
    }
    return querySnapshot;
  }

  Future<List> readFromUser(String docid) async {
    QuerySnapshot querySnapshot;
    List docs = [];
    try {
      querySnapshot = await firestore!
          .collection('users')
          .doc(docid)
          .collection('newEntry')
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          Map a = {
            "id": doc.id,
            "from": doc['from'],
            "to": doc["to"],
            "project": doc["project"],
            "additionalInfo": doc["additionalInfo"],
            "date": doc["date"]
          };
          docs.add(a);
        }
        return docs;
      }
    } catch (e) {
      print(e);
    }
    return docs;
  }

  Future<void> update(String id, String from, String to, String project,
      String additionalInfo, String date) async {
    try {
      await firestore!
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('ApproveEntery')
          .doc(id)
          .update({
        "from": from,
        "to": to,
        "project": project,
        "additionalInfo": additionalInfo,
        "date": date
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> delete(String id) async {
    try {
      await firestore!
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("newEntry")
          .doc(id)
          .delete();
    } catch (e) {
      print(e);
    }
  }
}
