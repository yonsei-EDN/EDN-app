import 'dart:convert';

List<Child> childFromJson(String str) =>
    List<Child>.from(json.decode(str).map((x) => Child.fromJson(x)));

String childToJson(List<Child> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Child {
  int id;
  DateTime birhtday;
  List<Record> record;

  Child({
    required this.id,
    required this.birhtday,
    required this.record,
  });

  factory Child.fromJson(Map<String, dynamic> json) => Child(
        id: json["id"],
        birhtday: DateTime.parse(json["birhtday"]),
        record:
            List<Record>.from(json["record"].map((x) => Record.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "birhtday": birhtday.toIso8601String(),
        "record": List<dynamic>.from(record.map((x) => x.toJson())),
      };
}

class Record {
  double height;
  double weight;
  DateTime updated;

  Record({
    required this.height,
    required this.weight,
    required this.updated,
  });

  factory Record.fromJson(Map<String, dynamic> json) => Record(
        height: json["height"],
        weight: json["weight"],
        updated: DateTime.parse(json["updated"]),
      );

  Map<String, dynamic> toJson() => {
        "height": height,
        "weight": weight,
        "updated": updated.toIso8601String(),
      };
}
