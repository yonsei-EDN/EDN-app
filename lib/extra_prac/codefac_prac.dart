import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: FormScreen());
  }
}

class DefaultAppbarLayout extends StatefulWidget {
  final String title;
  final Widget child;

  DefaultAppbarLayout({
    required Widget child,
    String? title,
  })  : this.title = title ?? '연습',
        this.child = child;

  @override
  _DefaultAppbarLayoutState createState() => _DefaultAppbarLayoutState();
}

class _DefaultAppbarLayoutState extends State<DefaultAppbarLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
      ),
      body: widget.child,
    );
  }
}

class FormScreen extends StatefulWidget {
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final formKey = GlobalKey<FormState>();

  String name = '';
  String email = '';
  String password = '';
  String address = '';
  String nickname = '';

  renderButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
      ),
      onPressed: () async {
        if (formKey.currentState!.validate()) {
// validation 이 성공하면 true 가 리턴돼요!
          formKey.currentState!.save();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('저장완료', style: TextStyle(color: Colors.yellow)),
              duration: Duration(milliseconds: 500),
            ),
          );
        }
      },
      child: Text(
        '저장하기!',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  renderValues() {
    return Column(
      children: [
        Text('name: $name'),
        Text('email: $email'),
        Text(
          'password: $password',
        ),
        Text(
          'address: $address',
        ),
        Text(
          'nickname: $nickname',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultAppbarLayout(
      child: Center(
        child: SizedBox(
          width: 400,
          child: Form(
            key: formKey,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 70,
                    child: Center(
                      child: Text('나의 건강 프로필', style: TextStyle(fontSize: 20)),
                    ),
                  ),
                  renderTextFormField(
                    label: '이름',
                    onSaved: (val) {
                      setState(() {
                        name = val;
                      });
                    },
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return '값을 입력해 주세요.';
                      }

                      if (val.length < 2) {
                        return '이름은 두글자 이상 입력해 주셔야 합니다.';
                      }

                      return null;
                    },
                  ),
                  renderTextFormField(
                    label: '이메일',
                    onSaved: (val) {
                      setState(() {
                        email = val;
                      });
                    },
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return '값을 입력해 주세요.';
                      }

                      if (!RegExp(
                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                          .hasMatch(val)) {
                        return '잘못된 이메일 형식입니다.';
                      }

                      return null;
                    },
                  ),
                  renderTextFormField(
                    label: '비밀번호',
                    onSaved: (val) {
                      setState(() {
                        password = val;
                      });
                    },
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return '값을 입력해 주세요.';
                      }

                      if (val.length < 8) {
                        return '8자 이상 입력해주세요!';
                      }

                      return null;
                    },
                  ),
                  renderTextFormField(
                    label: '주소',
                    onSaved: (val) {
                      setState(() {
                        address = val;
                      });
                    },
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return '값을 입력해 주세요.';
                      }
                      return null;
                    },
                  ),
                  renderTextFormField(
                    label: '닉네임',
                    onSaved: (val) {
                      setState(() {
                        nickname = val;
                      });
                    },
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return '값을 입력해 주세요.';
                      }

                      if (val.length < 8) {
                        return '닉네임은 8자 이상 입력해주세요!';
                      }

                      return null;
                    },
                  ),
                  renderButton(),
                  renderValues(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

renderTextFormField({
  required String label,
  required FormFieldSetter onSaved,
  required FormFieldValidator validator,
}) {
  assert(onSaved != null);
  assert(validator != null);

  return Column(
    children: [
      Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      TextFormField(
        onSaved: onSaved,
        validator: validator,
        autovalidateMode: AutovalidateMode.always,
      ),
      SizedBox(height: 10.0),
    ],
  );
}
