import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_admin_tut/provider/orders_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // For Timestamp

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  final _customerNameController =
      TextEditingController(); // Controller for customer name
  final _totalAmountController =
      TextEditingController(); // Controller for total amount
  String _selectedStatus = "Pending"; // Default status

  @override
  void initState() {
    super.initState();
    // Fetch orders when the page is loaded
    Provider.of<OrdersProvider>(context, listen: false).fetchOrders();
  }

  @override
  void dispose() {
    // Dispose the controllers to avoid memory leaks
    _customerNameController.dispose();
    _totalAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrdersProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Orders"),
      ),
      body: ordersProvider.orders.isEmpty
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : _buildOrderList(ordersProvider.orders),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddOrderDialog(context), // Open add order dialog
        child: Icon(Icons.add),
        tooltip: "Add New Order",
      ),
    );
  }

  Widget _buildOrderList(List<Map<String, dynamic>> orders) {
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            title: Text(
              order["customer_name"] ?? "Unknown Customer",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4),
                Text(
                  "Total Amount: \$${order["total_amount"]?.toStringAsFixed(2) ?? "0.00"}",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 4),
                Text(
                  "Status: ${order["status"] ?? "Pending"}",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 4),
                Text(
                  "Order Date: ${order["order_date"] != null ? (order["order_date"] as Timestamp).toDate().toString() : "No Date"}",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                // Delete the order
                Provider.of<OrdersProvider>(context, listen: false)
                    .deleteOrder(order["id"]);
              },
            ),
          ),
        );
      },
    );
  }

  void _showAddOrderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add New Order"),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _customerNameController,
                  decoration: InputDecoration(labelText: "Customer Name"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a customer name";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _totalAmountController,
                  decoration: InputDecoration(labelText: "Total Amount"),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a total amount";
                    }
                    if (double.tryParse(value) == null) {
                      return "Please enter a valid amount";
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _selectedStatus,
                  items: ["Pending", "Completed", "Cancelled"]
                      .map((status) => DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedStatus = value!;
                    });
                  },
                  decoration: InputDecoration(labelText: "Order Status"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close the dialog
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  // Get the values from the controllers
                  final customerName = _customerNameController.text;
                  final totalAmount =
                      double.tryParse(_totalAmountController.text) ?? 0.0;

                  // Add the order to Firestore
                  await Provider.of<OrdersProvider>(context, listen: false)
                      .addOrder(customerName, totalAmount, _selectedStatus);

                  // Clear the text fields
                  _customerNameController.clear();
                  _totalAmountController.clear();

                  // Close the dialog
                  Navigator.pop(context);
                }
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }
}
