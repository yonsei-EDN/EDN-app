import 'dart:convert';


class ChildRecord {

  int id;
  double height;
  double weight;
  DateTime updated;

  ChildRecord({this.id = -1, required this.height, required this.weight, DateTime? updated})
      : updated = updated ?? DateTime.now();

  ChildRecord.fromJson(Map<String, dynamic> json)
      : height = json['height'],
        weight = json['weight'],
        updated = DateTime.parse(json['updated']),
        id = json.containsKey('id') ? json['id'] : -1;

  Map<String, dynamic> toJson() => {
    "height": height,
    "weight": weight,
    "updated": updated.toString(),
    if (id > 0) "id": id
  };

  @override
  String toString() =>
      "ChildRecord(${id != -1? 'id: $id, ': ''}height: $height, weight: $weight, updated: '$updated')";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ChildRecord &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              height == other.height &&
              weight == other.weight &&
              updated == other.updated;

  @override
  int get hashCode => id.hashCode ^ height.hashCode ^ weight.hashCode ^ updated.hashCode;

}


// for backward compatibility
List<ChildRecord> loads(String jsonString) =>
    jsonDecode(jsonString)
        .map<ChildRecord>((e) => ChildRecord.fromJson(e))
        .toList()
      ..sort((ChildRecord a, ChildRecord b) => a.updated.compareTo(b.updated));


// for backward compatibility
String dumps(List<ChildRecord> children) => jsonEncode(children);


// Unit test
void main() {
  var json = """[
  {"height": 100.0, "weight": 30.0, "updated": "2023-01-01 00:00:00"},
  {"height": 100.0, "weight": 30.0, "updated": "2023-01-01 00:00:00"},
  {"height": 100.0, "weight": 30.0, "updated": "2023-01-01 00:00:00"}
]""";
  var dump = dumps(loads(json));
  assert (dump == dumps(loads(dump)));
}
