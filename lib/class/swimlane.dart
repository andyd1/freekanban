class Swimlane {
  String? name;
  String? description;
  String? status;
  int? color;
  String? pid;
  DateTime? createdDt;

  Swimlane(this.name, this.description, this.status, this.color, this.pid,
      this.createdDt);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'status': status,
      'color': color,
      'pid': pid,
      'createdDt': createdDt,
    };
  }

  Swimlane.fromMap(Map<String, dynamic> map) {
    name = map['name'];
    status = map['status'];
    color = map['color'];
    description = map['description'];
    pid = map['pid'];
    createdDt = map['createdDt'];
  }
}
