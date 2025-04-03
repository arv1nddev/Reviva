class Profile {
  String? uniquePatientId;
  String? name;
  int? age;
  String? sex;
  String? socioeconomicStatus;
  String? residence;
  String? adharNo;
  String? phoneNo;
  double? height;
  double? weight;
  String? bloodGroup;
  String? maritalStatus;
  String? occupation;
  String? religion;

  Profile({
    this.uniquePatientId,
    this.name,
    this.age,
    this.sex,
    this.socioeconomicStatus,
    this.residence,
    this.adharNo,
    this.phoneNo,
    this.height,
    this.weight,
    this.bloodGroup,
    this.maritalStatus,
    this.occupation,
    this.religion,
  });

  // Convert Profile to JSON
  Map<String, dynamic> toJson() {
    return {
      'uniquePatientId': uniquePatientId,
      'name': name,
      'age': age,
      'sex': sex,
      'socioeconomicStatus': socioeconomicStatus,
      'residence': residence,
      'adharNo': adharNo,
      'phoneNo': phoneNo,
      'height': height,
      'weight': weight,
      'bloodGroup': bloodGroup,
      'maritalStatus': maritalStatus,
      'occupation': occupation,
      'religion': religion,
    };
  }

  // Create Profile from JSON
  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      uniquePatientId: json['uniquePatientId'],
      name: json['name'],
      age: json['age'],
      sex: json['sex'],
      socioeconomicStatus: json['socioeconomicStatus'],
      residence: json['residence'],
      adharNo: json['adharNo'],
      phoneNo: json['phoneNo'],
      height: json['height'],
      weight: json['weight'],
      bloodGroup: json['bloodGroup'],
      maritalStatus: json['maritalStatus'],
      occupation: json['occupation'],
      religion: json['religion'],
    );
  }
}