class ShipmentModel {
  int? id;
  String? categoryId;
  String? number;
  String? shippingDate;
  String? serviceType;
  String? originCountry;
  String? destinationCountry;
  String? shippingMethod;
  String? cargoWeight;
  String? containersSize;
  String? containersNumbers;
  String? employeeNotes;
  String? customerNotes;

  ShipmentModel({
    this.id,
    this.categoryId,
    this.number,
    this.shippingDate,
    this.serviceType,
    this.originCountry,
    this.destinationCountry,
    this.shippingMethod,
    this.cargoWeight,
    this.containersSize,
    this.containersNumbers,
    this.employeeNotes,
    this.customerNotes,
  });


  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'category_id': categoryId,
      'shipping_date': shippingDate,
      'service_type': serviceType,
      'origin_country': originCountry,
      'destination_country': destinationCountry,
      'shipping_method': shippingMethod,
      'cargo_weight': cargoWeight,
      'containers_size': containersSize,
      'containers_numbers': containersNumbers,
      'employee_notes': employeeNotes,
      'customer_notes': customerNotes,
    };
  }
}
