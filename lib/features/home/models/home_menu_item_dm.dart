import 'package:flutter/material.dart';

class HomeMenuItemDm {
  final String menuName;
  final IconData icon;
  final Widget? screen;
  final VoidCallback? onTap;
  final List<HomeMenuItemDm>? subMenus;

  HomeMenuItemDm({
    required this.menuName,
    required this.icon,
    this.screen,
    this.onTap,
    this.subMenus,
  });
}
