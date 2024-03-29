import 'package:flutter/material.dart';

Future<void> showCustomBottomSheet({
  required Widget widget,
  required BuildContext context,
}) async {
  showModalBottomSheet(
    // used to allow modal bottom sheet to move above the keyboard
    isScrollControlled: true,

    // deny user access to close the bottom sheet manually
    isDismissible: false,
    enableDrag: false,

    backgroundColor: Theme.of(context).primaryColorDark,
    context: context,
    builder: (context) => widget,
  );
}
