import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/content_item.dart';

class TeacherScreen extends StatefulWidget {
  @override
  _TeacherScreenState createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  bool isLoading = false;

  Future<void> uploadFile(String type) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: type == 'video' ? FileType.video : FileType.custom,
      allowedExtensions: type == 'pdf' ? ['pdf'] : null,
    );

    if (result != null) {
      setState(() => isLoading = true);
      var fileBytes = result.files.first.bytes;
      var fileName = result.files.first.name;

      var ref = storage.ref().child('$type/$fileName');
      await ref.putData(fileBytes!);
      String url = await ref.getDownloadURL();

      await firestore.collection('content').add({
        'title': fileName,
        'url': url,
        'type': type,
      });

      setState(() => isLoading = false);
    }
  }

  Future<void> deleteItem(String id) async {
    await firestore.collection('content').doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('لوحة تحكم المدرس')),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => uploadFile('video'),
                child: Text('رفع فيديو'),
              ),
              ElevatedButton(
                onPressed: () => uploadFile('pdf'),
                child: Text('رفع PDF'),
              ),
            ],
          ),
          if (isLoading) LinearProgressIndicator(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestore.collection('content').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

                var docs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    var doc = docs[index];
                    var item = ContentItem.fromMap(doc.data() as Map<String, dynamic>, doc.id);

                    return ListTile(
                      title: Text(item.title),
                      subtitle: Text(item.type.toUpperCase()),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deleteItem(item.id),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}