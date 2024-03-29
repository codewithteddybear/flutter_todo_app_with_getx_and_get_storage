import 'package:flutter/material.dart';

class CustomNavigationBarItem {
  final IconData icon;
  final void Function() onPressed;
  final String tooltip;

  CustomNavigationBarItem({
    required this.icon,
    required this.onPressed,
    required this.tooltip,
  });
}

class CustomNavigationBar extends StatelessWidget {
  final List<CustomNavigationBarItem> items;
  const CustomNavigationBar({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      height: 65,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorDark,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        // navigation bar items
        children: [
          const Spacer(),
          IconButton(
            icon: Icon(items[0].icon),
            onPressed: items[0].onPressed,
            tooltip: items[0].tooltip,
          ),
          const Spacer(),
          IconButton(
            icon: Icon(items[1].icon),
            onPressed: items[1].onPressed,
            tooltip: items[1].tooltip,
          ),
          const Spacer(flex: 3),
          IconButton(
            icon: Icon(items[2].icon),
            onPressed: items[2].onPressed,
            tooltip: items[2].tooltip,
          ),
          const Spacer(),
          IconButton(
            icon: Icon(items[3].icon),
            onPressed: items[3].onPressed,
            tooltip: items[3].tooltip,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
