class SupplierModel {
  final int? id;
  final int? userId;
  final String name;
  final String address;
  final String contactEmail;
  final String contactPhone;

  SupplierModel({
    this.id,
    this.userId,
    required this.name,
    required this.address,
    required this.contactEmail,
    required this.contactPhone,
  });

  factory SupplierModel.fromJson(Map<String, dynamic> json) {
    return SupplierModel(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      contactEmail: json['contact_email'] ?? '',
      contactPhone: json['contact_phone'] ?? '',
    );
  }

  Map<String, String> toFormData() {
    return {
      'name': name,
      'address': address,
      'contact_email': contactEmail,
      'contact_phone': contactPhone,
    };
  }
}

class ApiResponse<T> {
  final int status;
  final T? data;
  final String message;

  ApiResponse({
    required this.status,
    this.data,
    required this.message,
  });

  factory ApiResponse.fromJson(
      Map<String, dynamic> json,
      T Function(dynamic) fromJsonData,
      ) {
    return ApiResponse(
      status: json['status'] ?? 0,
      data: json['status'] == 1 ? fromJsonData(json['data']) : null,
      message: json['message'] ?? '',
    );
  }
}

