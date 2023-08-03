import 'package:flutter/material.dart';
import 'package:kidscan_app/api/auth_api.dart';
import 'package:kidscan_app/api/child_api.dart';
import 'package:kidscan_app/api/exceptions.dart';
import 'package:kidscan_app/models/child.dart';
import 'package:kidscan_app/pages/homepage.dart';
import 'package:kidscan_app/signup.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'KidScan',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 50),
            const LogForm(),
            TextButton(
              child: const Text('회원가입하기'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class LogForm extends StatefulWidget {
  const LogForm({super.key});

  @override
  State<LogForm> createState() => _LogFormState();
}

class _LogFormState extends State<LogForm> {
  bool _obscureText = true;
  final _formkey = GlobalKey<FormState>();
  String userEmail = '';
  String userPassword = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              labelText: '이메일 입력',
            ),
            // autovalidateMode: AutovalidateMode.always,
            onSaved: (newValue) {
              setState(() {
                userEmail = newValue!;
              });
            },
            validator: (value) =>
                value == null || value.isEmpty ? '값을 입력해주세요' : null,
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            obscureText: _obscureText,
            decoration: InputDecoration(
              labelText: '비밀번호 입력',
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
            ),
            // autovalidateMode: AutovalidateMode.always,
            onSaved: (newValue) {
              setState(
                () {
                  userPassword = newValue!;
                },
              );
            },
            validator: (value) =>
                value == null || value.isEmpty ? '값을 입력해주세요' : null,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () async {
                if (_formkey.currentState!.validate()) {
                  _formkey.currentState!.save();
                  try {
                    await AuthAPI.login(userEmail, userPassword);

                    ///List<int>로 넘겨야 함이 맞으나 일단 1개만
                    final List<Child> userChilds = await ChildAPI.list();
                    final int userChildId = userChilds[0].id;
                    if (mounted) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                HomePage(childId: userChildId),
                          ));
                    }
                  } catch (e) {
                    String msg = getErrorMsg(e);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(msg),
                        duration: const Duration(milliseconds: 500),
                      ),
                    );
                  }
                }
              },
              child: const Text('로그인'))
        ],
      ),
    );
  }
}

String getErrorMsg(Object e) {
  if (e is UnwantedResponse) {
    return e.body.values.elementAt(0).elementAt(0).toString();
  } else if (e is FailedRequest) {
    return e.message;
  } else if (e is LoginRequired) {
    return '로그인이 필요한 서비스입니다.';
  } else {
    return e.toString();
  }
}
