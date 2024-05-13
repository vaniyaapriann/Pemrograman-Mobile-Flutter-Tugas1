class User {
  int? id;
  String? name;
  String? email;

  User({
    this.id,
    this.name,
    this.email,
  });

  //mengkonversi json to object user
  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
  }

//mengkonversi data object user to json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    return data;
  }
}
