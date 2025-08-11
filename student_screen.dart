import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/content_item.dart';
import 'video_player_screen.dart';
import 'pdf_viewer_screen.dart';

class StudentScreen extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('واجهة الطالب')),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('content').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          List<ContentItem> items = snapshot.data!.docs
              .map((doc) => ContentItem.fromMap(doc.data() as Map<String, dynamic>, doc.id))
              .toList();

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              var item = items[index];
              return ListTile(
                title: Text(item.title),
                subtitle: Text(item.type.toUpperCase()),
                onTap: () {
                  if (item.type == 'video') {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => VideoPlayerScreen(url: item.url)));
                  } else if (item.type == 'pdf') {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => PdfViewerScreen(url: item.url)));
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}