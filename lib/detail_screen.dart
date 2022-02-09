import 'package:flutter/material.dart';
import 'package:registration_form10/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const _DetailScreen(),
    );
  }
}

class _DetailScreen extends StatefulWidget {
  const _DetailScreen({Key? key}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<_DetailScreen> {
  SharedPreferences? userdata;
  String username = '';
  @override
  void initState() {
    super.initState();
    initial();
  }

  void initial() async {
    userdata = await SharedPreferences.getInstance();
    setState(() {
      username = userdata?.getString('username') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Главная страница"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(26.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text(
                'Hello, $username',
                style:
                const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            MaterialButton(
              textColor: Colors.white,
              color: Colors.grey,
              onPressed: () {
                userdata?.setBool('login', true);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeScreen()));
              },
              child: const Text('Выход'),
            )
          ],
        ),
      ),
    );
  }
}