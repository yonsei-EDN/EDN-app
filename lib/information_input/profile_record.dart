import 'dart:async';

import 'package:flutter/material.dart';
import '../local_txt/store_txt.dart';

class ProfileRecord extends StatelessWidget {
  const ProfileRecord({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('오늘의 기록')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileEnter(),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                child: Text('홈으로'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileEnter extends StatefulWidget {
  const ProfileEnter({super.key});

  @override
  State<ProfileEnter> createState() => _ProfileEnterState();
}

class _ProfileEnterState extends State<ProfileEnter> {
  final formKey = GlobalKey<FormState>();
  final ProfileStorage storage = ProfileStorage();
  String year = '';
  String month = '';
  String day = '';
  String height = '';
  String weight = '';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 250,
        child: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                renderTextFormField(
                  decorate: '년',
                  label: '년',
                  onSaved: (val) {
                    setState(() {
                      year = val;
                    });
                  },
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return '값을 입력해 주세요.';
                    }

                    if (!RegExp(r'^[0-9]{4}$').hasMatch(val)) {
                      return '4자리 숫자입니다.';
                    }

                    return null;
                  },
                ),
                renderTextFormField(
                  decorate: '월',
                  label: '월',
                  onSaved: (val) {
                    setState(() {
                      month = val;
                    });
                  },
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return '값을 입력해 주세요.';
                    }

                    if (!RegExp(r'^[0-9]{1,2}$').hasMatch(val)) {
                      return '2자리 이내의 숫자입니다.';
                    }

                    return null;
                  },
                ),
                renderTextFormField(
                  decorate: '일',
                  label: '일',
                  onSaved: (val) {
                    setState(() {
                      day = val;
                    });
                  },
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return '값을 입력해 주세요.';
                    }

                    if (!RegExp(r'^[0-9]{1,2}$').hasMatch(val)) {
                      return '2자리 이내의 숫자입니다.';
                    }

                    return null;
                  },
                ),
                renderTextFormField(
                  decorate: 'cm',
                  label: '키',
                  onSaved: (val) {
                    setState(() {
                      height = val;
                    });
                  },
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return '값을 입력해 주세요.';
                    }
                    if (!RegExp(r'^[0-9]*\.?[0-9]+$').hasMatch(val)) {
                      return '잘못된 형식입니다.';
                    }

                    return null;
                  },
                ),
                renderTextFormField(
                  decorate: 'kg',
                  label: '몸무게',
                  onSaved: (val) {
                    setState(() {
                      weight = val;
                    });
                  },
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return '값을 입력해 주세요.';
                    }

                    if (!RegExp(r'^[0-9]*\.?[0-9]+$').hasMatch(val)) {
                      return '잘못된 형식입니다.';
                    }

                    return null;
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      // validation 이 성공하면 true 가 리턴돼요!
                      formKey.currentState!.save();
                      storage.writeProfile(year, month, day, height, weight);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('저장완료',
                              style: TextStyle(color: Colors.yellow)),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

renderTextFormField({
  required String label,
  required String decorate,
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
              fontSize: 16.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      TextFormField(
        decoration: InputDecoration(
          suffix: Text(decorate),
          contentPadding: EdgeInsets.symmetric(vertical: 1),
        ),
        onSaved: onSaved,
        validator: validator,
        autovalidateMode: AutovalidateMode.always,
      ),
      SizedBox(height: 10.0),
    ],
  );
}
