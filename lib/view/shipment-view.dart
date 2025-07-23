import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testt/widgets/custom_text_field.dart';
import '../controller/shipment-controller.dart';
import '../model/CategoryModel.dart';
import '../widgets/custom_date_field.dart';
import '../widgets/custom_dropdown_form_field.dart';
import '../widgets/file_picker_widget.dart';

class ShipmentView extends StatelessWidget {
  const ShipmentView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ShipmentController());
    File? _selectedFile;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF334EAC),
        title: const Text("بيانات الشحنة"),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    "assets/images/Bill-of-LP-Image-1.webp",
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "إرسال شحنة جديدة",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "يرجى تعبئة بيانات الشحنة بدقة",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),

                Obx(() => CustomDropdownFormField<CategoryModel>(
                  label: "الفئة",
                  value: controller.selectedCategory.value,
                  items: controller.categories,
                  getLabel: (cat) => cat.name,
                  onChanged: (cat) => controller.selectedCategory.value = cat,
                  isError: controller.isCategoryEmpty.value,
                )),

                const SizedBox(height: 16),

                Obx(() => CustomDropdownFormField<String>(
                  label: "نوع الخدمة",
                  value: controller.serviceType.value.isEmpty ? null : controller.serviceType.value,
                  items: controller.serviceTypes,
                  getLabel: (type) => type == 'import' ? 'استيراد' : 'تصدير',
                  onChanged: (val) => controller.serviceType.value = val ?? '',
                  getIcon: (type) => type == 'import' ? Icons.call_received : Icons.call_made,
                  isError: controller.isServiceTypeEmpty.value,
                )),
                const SizedBox(height: 16),
                // طريقة الشحن
                Obx(() => CustomDropdownFormField<String>(
                  label: "طريقة الشحن",
                  value: controller.shippingMethod.value.isEmpty ? null : controller.shippingMethod.value,
                  items: controller.shippingMethods,
                  getLabel: (method) =>
                  method == 'sea' ? 'بحري' :
                  method == 'air' ? 'جوي' :
                  'بري',
                  onChanged: (val) => controller.shippingMethod.value = val ?? '',
                  getIcon: (method) => method == 'sea' ? Icons.sailing : method == 'air' ? Icons.flight : Icons.local_shipping,
                )),
                const SizedBox(height: 16),
                // باقي الحقول مع تحسين الشكل
                CustomTextField(label: "بلد المنشأ",controller:  controller.originController,keyboardType:  TextInputType.text),
                CustomTextField(label: "بلد الوصول",controller:  controller.destinationController,keyboardType:  TextInputType.text,isError: controller.isDestinationEmpty.value,),
                CustomDateField(
                  label: "تاريخ الشحن",
                  controller: controller.shippingDateController,
                  isError: controller.isDateEmpty.value,
                ),
                CustomTextField(label: "وزن الشحنة (كغ)",controller:  controller.weightController,keyboardType:  TextInputType.number,isError: controller.isWeightEmpty.value,),
                CustomTextField(label: "حجم الحاوية",controller:  controller.containerSizeController,keyboardType:  TextInputType.number),
                CustomTextField(label: "عدد الحاويات",controller:  controller.containersNumberController,keyboardType:  TextInputType.number),
                CustomTextField(label: "ملاحظات الموظف",controller:  controller.employeeNotesController,keyboardType:  TextInputType.text, maxLines: 2),
                CustomTextField(label: "ملاحظات العميل",controller:  controller.customerNotesController,keyboardType:  TextInputType.text, maxLines: 2),
                Obx(() => SwitchListTile(
                  title: const Text("هل تم التعامل مع معمل سابقاً؟",style: TextStyle(color: Colors.blueGrey),),
                  value: controller.useSupplier.value,
                  onChanged: (val) => controller.useSupplier.value = val,
                  activeColor: Color(0xFF334EAC),
                )),

                Obx(() {
                  if (!controller.useSupplier.value) return const SizedBox.shrink();

                  return Column(
                    children: [
                      const SizedBox(height: 16),
                      const Text(
                        "بيانات المعمل",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),

                      CustomTextField(label: "اسم المعمل", controller:controller.supplierNameController,keyboardType: TextInputType.text),
                      CustomTextField(label: "عنوان المعمل",controller:  controller.supplierAddressController,keyboardType:  TextInputType.text),
                      CustomTextField(label: "البريد الإلكتروني",controller:  controller.supplierEmailController,keyboardType:  TextInputType.emailAddress),
                      CustomTextField(label: "رقم التواصل", controller:controller.supplierPhoneController,keyboardType:  TextInputType.phone),
                    ],
                  );
                }),
                const SizedBox(height: 24),
                FilePickerWidget(controller: controller),
                controller.isLoading.value
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: controller.submitShipmentAndSupplier,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF334EAC),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "إرسال الشحنة",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
              ],
            ),
          ),
        );
      }),
    );
  }



}
