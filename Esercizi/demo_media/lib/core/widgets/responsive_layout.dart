/// Widget helper per creare layout responsive
library;

import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width >= AppConstants.desktopBreakpoint && desktop != null) {
      return desktop!;
    }
    if (width >= AppConstants.tabletBreakpoint && tablet != null) {
      return tablet!;
    }
    return mobile;
  }
}
