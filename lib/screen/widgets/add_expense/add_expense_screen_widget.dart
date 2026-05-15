import 'dart:io';

import 'package:buraq_enterprise_employee/core/config/extensions/app_colors_extension.dart';
import 'package:buraq_enterprise_employee/core/constants/app_constants.dart';
import 'package:buraq_enterprise_employee/core/constants/app_enum.dart';
import 'package:buraq_enterprise_employee/models/project_model.dart';
import 'package:buraq_enterprise_employee/screen/controllers/add_expense/add_expense_screen_controller.dart';
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
              key: controller.formKey,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                        AppUtils.totalCostContainer(
                          amount: () => controller.totalCost.toInt(),
                          context: context,
                        ),
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
                          validator: (value) {
                            if (value == null) {
                              return "Image is required";
                            }
                            return null;
                          },
                          controller: controller,
                        ),
                        controller.selectedImage.value != null
                            ? SizedBox(
                                height: AppConstants.commonVerticalSpacing,
                              )
                            : SizedBox.shrink(),
                        controller.selectedImage.value != null
                            ? AppFilledButton(
                                backgroundeColor: context.appColors.error,
                                buttonText: "Remove Image",
                                onPressedCallBack: () =>
                                    controller.removeImage(),
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
                    isLoading: controller.isLoading.value,
                    onPressedCallBack: () {
                      if (!controller.formKey.currentState!.validate()){
                        AppUtils.showToast(label: "Please fill all the fields", variant: ToastVariants.error);
                        return;
                      }
                      controller.addExpense();
                    },
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

  Future<void> showImageSourceOptions(
    BuildContext context,
    AddExpenseScreenController controller,
  ) async {
    double fontSize = 16.0;
    await showDialog(
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
    final String? Function(File? value)? validator,
  }) {
    return FormField<File>(
      validator: (_) => validator?.call(controller.selectedImage.value),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (FormFieldState<File> state) {
        final bool hasError = state.hasError;
        final Color color = hasError
            ? context.appColors.error
            : context.appColors.primary;

        return CustomPaint(
          painter: DashedBorderContainer(
            color: color,
            borderRadius: AppConstants.borderRadius,
            dashPattern: [8, 4],
          ),
          child: InkWell(
            onTap: () async {
              await showImageSourceOptions(context, controller);
              // ✅ Only didChange — no controller.update()
              state.didChange(controller.selectedImage.value);
            },
            child: Obx(() {
              // ✅ Obx handles image UI reactively
              final image = controller.selectedImage.value;
              return Container(
                width: double.infinity,
                height: 130,
                padding: EdgeInsets.all(
                  image == null
                      ? AppConstants.padding
                      : AppConstants.padding / 4,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(
                    AppConstants.borderRadius,
                  ),
                ),
                child: image == null
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_alt_outlined,
                            color: hasError
                                ? context.appColors.error
                                : Colors.grey,
                            size: 48,
                          ),
                          SizedBox(height: 16),
                          AppTextHeading(
                            text: "Take photo or upload receipt",
                            color: hasError
                                ? context.appColors.error
                                : context.appColors.text,
                            fontSize: 16,
                          ),
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(
                          AppConstants.borderRadius - 5,
                        ),
                        child: Image.file(
                          image,
                          width: double.infinity,
                          height: 130,
                          fit: BoxFit.cover,
                        ),
                      ),
              );
            }),
          ),
        );
      },
    );
  }

  AppDropdownButton categoryDropDown(AddExpenseScreenController controller) {
    return AppDropdownButton(
      label: "Category",
      items: controller.categoryDropdownItems,
      itemLabel: (item) => item.label,
      itemValue: (item) => item.id,
      valueNotifier: controller.categoryNotifier,
      validator: (value) {
        if (value == null) {
          return "Select the Category";
        }
        return null;
      },
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
      validator: (value) {
        if (value == null) {
          return "Select the Project";
        }
        return null;
      },
      onChanged: (ProjectModel? value) => controller.selectedProject = value,
      hint: "Select Project",
      enabled: true,
    );
  }
}
