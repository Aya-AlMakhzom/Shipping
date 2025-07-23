
 /* class UserModel {
     int ?id;
    final String firstName;
    final String secondName;
    final String thirdName;
    final String email;
    final String phone;
    final String password;
     String ?token;
     bool isVerified=false;


    UserModel({
      this.id, this.token,required this.isVerified,
      required this.firstName,
      required this.secondName,
      required this.thirdName,
      required this.email,
      required this.phone,
      required this.password,

    });

    Map<String, String> toMap() {
      return {
        'id':id.toString(),
        'first_name': firstName,
        'second_name': secondName,
        'third_name': thirdName,
        'email': email,
        'phone': phone,
        'password': password,
        'token': token.toString(),
      };
    }

     factory UserModel.fromJson(Map<String, dynamic> json) {
       return UserModel(
         id: json['id'],
         firstName : json['first_name'],
         secondName: json['second_name'],
         thirdName: json['third_name'],
         email: json['email'],
         phone: json['phone'],
         password: '',
         isVerified: false,
       );
     }

    void setTOKEN(String token){
      this.token=token;
    }
     void setIsVerified(bool isVerified){
       this.isVerified=isVerified;
     }


  }*/

 class UserModel {
   int? id;
   String firstName;
   String secondName;
   String thirdName;
   String email;
   String? phone; // <-- اجعلها nullable
   String? token;
   bool isVerified = false;
   final String password;


   UserModel({
      this.id,
     required this.firstName,
     required this.secondName,
     required this.thirdName,
     required this.email,
     this.phone,
     this.token,
     required this.password,
     required this.isVerified,
   });

   Map<String, String> toMap() {
     return {
       'id':id.toString(),
       'first_name': firstName,
       'second_name': secondName,
       'third_name': thirdName,
       'email': email,
       'phone': phone ??'',
       'password': password,
       'token': token.toString(),
     };
   }

   factory UserModel.fromJson(Map<String, dynamic> json) {
     return UserModel(
       id: json['id'],
       firstName: json['first_name'] ?? '',
       secondName: json['second_name'] ?? '',
       thirdName: json['third_name'] ?? '',
       email: json['email'] ?? '',
       phone: json['phone'],
       password: '',
       isVerified: false,
     );
   }

   void setTOKEN(String token) {
     this.token = token;
   }

   void setIsVerified(bool value) {
     isVerified = value;
   }
 }

