class Project {
  String? name;
  String? description;
  String? status;
  int? color;
  String? owner;
  DateTime? createdDt;

  Project(this.name, this.description, this.status, this.color, this.owner,
      this.createdDt);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'status': status,
      'color': color,
      'owner': owner,
      'createdDt': createdDt,
    };
  }

  Project.fromMap(Map<String, dynamic> map) {
    name = map['name'];
    status = map['status'];
    color = map['color'];

    description = map['description'];
    owner = map['owner'];
    createdDt = map['createdDt'];
  }
}
