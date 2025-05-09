import 'package:ecommerce_admin_tut/pages/home/desktop.dart';
import 'package:ecommerce_admin_tut/pages/home/mobile.dart';
import 'package:ecommerce_admin_tut/pages/home/tablet.dart';
import 'package:ecommerce_admin_tut/widgets/size_constraint.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      breakpoints: ScreenBreakpoints(tablet: 768, desktop: 1200, watch: 200),
      mobile: HomePageMobile(),
      tablet: HomePageTablet(),
      desktop: SizeConstraintWidget(child: HomePageDesktop()),
    );
  }
}
