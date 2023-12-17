import 'package:client_app/firebase/authuser.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../Login/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  String email = '';
  String password = '';
  String name = '';
  String selectedRole = 'student';
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            textInputAction: TextInputAction.done,
            //obscureText: true,
            controller: nameController,
            cursorColor: kPrimaryColor,
            onSaved: (nm) {
              name = nm!;
            },
            decoration: InputDecoration(
              hintText: "Full Name",
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: defaultPadding),
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              controller: emailController,
              cursorColor: kPrimaryColor,
              onSaved: (em) {
                email = em!;
              },
              decoration: InputDecoration(
                hintText: "Your email",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.person),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: defaultPadding),
            child: TextFormField(
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              controller: phoneController,
              cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                hintText: "Enter Mobile Number",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.phone_android_outlined),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: defaultPadding),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              cursorColor: kPrimaryColor,
              controller: passwordController,
              onSaved: (pass) {
                password = pass!;
              },
              decoration: InputDecoration(
                hintText: "Your password",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: defaultPadding),
            child: DropdownButtonFormField<String>(
              value: selectedRole,
              onChanged: (String? value) {
                selectedRole = value!;
              },
              items: [
                DropdownMenuItem<String>(
                  value: 'student',
                  child: Text('Student'),
                ),
                DropdownMenuItem<String>(
                  value: 'teacher',
                  child: Text('Teacher'),
                ),
                DropdownMenuItem<String>(
                  value: 'guest',
                  child: Text('Guest'),
                ),
              ],
              decoration: InputDecoration(
                hintText: "Select your role",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.person),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: defaultPadding),
            child: TextFormField(
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              controller: idController,
              cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                hintText: selectedRole == 'student'
                    ? "Enter Roll Number"
                    : selectedRole == 'teacher'
                        ? "Enter Teacher ID"
                        : "Enter Aadhaar Number",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.person),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                AuthServices.signupUser(email, password, name, selectedRole,
                    idController.text, phoneController.text, context);
                // Clear form fields
                nameController.clear();
                emailController.clear();
                phoneController.clear();
                passwordController.clear();
                idController.clear();

                selectedRole = 'student';
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: const Color.fromARGB(255, 255, 255, 255)
                          .withOpacity(0.8),
                      title: Text('Info'),
                      content: Text(
                        'This is a development model. In the production model with a Business API, which is acquired by a GST number, this will be replaced by a popup that asks for payment of 100 rupees as security deposite which will be refunded when the user has to delete its account.',
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return LoginScreen();
                                },
                              ),
                            ); // Close the alert box
                          },
                          child: Text('Go to Login Screen'),
                        ),
                      ],
                    );
                  },
                );
              }
            },
            child: Text("Sign Up".toUpperCase()),
          ),
          const SizedBox(height: defaultPadding),
        ],
      ),
    );
  }
}
