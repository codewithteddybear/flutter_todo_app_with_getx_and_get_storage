import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({
    super.key,
    required this.tooltip,
    required this.onPressed,
  });

  final String tooltip;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      // TODO: make it circle in settings
      // shape: CircleBorder(),
      tooltip: tooltip,
      onPressed: onPressed,
      child: const Icon(
        Iconsax.add,
        size: 28,
        color: Colors.white,
      ),
    );
  }
}
