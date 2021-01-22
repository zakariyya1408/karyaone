import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class HalamanTambah extends StatefulWidget {
  @override
  _HalamanTambahState createState() => _HalamanTambahState();
}

class _HalamanTambahState extends State<HalamanTambah> {
  final _formKey = GlobalKey<FormBuilderState>();
  String _imgurl;
  File _file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Center(
              child: Column(
                children: [
                  _file != null
                      ? CircleAvatar(
                          backgroundColor: Colors.red,
                          radius: 100,
                          backgroundImage: NetworkImage(_imgurl),
                        )
                      : CircleAvatar(
                          backgroundColor: Colors.red,
                          radius: 100,
                        ),
                  RaisedButton(
                    onPressed: _selectAndUpload,
                    child: Text(
                      'Browse',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: FormBuilder(
              key: _formKey,
              child: Column(
                children: [
                  FormBuilderTextField(
                    decoration: InputDecoration(hintText: "Nama Perusahaan"),
                    name: 'title',
                    maxLines: 1,
                  ),
                  FormBuilderTextField(
                    decoration: InputDecoration(hintText: "Alamat"),
                    name: 'alamat',
                    maxLines: 1,
                  ),
                  FormBuilderTextField(
                    decoration: InputDecoration(hintText: "Posisi"),
                    name: 'posisi',
                    maxLines: 1,
                  ),
                  FormBuilderTextField(
                    decoration: InputDecoration(hintText: "Website"),
                    name: 'website',
                    initialValue: 'http://',
                    maxLines: 1,
                  ),
                  FormBuilderTextField(
                    decoration: InputDecoration(hintText: "Persyaratan"),
                    name: 'persyaratan',
                    maxLines: 5,
                  ),
                  FormBuilderTextField(
                    decoration: InputDecoration(hintText: "Deskripsi"),
                    name: 'deskripsi',
                    maxLines: 5,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState.saveAndValidate()) {
                          storeData();
                          Navigator.pop(context);
                        }
                      },
                      child: Text('Submit'),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _selectAndUpload() async {
    final _firebaseStorage = FirebaseStorage.instance;
    final _picker = ImagePicker();
    // ignore: deprecated_member_use
    final PickedFile image = await _picker.getImage(
      source: ImageSource.gallery,
    );
    var file = File(image.path);
    var fileName = basename(image.path);

    if (image != null) {
      //Upload to Firebase
      var snapshot = await _firebaseStorage
          .ref()
          .child('perusahaan/$fileName')
          .putFile(file)
          .onComplete;
      var downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        _imgurl = downloadUrl;
        _file = File(image.path);
      });
    }
  }

  void storeData() {
    final firestoreInstance = FirebaseFirestore.instance;
    firestoreInstance.collection("perusahaan").add({
      "title": _formKey.currentState.value['title'],
      "alamat": _formKey.currentState.value['alamat'],
      "posisi": _formKey.currentState.value['posisi'],
      "website": _formKey.currentState.value['website'],
      "persyaratan": _formKey.currentState.value['persyaratan'],
      "deskripsi": _formKey.currentState.value['deskripsi'],
      "url": _imgurl,
    }).then((value) {
      print(value.id);
    });
  }
}
