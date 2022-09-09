import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greet_app/controllers/login_controller.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoginController loginController = Get.find<LoginController>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: ListView(
          children: <Widget>[
            Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 32),
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 150,
                ),
              ),
            ),
            Center(
              child: Text(
                "Log In",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                controller: loginController.username,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Username or Email",
                    prefixIcon: Icon(Icons.account_circle)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                controller: loginController.password,
                obscureText: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Password",
                    prefixIcon: Icon(Icons.lock)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: SizedBox(
                height: 48,
                child: Obx(() => ElevatedButton.icon(
                      onPressed: () {
                        loginController.login();
                      },
                      icon: loginController.isLoading.value
                          ? CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.0,
                            )
                          : Icon(MdiIcons.login),
                      label: loginController.isLoading.value
                          ? Text("")
                          : Text("LOG IN"),
                    )),
              ),
            ),
            Center(child: Text("New user?")),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: SizedBox(
                height: 48,
                child: OutlinedButton(
                  onPressed: () {
                    Get.toNamed('/register');
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Theme.of(context).primaryColor),
                  ),
                  child: Text("Create an account"),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextButton(
                onPressed: () {
                  Get.toNamed('/forgotPassword');
                },
                child: Text("Forgot Password?"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
