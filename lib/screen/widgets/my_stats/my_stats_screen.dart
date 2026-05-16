

import 'package:buraq_enterprise_employee/screen/controllers/my_stats/my_stats_screen_controller.dart';


import 'package:buraq_enterprise_employee/utils/widgets/app_scroll_body.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyStatsScreenWidget extends StatelessWidget {
  const MyStatsScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyStatsScreenController>(
      init: MyStatsScreenController(),
      dispose: (controller) => Get.delete<MyStatsScreenController>(),
      builder: (controller) {
        return AppScrollableBody(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [],
          ),
        );
      },
    );
  }
}
