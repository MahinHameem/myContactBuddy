class User {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? image;

  userMap() {
    var mapping = <String, dynamic>{};
    mapping['id'] = id;
    mapping['name'] = name!;
    mapping['email'] = email;
    mapping['phone'] = phone!;
    mapping['image'] = image;
    return mapping;
  }
}
