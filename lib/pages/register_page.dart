import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register page'),
      ),
      body: Form(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: const InputDecoration(hintText: "First Name"),
                ),
                TextFormField(
                  decoration: const InputDecoration(hintText: "Last Name"),
                ),
                TextFormField(
                  decoration: const InputDecoration(hintText: "Username"),
                ),
                TextFormField(
                  decoration: const InputDecoration(hintText: "Email"),
                ),
                TextFormField(
                  decoration: const InputDecoration(hintText: "Password"),
                  obscureText: true,
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(hintText: "Repeat password"),
                  obscureText: true,
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(onPressed: () {}, child: const Text("Submit")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
