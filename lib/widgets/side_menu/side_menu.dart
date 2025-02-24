import 'package:ecommerce_admin_tut/widgets/side_menu/side_menu_mobile.dart';
import 'package:ecommerce_admin_tut/widgets/side_menu/side_menu_tablet_desktop.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SideMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: SideMenuMobile(),
      tablet: SideMenuTabletDesktop(),
      desktop: SideMenuTabletDesktop(),
      breakpoints: ScreenBreakpoints(
        tablet: 768,
        desktop: 1200,
        watch: 200, // Adjusted desktop breakpoint
      ),
    );
  }
}
