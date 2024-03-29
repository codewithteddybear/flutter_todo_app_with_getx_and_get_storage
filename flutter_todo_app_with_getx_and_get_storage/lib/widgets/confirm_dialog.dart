import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

Future confirmDialog({
  required String title,
  required String description,
  required PanaraDialogType type,
  required BuildContext context,
  required void Function() onTapConfirm,
}) async {
  return PanaraConfirmDialog.showAnimatedGrow(
    context,
    textColor: Colors.black,
    title: title,
    message: description,
    confirmButtonText: "Confirm",
    cancelButtonText: "Cancel",
    onTapCancel: () => Get.back(),
    onTapConfirm: onTapConfirm,
    panaraDialogType: type,
    barrierDismissible: false,
  );
}
