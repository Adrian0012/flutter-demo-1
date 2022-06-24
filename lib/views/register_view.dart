import 'package:flutter/material.dart';
import 'package:noteit/constants/routes.dart';
import 'package:noteit/services/auth/auth_exceptions.dart';
import 'package:noteit/views/utilities/show_error_dialog.dart';
import '../services/auth/auth_service.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Column(
        children: [
          TextField(
            decoration: const InputDecoration(hintText: 'email'),
            controller: _email,
            keyboardType: TextInputType.emailAddress,
          ),
          TextField(
            decoration: const InputDecoration(hintText: 'password'),
            controller: _password,
            autocorrect: false,
            enableSuggestions: false,
            obscureText: true,
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await AuthService.firebase().createUser(
                  email: email,
                  password: password,
                );
                await AuthService.firebase().sendEmailVerification();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute,
                  (route) => false,
                );
              } on WeakPasswordAuthException {
                await showErrorDialog(
                  context,
                  'Weak Password.',
                );
              } on EmailAlreadyInUseAuthException {
                await showErrorDialog(
                  context,
                  'Invalid credentails.',
                );
              } on InvalidEmailAuthException {
                await showErrorDialog(
                  context,
                  'Invalid credentails.',
                );
              } on GenericAuthException {
                await showErrorDialog(
                  context,
                  'Auth Error. Please contact support.',
                );
              } catch (e) {
                await showErrorDialog(
                  context,
                  'Catastrofic Error. Please contact support.',
                );
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute,
                  (route) => false,
                );
              },
              child: const Text('Already have an account? Login here.'))
        ],
      ),
    );
  }
}
