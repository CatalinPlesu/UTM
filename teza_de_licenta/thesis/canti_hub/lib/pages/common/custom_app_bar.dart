import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final IconData? leftIcon;
  final Function()? onLeftIconPressed;
  final IconData? rightIcon;
  final Function()? onRightIconPressed;
  final String? title;

  const CustomAppBar({
    Key? key,
    this.leftIcon,
    this.onLeftIconPressed,
    this.rightIcon,
    this.onRightIconPressed,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leftIcon != null
          ? IconButton(
              icon: Icon(leftIcon),
              onPressed: onLeftIconPressed,
            )
          : null,
      actions: rightIcon != null
          ? [
              IconButton(
                icon: Icon(rightIcon),
                onPressed: onRightIconPressed,
              ),
            ]
          : null,
      title: title != null
          ? Text(
              title!,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )
          : null,
      centerTitle: true,
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
