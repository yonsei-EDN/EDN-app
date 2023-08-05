import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kidscan_app/api/child_record_api.dart';
import 'package:kidscan_app/models/child_record.dart';
import 'package:kidscan_app/pages/add_record.dart';
import 'package:kidscan_app/pages/record_modify.dart';

class ShowRecordList extends StatefulWidget {
  const ShowRecordList({super.key, required this.childId});
  final int childId;

  @override
  State<ShowRecordList> createState() => _ShowRecordListState();
}

class _ShowRecordListState extends State<ShowRecordList> {
  late final int childId;
  bool loading = true;
  late List<ChildRecord> childRecords;
  late int len = 0;
  Future<void> loadRecord() async {
    childRecords = await ChildRecordAPI.list(childId);
    setState(() {
      len = childRecords.length;
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    childId = widget.childId;
    loadRecord();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Center(child: CircularProgressIndicator())
        : Center(
            child: SizedBox(
              width: 300,
              child: ListView.builder(
                itemCount: len + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Container(
                      height: 25,
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddRecord(childId),
                            ),
                          );
                          setState(() {
                            loading = true;
                          });
                          loadRecord();
                        },
                        focusColor: Colors.red,
                        selectedIcon: const Icon(Icons.add_chart),
                      ),
                    );
                  }
                  final int tmpId = childRecords.elementAt(index - 1).id;
                  return Slidable(
                    //TODO: 삭제 버튼 디자인 조정
                    endActionPane: ActionPane(
                      motion: const StretchMotion(),
                      children: [
                        SlidableAction(
                          backgroundColor: Colors.red,
                          icon: Icons.delete,
                          onPressed: (context) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('삭제'),
                                  content: const Text('정말로 삭제하시겠습니까?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        await ChildRecordAPI.delete(
                                          childId,
                                          tmpId,
                                        );
                                        setState(() {
                                          loading = true;
                                        });
                                        loadRecord();
                                        if (mounted) Navigator.pop(context);
                                      },
                                      child: const Text('예'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('아니오'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        )
                      ],
                    ),
                    child: Container(
                      color: Colors.grey[300],
                      child: ListTile(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  RecordModify(childId, tmpId),
                            ),
                          );
                          //원래 페이지로 돌아왔을 때 수정된 버전이 되도록 창 리로드
                          setState(() {
                            loading = true;
                          });
                          loadRecord();
                        },
                        title: Text(
                          //TODO: 키, 몸무게 텍스트 추가
                          childRecords
                              .elementAt(index - 1)
                              .updated
                              .toString()
                              .substring(0, 10),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
  }
}
