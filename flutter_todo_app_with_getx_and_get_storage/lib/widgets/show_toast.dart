import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void showToast({
  required String title,
  required String description,
  required ToastificationType type,
  required ToastificationStyle style,
  required BuildContext context,
}) {
  toastification.show(
    context: context,
    type: type,
    style: style,
    autoCloseDuration: const Duration(seconds: 5),
    title: Text(title),
    description: Text(description),
    alignment: Alignment.topCenter,
    animationDuration: const Duration(milliseconds: 300),
    showProgressBar: false,
  );
}
