import 'dart:convert';

class ChildRecord {
  int id;
  double height;
  double weight;
  DateTime updated;
  ChildRecord(
      {this.id = -1,
      required this.height,
      required this.weight,
      DateTime? updated})
      : updated = updated ?? DateTime.now();
  ChildRecord.fromMap(Map<String, dynamic> json)
      : height = json['height'],
        weight = json['weight'],
        updated = DateTime.parse(json['updated']),
        id = json.containsKey('id') ? json['id'] : -1;
  Map<String, dynamic> toMap() => {
        "height": height,
        "weight": weight,
        "updated": updated.toString(),
        if (id > 0) "id": id
      };
  @override
  String toString() =>
      "ChildRecord(${id != -1 ? 'id: $id, ' : ''}height: $height, weight: $weight, updated: '$updated')";
}

List<ChildRecord> loads(String jsonString) {
  var json = jsonDecode(jsonString);
  List<ChildRecord> result = [];
  for (final item in json) {
    result.add(ChildRecord.fromMap(item));
  }
  result.sort((a, b) => a.updated.compareTo(b.updated));
  return result;
}

String dumps(List<ChildRecord> children) {
  List<Map<String, dynamic>> json = [];
  for (final child in children) {
    json.add(child.toMap());
  }
  return jsonEncode(json);
}

///add
String jsonExample = jsonEncode([
  {"height": 100.0, "weight": 30.0, "updated": "2021-10-01 00:00:00"},
  {"height": 100.0, "weight": 30.0, "updated": "2021-10-01 00:00:00"},
  {"height": 100.0, "weight": 30.0, "updated": "2021-10-01 00:00:00"},
]);

void main() {
  String dump = dumps(loads(jsonExample));
  assert(dump == dumps(loads(dump)));
}
