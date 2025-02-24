import 'package:ecommerce_admin_tut/widgets/card_item.dart';
import 'package:ecommerce_admin_tut/widgets/custom_text.dart';
import 'package:ecommerce_admin_tut/widgets/page_header.dart';
import 'package:ecommerce_admin_tut/widgets/sales_chart.dart';
import 'package:ecommerce_admin_tut/widgets/top_buyer.dart';
import 'package:flutter/material.dart';

class HomePageTablet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        PageHeader(
          text: 'DASHBOARD',
        ),

        // Revenue Card
        Padding(
          padding: const EdgeInsets.all(14),
          child: CardItem(
            icon: Icons.monetization_on_outlined,
            title: "Revenue",
            subtitle: "Revenue this month",
            value: "\$ 4,323",
            color1: Colors.green.shade700,
            color2: Colors.green,
          ),
        ),

        // Products Card
        Padding(
          padding: const EdgeInsets.all(14),
          child: CardItem(
            icon: Icons.shopping_basket_outlined,
            title: "Products",
            subtitle: "Total products on store",
            value: "231",
            color1: Colors.lightBlueAccent,
            color2: Colors.blue,
          ),
        ),

        // Orders Card
        Padding(
          padding: const EdgeInsets.all(14),
          child: CardItem(
            icon: Icons.delivery_dining,
            title: "Orders",
            subtitle: "Total orders for this month",
            value: "33",
            color1: Colors.redAccent,
            color2: Colors.red,
          ),
        ),

        // Sales Chart with Constrained Width
        Padding(
          padding: const EdgeInsets.all(14),
          child: Center(
            child: SizedBox(
              height: 400, // Fixed height to prevent overflow
              width:
                  MediaQuery.of(context).size.width * 0.9, // Responsive width
              child: SalesChart(),
            ),
          ),
        ),

        // Top Buyers Section
        Padding(
          padding: const EdgeInsets.all(14),
          child: Center(
            child: Container(
              width:
                  MediaQuery.of(context).size.width * 0.9, // Responsive width
              height: 600,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[300] ?? Colors.grey,
                    offset: Offset(0, 3),
                    blurRadius: 16,
                  )
                ],
              ),
              child: Column(
                children: [
                  CustomText(
                    text: 'Top Buyers',
                    size: 30,
                  ),
                  Expanded(
                    child: ListView(
                      children: List.generate(8, (_) => TopBuyerWidget()),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
