import 'package:flutter/material.dart';

class ManagementAppBar extends AppBar {
  ManagementAppBar({required super.title, super.actions, super.key})
    : super(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      );
}

double managementScrollTopPadding(BuildContext context) =>
    MediaQuery.paddingOf(context).top + kToolbarHeight + 8;
