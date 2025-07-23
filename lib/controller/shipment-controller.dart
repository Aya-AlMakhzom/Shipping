import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testt/model/SupplierModel.dart';
import '../api_service.dart.dart';
import '../model/CategoryModel.dart';
import '../model/ShipmentModel.dart';
import '../view/questions_view.dart';


class ShipmentController extends GetxController {
  int? shipmentId;
  var isLoading = false.obs;
  final categories = <CategoryModel>[].obs;
  var selectedCategory = Rxn<CategoryModel>();
  var shipment = ShipmentModel();
  final serviceType = ''.obs;
  final shippingMethod = ''.obs;
  var isCategoryEmpty = false.obs;
  var isServiceTypeEmpty = false.obs;
  var isShippingMethodEmpty = false.obs;
  var isWeightEmpty = false.obs;
  var isDateEmpty = false.obs;
  var isDestinationEmpty = false.obs;
  var isSupplierFormInvalid = false.obs;

  final useSupplier = false.obs;
  Rx<File?> selectedFile = Rx<File?>(null);

  final supplierNameController = TextEditingController();
  final supplierAddressController = TextEditingController();
  final supplierEmailController = TextEditingController();
  final supplierPhoneController = TextEditingController();
  final containersNumberController = TextEditingController();
  final numberController = TextEditingController();
  final originController = TextEditingController();
  final destinationController = TextEditingController();
  final shippingDateController = TextEditingController();
  final weightController = TextEditingController();
  final containerSizeController = TextEditingController();
  final employeeNotesController = TextEditingController();
  final customerNotesController = TextEditingController();
  final List<String> serviceTypes = ['import', 'export'];
  final List<String> shippingMethods = ['sea', 'air', 'Land'];
  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  bool validateForm() {
    bool isValid = true;

    isCategoryEmpty.value = selectedCategory.value == null;
    isServiceTypeEmpty.value = serviceType.value.isEmpty;
    isShippingMethodEmpty.value = shippingMethod.value.isEmpty;
    isWeightEmpty.value = weightController.text.trim().isEmpty;
    isDateEmpty.value = shippingDateController.text.trim().isEmpty;
    isDestinationEmpty.value = destinationController.text.trim().isEmpty;

    if (isCategoryEmpty.value) {
      Get.snackbar("تنبيه", "يرجى اختيار الفئة");
      isValid = false;
    } else if (isServiceTypeEmpty.value) {
      Get.snackbar("تنبيه", "يرجى اختيار نوع الخدمة");
      isValid = false;
    } else if (isShippingMethodEmpty.value) {
      Get.snackbar("تنبيه", "يرجى اختيار طريقة الشحن");
      isValid = false;
    } else if (isWeightEmpty.value) {
      Get.snackbar("تنبيه", "يرجى إدخال وزن الشحنة");
      isValid = false;
    } else if (isDateEmpty.value) {
      Get.snackbar("تنبيه", "يرجى تحديد تاريخ الشحن");
      isValid = false;
    } else if (isDestinationEmpty.value) {
      Get.snackbar("تنبيه", "يرجى إدخال بلد الوصول");
      isValid = false;
    }
    if (useSupplier.value) {
      if (supplierNameController.text.trim().isEmpty ||
          supplierAddressController.text.trim().isEmpty ||
          supplierEmailController.text.trim().isEmpty ||
          supplierPhoneController.text.trim().isEmpty) {
        Get.snackbar("تنبيه", "يرجى ملء جميع بيانات المعمل");
        isValid = false;
        isSupplierFormInvalid.value = true;
      } else {
        isSupplierFormInvalid.value = false;
      }
    }
    return isValid;
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path != null) {
      selectedFile.value = File(result.files.single.path!);
    }
  }
  void submitShipmentAndSupplier() async {
    if (!validateForm()) return;

    isLoading.value = true;

    try {
      if (useSupplier.value) {
        final supplier = SupplierModel(
          name: supplierNameController.text.trim(),
          address: supplierAddressController.text.trim(),
          contactEmail: supplierEmailController.text.trim(),
          contactPhone: supplierPhoneController.text.trim(),
        );

        final supplierResponse = await ApiService.postSupplier(supplier);

        if (supplierResponse.status == 0) {
          isLoading.value = false;
          Get.snackbar("فشل", supplierResponse.message);
          return;
        }
      }

      if (selectedFile.value != null) {
        // مثال بسيط لإرسال ملف (تحتاج تعديل حسب API الخاص بك)
        // await ApiService.uploadFile(selectedFile.value!, shipmentId!, fixedType: "invoice");
      }
      shipment = ShipmentModel(
        categoryId: selectedCategory.value?.id.toString(),
        number: numberController.text.trim(),
        shippingDate: shippingDateController.text.trim(),
        serviceType: serviceType.value,
        originCountry: originController.text.trim(),
        destinationCountry: destinationController.text.trim(),
        shippingMethod: shippingMethod.value,
        cargoWeight: weightController.text.trim(),
        containersSize: containerSizeController.text.trim(),
        containersNumbers: containersNumberController.text.trim(),
        employeeNotes: employeeNotesController.text.trim(),
        customerNotes: customerNotesController.text.trim(),
      );

      final shipmentResponse = await ApiService.postShipment(shipment);

      if (shipmentResponse['status'] == 1) {
        final shipmentData = shipmentResponse['data']['shipment'];
        shipmentId = shipmentData['id'];
        print("🚚 shipmentId = $shipmentId");
        Get.to(() => QuestionsView(
          categoryId: selectedCategory.value!.id,
          shipmentId: shipmentId!,
        ));
      } else {
        Get.snackbar("فشل", shipmentResponse['message'] ?? "حدث خطأ");
      }
    } catch (e) {
      Get.snackbar("خطأ", "فشل الاتصال بالخادم");
    } finally {
      isLoading.value = false;
    }
  }


  void fetchCategories() async {
    try {
      isLoading.value = true;
      final result = await ApiService.getCategories();
      categories.value = result;
    } catch (e) {
      print("❌ خطأ أثناء جلب الكاتيجوري: $e");
      Get.snackbar("خطأ", "فشل في تحميل الفئات");
    } finally {
      isLoading.value = false;
    }
  }



}
