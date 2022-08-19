class Card {
  String? name;
  String? description;
  String? status;
  int? color;
  int? storyPoints;
  int? businessValue;
  String? pid;
  DateTime? createdDt;
  DateTime? startDt;
  DateTime? endDt;
  String? priority;
  String? severity;
  List<String>? tags;

  Card(
      this.name,
      this.description,
      this.status,
      this.color,
      this.storyPoints,
      this.businessValue,
      this.pid,
      this.createdDt,
      this.startDt,
      this.endDt,
      this.priority,
      this.severity,
      this.tags);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'status': status,
      'color': color,
      'storyPoints': storyPoints,
      'businessValue': businessValue,
      'pid': pid,
      'createdDt': createdDt,
      'startDt': startDt,
      'endDt': endDt,
      'priority': priority,
      'severity': severity,
      'tags': tags,
    };
  }

  Card.fromMap(Map<String, dynamic> map) {
    name = map['name'];
    status = map['status'];
    color = map['color'];
    description = map['description'];
    pid = map['pid'];
    createdDt = map['createdDt'];
    priority = map['priority'];
    storyPoints = map['storyPoints'];
    businessValue = map['businessValue'];
    priority = map['prioirty'];
    startDt = map['startDt'];
    endDt = map['endDt'];
    severity = map['severity'];
    tags = map['tags'];
  }
}
