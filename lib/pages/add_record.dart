import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kidscan_app/api/auth_api.dart';
import 'package:kidscan_app/api/child_api.dart';
import 'package:kidscan_app/api/child_record_api.dart';
import 'package:kidscan_app/models/child_record.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthAPI.login('chonahyun0615@edndev.net', '!!43214321');
  int testId = await ChildAPI.list().then((value) => value.elementAt(0).id);
  runApp(AddRecord(testId));
}

class AddRecord extends StatelessWidget {
  final int id;
  const AddRecord(this.id, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR'),
        Locale('en', 'US'),
      ],
      debugShowCheckedModeBanner: false,
      title: 'Date Picker Demo',

      // add theme
      theme: ThemeData(
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            color: Colors.yellow,
            fontWeight: FontWeight.bold,
          ),
        ),
        // primaryColor: Colors.lightBlue,
        // fontFamily: 'Georgia',
        primarySwatch: Colors.red,
      ),

      home: TextDatePicker(title: 'Flutter Demo Home Page', id: id),
    );
  }
}

class TextDatePicker extends StatefulWidget {
  final int id;
  final String title;
  const TextDatePicker({required this.title, required this.id, super.key});

  @override
  State<TextDatePicker> createState() => _TextDatePickerState();
}

class _TextDatePickerState extends State<TextDatePicker> {
  String dateCreate = '';
  String height = '';
  String weight = '';

  final _formKey = GlobalKey<FormState>();
  final _textEditingController = TextEditingController();

  Future<void> textPicker() async {
    final DateTime? pickDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate:
          DateTime.now().add(const Duration(days: -365 * 20)), // 20세 이하의 아이들만
      lastDate: DateTime.now(),
      helpText: '수정할 날짜를 선택해주세요.',
      fieldHintText: '연. 월. 일.',
      errorFormatText: '연. 월. 일. 형식으로 입력해주세요.',
      errorInvalidText: '올바른 날짜를 입력해주세요.',
      initialEntryMode: DatePickerEntryMode.calendar,
      //기본 화면 입력형 설정, 기본 설정에서 변경할 수 있도록 하면 좋을 것 같음
    );

    if (pickDate != null) {
      _textEditingController.text = pickDate.toString().substring(0, 10);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('기록 추가 화면'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: textPicker,
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _textEditingController,
                      decoration: const InputDecoration(
                        labelText: '날짜를 입력하세요',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return '입력하지 않았습니다.';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        setState(() {
                          dateCreate = _textEditingController.text;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
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
                    } else if (!RegExp(r'^[0-9]*\.?[0-9]+$').hasMatch(val)) {
                      return '잘못된 형식입니다.';
                    } else if (double.parse(val) < 30 ||
                        double.parse(val) > 200) {
                      return '잘못된 값입니다.';
                    } else {
                      return null;
                    }
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
                    } else if (!RegExp(r'^[0-9]*\.?[0-9]+$').hasMatch(val)) {
                      return '잘못된 형식입니다.';
                    } else if (double.parse(val) <= 0 ||
                        double.parse(val) > 200) {
                      return '잘못된 값입니다.';
                    } else {
                      return null;
                    }
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      await ChildRecordAPI.create(
                        widget.id,
                        ChildRecord(
                          updated: DateTime.tryParse(dateCreate),
                          height: double.parse(height),
                          weight: double.parse(weight),
                        ),
                      ).then(
                        (_) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('저장 완료'),
                                content: const Text('저장이 완료되었습니다.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('확인'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    }
                  },
                  child: const Text('저장'),
                )
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
  return Column(
    children: [
      Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      TextFormField(
        decoration: InputDecoration(
          suffix: Text(decorate),
          contentPadding: const EdgeInsets.symmetric(vertical: 1),
        ),
        onSaved: onSaved,
        validator: validator,
        autovalidateMode: AutovalidateMode.always,
      ),
      const SizedBox(height: 10.0),
    ],
  );
}
