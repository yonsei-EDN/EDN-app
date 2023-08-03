import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kidscan_app/api/child_record_api.dart';
import 'package:kidscan_app/models/child_record.dart';

//수정화면
//TODO: initial value를 넣고 수정하기 버튼을 클릭했을 때 textformfield를
//활성화시키면 좋을 것 같으나 controller와 initial value는 동시에 사용 불가능하여 정체중
class RecordModify extends StatelessWidget {
  final int childId;
  final int recordId;
  const RecordModify(this.childId, this.recordId, {super.key});

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

      home: TextDatePicker2(childId, recordId),
    );
  }
}

class TextDatePicker2 extends StatefulWidget {
  final int childId;
  final int recordId;
  const TextDatePicker2(this.childId, this.recordId, {super.key});

  @override
  State<TextDatePicker2> createState() => _TextDatePicker2State();
}

class _TextDatePicker2State extends State<TextDatePicker2> {
  late final int childId;
  late final int recordId;
  String dateCreate = '';
  String height = '';
  String weight = '';

  bool loading = true;

  final _formKey = GlobalKey<FormState>();
  late final _textEditingController = TextEditingController();

  Future<void> _getRecord() async {
    ChildRecordAPI.read(childId, recordId).then((record) {
      setState(() {
        _textEditingController.text = 'dddd';
        dateCreate = record.updated.toString();
        height = record.height.toString();
        weight = record.weight.toString();
        loading = false;
      });
    });
  }

  @override
  initState() {
    super.initState();
    childId = widget.childId;
    recordId = widget.recordId;
    _getRecord();
  }

  void dispose() {
    print("dispose");
    _textEditingController.dispose();
    super.dispose();
  }

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
        title: const Text('기록 수정 화면'),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
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
                            // initialValue: dateCreate,
                            decoration: const InputDecoration(
                              labelText: '날짜를 입력하세요',
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
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
                        // initialvalue: height,
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
                          } else if (!RegExp(r'^[0-9]*\.?[0-9]+$')
                              .hasMatch(val)) {
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
                        // initialvalue: weight,
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
                          } else if (!RegExp(r'^[0-9]*\.?[0-9]+$')
                              .hasMatch(val)) {
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
                            await ChildRecordAPI.update(
                              widget.childId,
                              ChildRecord(
                                id: widget.recordId,
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
                                      title: const Text('수정 완료'),
                                      content: const Text('수정이 완료되었습니다.'),
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
                        child: const Text('수정하기'),
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
  // required String initialvalue,
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
        // initialValue: initialvalue,
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
