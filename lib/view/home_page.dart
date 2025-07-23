import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testt/view/cart_view.dart';
import 'package:testt/view/notifications_view.dart';
import 'package:testt/view/orders_view.dart';
import 'package:testt/view/shipment-view.dart';

import '../controller/home_page_controller.dart';
import '../widgets/custom_bottom_nav_bar.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomePageController());
    final pages = [
      const HomeBody(),
      const OrdersView(),
      const CartView(),
      const NotificationsView(),
    ];
    return Obx(() => Scaffold(
      appBar: AppBar(
        title: Text(controller.titles[controller.selectedIndex.value]),
        backgroundColor: const Color(0xFF334EAC),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF334EAC),
              ),
              child: Text(
                'القائمة الجانبية',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: Text('change_language'.tr),
              onTap: () {
                final currentLocale = Get.locale?.languageCode ?? 'ar';
                final newLocale = currentLocale == 'ar' ? const Locale('en') : const Locale('ar');
                Get.updateLocale(newLocale);
                Get.back();
              },
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: controller.selectedIndex.value,
        children: pages,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: controller.selectedIndex.value,
        onTap: (index) => controller.selectedIndex.value = index,
        onCenterTap: () {
          // Placeholder: show dialog (later will open add order form)
          Get.defaultDialog(
            title: 'طلب شحنة جديدة',
            middleText: 'هل تريد انشاء شحنة ؟؟.',
            textConfirm: 'حسنًا',
            confirmTextColor: Colors.white,
            buttonColor: const Color(0xFF334EAC),
              onConfirm :(){ Get.to(() =>  ShipmentView());}
          );
        },
      ),
    ));
  }
}

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("مرحبًا بك في تطبيق الاستيراد والتصدير!"),
    );
  }
}
