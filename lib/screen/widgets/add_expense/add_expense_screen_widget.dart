import 'package:buraq_enterprise_employee/core/config/extensions/app_colors_extension.dart';
import 'package:buraq_enterprise_employee/core/constants/app_constants.dart';
import 'package:buraq_enterprise_employee/core/constants/app_enum.dart';
import 'package:buraq_enterprise_employee/models/project_model.dart';
import 'package:buraq_enterprise_employee/screen/controllers/add_expense/add_expense_screen_controller.dart';
import 'package:buraq_enterprise_employee/utils/app_helper.dart';
import 'package:buraq_enterprise_employee/utils/app_util.dart';
import 'package:buraq_enterprise_employee/utils/dashed_border_container.dart';
import 'package:buraq_enterprise_employee/utils/widgets/app_card_widget.dart';
import 'package:buraq_enterprise_employee/utils/widgets/app_dropdown_button.dart';
import 'package:buraq_enterprise_employee/utils/widgets/app_scroll_body.dart';
import 'package:buraq_enterprise_employee/utils/widgets/app_text.dart';
import 'package:buraq_enterprise_employee/utils/widgets/app_text_field.dart';
import 'package:buraq_enterprise_employee/utils/widgets/buttons/app_filled_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AddExpenseScreenWidget extends StatelessWidget {
  const AddExpenseScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: AddExpenseScreenController(),
      dispose: (controller) => Get.delete<AddExpenseScreenController>(),
      builder: (controller) {
        if (!controller.isLoading.value && controller.projects.isEmpty) {
          return AppScrollableBody(
            centerContent: true,
            child: AppUtils.noDataFound(
              context: context,
              heading: "No Projects Available",
              subHeading: "You dont have any project to spend on.",
            ),
          );
        }
        return AppScrollableBody(
          centerContent: true,
          child: Skeletonizer(
            enabled: controller.isLoading.value,
            child: Form(
              child: Column(
                children: [
                  AppCardWidget(
                    cardWidget: Column(
                      children: [
                        projectDropDown(controller),
                        SizedBox(height: AppConstants.commonVerticalSpacing),
                        categoryDropDown(controller),
                      ],
                    ),
                  ),
                  SizedBox(height: AppConstants.commonVerticalSpacing),
                  AppCardWidget(
                    cardWidget: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTextHeading(text: "Item Details"),
                        SizedBox(height: AppConstants.commonVerticalSpacing),
                        AppTextField(
                          controller: controller.itemNameController,
                          hintText: "e.g Cement Bags",
                          labelText: "Item Name",
                        ),
                        SizedBox(height: AppConstants.commonVerticalSpacing),
                        Row(
                          children: [
                            Flexible(
                              child: AppTextField(
                                controller: controller.unitPriceController,
                                hintText: "0",
                                labelText: "Unit Price",
                                type: TextFieldType.amount,
                                onTextChangeCallBack: (value) {
                                  controller.calculateTotalCost();
                                },
                              ),
                            ),
                            SizedBox(
                              width: AppConstants.commonHorizontalSpacing,
                            ),
                            Flexible(
                              child: AppTextField(
                                controller: controller.itemQuantityController,
                                hintText: "0",
                                labelText: "Quantity",
                                onTextChangeCallBack: (value) {
                                  controller.calculateTotalCost();
                                },
                                type: TextFieldType.amount,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppConstants.commonVerticalSpacing),
                        totalCostContainer(context, controller),
                      ],
                    ),
                  ),
                  SizedBox(height: AppConstants.commonVerticalSpacing),
                  AppCardWidget(
                    cardWidget: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTextHeading(text: "Recipt"),
                        SizedBox(height: AppConstants.commonVerticalSpacing),
                        buildReceiptUploader(
                          context: context,
                          controller: controller,
                        ),
                        controller.selectedImage != null
                            ? SizedBox(
                                height: AppConstants.commonVerticalSpacing,
                              )
                            : SizedBox.shrink(),
                        controller.selectedImage != null
                            ? AppFilledButton(
                                backgroundeColor: context.appColors.error,
                                buttonText: "Remove Image",
                                onPressedCallBack: ()=> controller.removeImage(),
                              )
                            : SizedBox.shrink(),
                      ],
                    ),
                  ),
                  SizedBox(height: AppConstants.commonVerticalSpacing),
                  AppCardWidget(
                    cardWidget: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTextField(
                          controller: controller.additionalNotesController,
                          hintText: "Additional notes (optional)",
                          labelText: "Additional Notes",
                          maxLines: 4,
                          type: TextFieldType.notes,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppConstants.commonVerticalSpacing),
                  AppFilledButton(
                    onPressedCallBack: () {},
                    buttonText: "Save Expense",
                  ),
                  SizedBox(height: AppConstants.commonVerticalSpacing),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showImageSourceOptions(
    BuildContext context,
    AddExpenseScreenController controller,
  ) {
    double fontSize = 16.0;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: AppTextHeading(text: "Select Image Source"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        content: Column(
          mainAxisSize: MainAxisSize.min, // Constrains the dialog size
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: AppTextHeading(text: "Gallery", fontSize: fontSize),
              onTap: () {
                controller.pickImage(ImageSource.gallery);
                Navigator.pop(context);
              },
            ),
            const Divider(), // Simple line between options
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: AppTextHeading(text: "Camera", fontSize: fontSize),
              onTap: () {
                controller.pickImage(ImageSource.camera);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildReceiptUploader({
    required BuildContext context,
    required AddExpenseScreenController controller,
  }) {
    return CustomPaint(
      painter: DashedBorderContainer(
        color: context.appColors.primary.withValues(
          alpha: 0.75,
        ), // Match the gold-ish tint in your image
        borderRadius: AppConstants.borderRadius,
        dashPattern: [8, 4],
      ),
      child: InkWell(
        onTap: () {
          showImageSourceOptions(context, controller);
        },
        child: Container(
          width: double.infinity,
          height: 130,
          padding: EdgeInsets.all(
            controller.selectedImage == null
                ? AppConstants.padding
                : AppConstants.padding / 2,
          ),
          decoration: BoxDecoration(
            color: context.appColors.primary.withValues(
              alpha: 0.03,
            ), // Dark background
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          child: controller.selectedImage == null
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.grey,
                      size: 48,
                    ),
                    SizedBox(height: 16),
                    AppTextHeading(
                      text: "Take photo or upload receipt",
                      fontSize: 16,
                    ),
                  ],
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(
                    AppConstants.borderRadius - 5,
                  ),
                  child: Image.file(
                    controller.selectedImage!,
                    width: double.infinity,
                    height: 130,
                    fit: BoxFit.cover,
                  ),
                ),
        ),
      ),
    );
  }

  AppDropdownButton categoryDropDown(AddExpenseScreenController controller) {
    return AppDropdownButton(
      label: "Category",
      items: controller.categoryDropdownItems,
      itemLabel: (item) => item.label,
      itemValue: (item) => item.id,          
      valueNotifier: controller.categoryNotifier,
      onChanged: (value) => controller.selectedCategory = value,
      hint: "Select Category",
      enabled: true,
    );
  }

  AppDropdownButton projectDropDown(AddExpenseScreenController controller) {
    return AppDropdownButton<ProjectModel, ProjectModel>(
      label: "Project",
      items: controller.projects,
      valueNotifier: controller.projectNotifier,
      itemLabel: (item) => item.projectName,
      itemValue: (item) => item,
      onChanged: (ProjectModel? value) => controller.selectedProject = value,
      hint: "Select Project",
      enabled: true,
    );
  }

  Container totalCostContainer(
    BuildContext context,
    AddExpenseScreenController controller,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      decoration: BoxDecoration(
        color: context.appColors.primary.withValues(alpha: 0.03),
        border: Border.all(
          color: context.appColors.primary.withValues(alpha: 0.75),
        ),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppTextBody(text: "Total Cost"),
          Obx(
            () => AppTextHeading(
              text: AppHelper.formatPKR(controller.totalCost.toInt()),
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
