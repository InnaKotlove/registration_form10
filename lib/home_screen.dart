import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  String username = '';
  String password = '';
  late SharedPreferences userdata;
  late bool user;

  var passwordController = TextEditingController();
  var userNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkVerificationLogin();
  }

  void checkVerificationLogin() async {
    userdata = await SharedPreferences.getInstance();
    userNameController.text = userdata.getString('username') ?? '';
    passwordController.text = userdata.getString('password') ?? '';
    user = (userdata.getBool('login') ?? true);
    print(user);
    if (user == false) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => DetailScreen()));
    }
  }

  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Введите логин и пароль'), centerTitle: true),
        body: Container(
            padding: EdgeInsets.all(10.0),
            child: Center(
                child: Column(children: <Widget>[
              const Text(
                'Введите логин:',
                style: TextStyle(fontSize: 10.0),
              ),
              TextFormField(
                controller: userNameController,
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Введите пароль:',
                style: TextStyle(fontSize: 10.0),
              ),
              TextFormField(
                controller: passwordController,
              ),
              const SizedBox(height: 20.0),
              Container(
                  padding: const EdgeInsets.fromLTRB(80, 30, 20, 30),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      MaterialButton(
                        textColor: Colors.white,
                        color: Colors.grey,
                        onPressed: () {
                          String username = userNameController.text;
                          String password = passwordController.text;
                          if (username != '' && password != '') {
                            userdata.setBool('login', false);
                            userdata.setString('username', username);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailScreen()));
                          }
                        },
                        child: const Text("Вход"),
                      ),
                      const SizedBox(width: 20),
                      MaterialButton(
                        textColor: Colors.white,
                        color: Colors.grey,
                        onPressed: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const MyRegisterPage()));
                          setState(() {
                            userNameController.text =
                                userdata.getString('username') ?? '';
                            passwordController.text =
                                userdata.getString('password') ?? '';
                          });
                        },
                        child: const Text('Регистрация'),
                      ),
                    ],
                  ))
            ]))));
  }
}

class MyRegisterPage extends StatefulWidget {
  const MyRegisterPage({Key? key}) : super(key: key);

  @override
  _MyRegisterPageState createState() => _MyRegisterPageState();
}

class _MyRegisterPageState extends State<MyRegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  Future<void> _save(String username, String email, String password) async {
    var _pref = await SharedPreferences.getInstance();
    await _pref.setString('username', username);
    await _pref.setString('password', password);
    await _pref.setString('email', email);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Форма регистрации",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                        controller: _userController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Логин',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Введите логин';
                          }
                        }),
                    const SizedBox(height: 20),
                    TextFormField(
                        controller: _passController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Пароль',
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Введите свой пароль';
                          }
                        }),
                    const SizedBox(height: 20),
                    TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'E-mail',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Введите свой E-mail';
                          }
                          if (!value.contains('@'))
                            // ignore: curly_braces_in_flow_control_structures
                            return ' Это не E-mail ';
                        }),
                    const SizedBox(height: 20),
                    MaterialButton(
                      textColor: Colors.white,
                      color: Colors.grey,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _save(_userController.text, '', _passController.text);
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Сохранить'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
