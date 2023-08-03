import 'package:flutter/material.dart';
import 'package:kidscan_app/api/auth_api.dart';
import 'package:kidscan_app/api/exceptions.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _obscureText1 = true;
  bool _obscureText2 = true;

  final _formkey = GlobalKey<FormState>();
  String userEmail = '';
  String userPassword1 = '';
  String userPassword2 = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              const Text('이메일을 입력해주세요'),
              TextFormField(
                decoration: const InputDecoration(labelText: '이메일 입력'),
                // autovalidateMode: AutovalidateMode.always,
                onSaved: (newValue) {
                  setState(() {
                    userEmail = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '값을 입력해주세요';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('비밀번호를 입력해주세요'),
              TextFormField(
                obscureText: _obscureText1,
                decoration: InputDecoration(
                  labelText: '비밀번호 입력',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText1 ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText1 = !_obscureText1;
                      });
                    },
                  ),
                ),
                // autovalidateMode: AutovalidateMode.always,
                onSaved: (newValue) {
                  setState(
                    () {
                      userPassword1 = newValue!;
                    },
                  );
                },
                validator: (value) =>
                    value == null || value.isEmpty ? '값을 입력해주세요' : null,
              ),
              const Text('비밀번호를 다시 한번 입력해 주세요'),
              TextFormField(
                obscureText: _obscureText2,
                decoration: InputDecoration(
                  labelText: '비밀번호 확인',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText2 ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText2 = !_obscureText2;
                      });
                    },
                  ),
                ),
                // autovalidateMode: AutovalidateMode.always,
                onSaved: (newValue) {
                  setState(
                    () {
                      userPassword2 = newValue!;
                    },
                  );
                },
                validator: (value) =>
                    value == null || value.isEmpty ? '값을 입력해주세요' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () async {
                    if (_formkey.currentState!.validate()) {
                      _formkey.currentState!.save();

                      if (userPassword1 != userPassword2) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('비밀번호가 일치하지 않습니다.'),
                            duration: Duration(milliseconds: 500),
                          ),
                        );
                      } else {
                        try {
                          await AuthAPI.register(
                              userEmail, userPassword1, userPassword2);
                          if (mounted) showAlertDialog(context);
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
                    }
                  },
                  child: const Text('가입하기'))
            ],
          ),
        ),
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
    return '에러입니다.';
  }
}

void showAlertDialog(BuildContext context) {
  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("가입이 완료되었습니다!"),
    content: const Text("로그인 화면으로 다시 이동합니다."),
    actions: [
      TextButton(
        child: const Text("확인"),
        onPressed: () {
          // Dismiss the dialog by calling Navigator.pop
          Navigator.pop(context);
          Navigator.pop(context);
        },
      ),
    ],
  );

  // Show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
