import 'dart:convert';


class Child {

  int id;
  String name;  // Sort key
  DateTime birthday;

  String get birthdayString => birthday.toString().substring(0, 10);

  Child({this.id = -1, required this.name, required this.birthday});

  Child.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        birthday = DateTime.parse(json['birthday']),
        id = json.containsKey('id') ? json['id'] : -1;

  Map<String, dynamic> toJson() => {
    "name": name,
    "birthday": birthdayString,
    if (id > 0) "id": id
  };

  @override
  String toString() =>
      "ChildRecord(${id != -1? 'id: $id, ': ''}name: $name, birthday: '$birthdayString')";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Child &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name &&
              birthday == other.birthday;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ birthday.hashCode;

}


List<Child> loads(String jsonString) =>
    jsonDecode(jsonString)
        .map<Child>((e) => Child.fromJson(e))
        .toList()
      ..sort((Child a, Child b) => a.name.compareTo(b.name));


String dumps(List<Child> children) => jsonEncode(children);


// Unit test
void main() {
  var json = """[
  {"name": "Daeseong", "birthday": "2023-01-01"},
  {"name": "Dongha", "birthday": "2023-01-01"}
]""";
  var dump = dumps(loads(json));
  assert (dump == dumps(loads(dump)));
}
