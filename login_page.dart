import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:login_test/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController unm = TextEditingController();
  final TextEditingController pwd = TextEditingController();
  LoginPage({super.key});
  HomePage get context => const HomePage();
  @override
  Widget build(BuildContext context) {
    startLogin1(context);
    return Material(
      child: Column(
        children: [
          Image.asset(
            'assets/images/register.gif',
            fit: BoxFit.cover,
          ),
          const SizedBox(
            height: 20.0,
          ),
          const Text(
            'Welcome Admin ! ',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: unm,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Colors.deepPurple)),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                TextField(
                  controller: pwd,
                  obscureText: true,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Colors.deepPurple)),
                    labelText: 'Password',
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                ElevatedButton(
                  onPressed: () {
                    startLogin(context);
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 12.0,
                    textStyle: const TextStyle(color: Colors.white),
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: const Text('Log In'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void onLoad(BuildContext context) {
    startLogin1(context);
  }

  Future startLogin1(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? stringValue = prefs.getString("username");
    if (stringValue != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }

  Future startLogin(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? stringValue = prefs.getString("username");
    if (stringValue == null) {
      var url =
          Uri.parse("https://loginiusinfotech.com/CashBook/fluttertest.php");
      var response = await http.post(url, body: {
        "username": unm.text,
        "password": pwd.text,
      });
      var data = json.decode(response.body);
      if (data.toString() == "Success") {
        Fluttertoast.showToast(
          msg: 'Login Successful',
          backgroundColor: Colors.green,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
        );
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('username', unm.text);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        Fluttertoast.showToast(
          backgroundColor: Colors.red,
          textColor: Colors.white,
          msg: 'Invalid Username Or Password',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
        );
      }
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }
}
