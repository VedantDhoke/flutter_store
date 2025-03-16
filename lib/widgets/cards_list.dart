import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_admin_tut/provider/dashboard_provider.dart';
import 'card_item.dart';

class CardsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dashboardProvider = Provider.of<DashboardProvider>(context);

    return Container(
      height: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CardItem(
            icon: Icons.monetization_on_outlined,
            title: "Revenue",
            subtitle: "Revenue this month",
            value: "\$ ${dashboardProvider.totalRevenue}", // Dynamic Revenue
            color1: Colors.green.shade700,
            color2: Colors.green,
          ),
          CardItem(
            icon: Icons.shopping_basket_outlined,
            title: "Products",
            subtitle: "Total products on store",
            value:
                "${dashboardProvider.totalProducts}", // Dynamic Product Count
            color1: Colors.lightBlueAccent,
            color2: Colors.blue,
          ),
          CardItem(
            icon: Icons.delivery_dining,
            title: "Orders",
            subtitle: "Total orders for this month",
            value: "${dashboardProvider.totalOrders}", // Dynamic Order Count
            color1: Colors.redAccent,
            color2: Colors.red,
          ),
        ],
      ),
    );
  }
}
