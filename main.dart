import 'package:flutter/material.dart';

void main() {
  runApp(LadyPhageApp());
}

class LadyPhageApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lady Phage in Biology',
      theme: ThemeData(
        primaryColor: Color(0xFF1976D2),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _codeController = TextEditingController();

  void _login() {
    String code = _codeController.text.trim();
    if (code == "Bio2026") {
      Navigator.push(context, MaterialPageRoute(builder: (context) => StudentHome()));
    } else if (code == "Lady2026") {
      Navigator.push(context, MaterialPageRoute(builder: (context) => TeacherHome()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("كود غير صحيح")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('تسجيل الدخول')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _codeController,
              decoration: InputDecoration(labelText: 'ادخل كود الصف أو كود المدرس'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('دخول'),
            ),
          ],
        ),
      ),
    );
  }
}

class StudentHome extends StatelessWidget {
  final List<Map<String, String>> resources = [
    {
      "title": "فيديو عن Lady Phage",
      "url": "https://www.youtube.com/watch?v=xxxx" // حط لينك الفيديو هنا
    },
    {
      "title": "ملف PDF للمراجعة",
      "url": "https://example.com/file.pdf" // حط لينك PDF هنا
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("موارد الطالب")),
      body: ListView.builder(
        itemCount: resources.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(resources[index]['title']!),
            trailing: Icon(Icons.open_in_new),
            onTap: () {
              // هنا ممكن نضيف فتح الفيديو أو PDF
            },
          );
        },
      ),
    );
  }
}

class TeacherHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("لوحة تحكم المدرس")),
      body: Center(child: Text("هنا لوحة التحكم لرفع الفيديوهات وملفات PDF")),
    );
  }
}