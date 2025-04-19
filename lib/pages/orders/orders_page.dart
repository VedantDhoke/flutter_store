import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_admin_tut/provider/orders_provider.dart';
import 'package:ecommerce_admin_tut/provider/products_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // For Timestamp

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final _formKey = GlobalKey<FormState>();
  final _customerNameController = TextEditingController();
  final _totalAmountController = TextEditingController();
  String _selectedStatus = "Pending";

  @override
  void initState() {
    super.initState();
    Provider.of<OrdersProvider>(context, listen: false).fetchOrders();
    Provider.of<ProductsProvider>(context, listen: false).fetchProducts();
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _totalAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrdersProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Orders")),
      body: ordersProvider.orders.isEmpty
          ? Center(child: CircularProgressIndicator())
          : _buildOrderList(ordersProvider.orders),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddOrderDialog(context),
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
                    "Total Amount: ₹${order["total_amount"]?.toStringAsFixed(2) ?? "0.00"}"),
                SizedBox(height: 4),
                Text("Status: ${order["status"] ?? "Pending"}"),
                SizedBox(height: 4),
                Text(
                    "Order Date: ${order["order_date"] != null ? (order["order_date"] as Timestamp).toDate().toString() : "No Date"}",
                    style: TextStyle(color: Colors.grey)),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.visibility, color: Colors.blue),
                  tooltip: "View Order",
                  onPressed: () => _showOrderDetailsDialog(context, order),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  tooltip: "Delete Order",
                  onPressed: () => _confirmDeleteOrder(order["id"]),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmDeleteOrder(String orderId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this order?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("No"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context); // Close the dialog first
                await Provider.of<OrdersProvider>(context, listen: false)
                    .deleteOrder(orderId);
                await Provider.of<OrdersProvider>(context, listen: false)
                    .fetchOrders();
                setState(() {});
              },
              child: Text("Yes", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showAddOrderDialog(BuildContext context) {
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    String? _selectedProductId;
    int _orderQuantity = 1;
    double totalAmount = 0.0;
    List<Map<String, dynamic>> _selectedProducts = [];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text("Add New Order"),
            content: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _customerNameController,
                      decoration: InputDecoration(labelText: "Customer Name"),
                      validator: (value) =>
                          value == null || value.isEmpty ? "Enter name" : null,
                    ),
                    DropdownButtonFormField<String>(
                      value: _selectedStatus,
                      decoration: InputDecoration(labelText: "Order Status"),
                      items: ["Pending", "Completed", "Cancelled"]
                          .map((status) => DropdownMenuItem(
                              value: status, child: Text(status)))
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _selectedStatus = value!),
                    ),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: "Select Product"),
                      items: productsProvider.products.map((product) {
                        return DropdownMenuItem<String>(
                          value: product["id"],
                          child: Text(product["name"]),
                        );
                      }).toList(),
                      onChanged: (value) =>
                          setState(() => _selectedProductId = value),
                      validator: (value) =>
                          value == null ? "Please select a product" : null,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: "Quantity"),
                      initialValue: "1",
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return "Enter quantity";
                        if (int.tryParse(value) == null ||
                            int.parse(value) <= 0) return "Invalid quantity";
                        return null;
                      },
                      onChanged: (value) {
                        _orderQuantity = int.tryParse(value) ?? 1;
                      },
                    ),
                    SizedBox(height: 10),
                    ElevatedButton.icon(
                      icon: Icon(Icons.add),
                      label: Text("Add Product to Order"),
                      onPressed: () {
                        if (_selectedProductId == null) return;

                        final selectedProduct = productsProvider.products
                            .firstWhere((p) => p["id"] == _selectedProductId);

                        final productPrice = double.tryParse(
                                selectedProduct["price"].toString()) ??
                            0.0;

                        setState(() {
                          _selectedProducts.add({
                            "product_id": _selectedProductId,
                            "quantity": _orderQuantity,
                          });
                          totalAmount += productPrice * _orderQuantity;
                          _selectedProductId = null;
                          _orderQuantity = 1;
                        });
                      },
                    ),
                    if (_selectedProducts.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Text("Selected Products:"),
                          ..._selectedProducts.map((p) {
                            final prod = productsProvider.products.firstWhere(
                                (prod) => prod["id"] == p["product_id"]);
                            return ListTile(
                              title: Text(prod["name"]),
                              subtitle: Text("Quantity: ${p["quantity"]}"),
                            );
                          }).toList(),
                        ],
                      ),
                    SizedBox(height: 10),
                    Text("Total Amount: ₹${totalAmount.toStringAsFixed(2)}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.green)),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel")),
              TextButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate() &&
                      _selectedProducts.isNotEmpty) {
                    await Provider.of<OrdersProvider>(context, listen: false)
                        .placeMultiProductOrderAndReduceStock(
                      customerName: _customerNameController.text,
                      totalAmount: totalAmount,
                      status: _selectedStatus,
                      products: _selectedProducts,
                    );
                    _customerNameController.clear();
                    Navigator.pop(context);
                  }
                },
                child: Text("Place Order"),
              ),
            ],
          );
        });
      },
    );
  }

  void _showOrderDetailsDialog(
      BuildContext context, Map<String, dynamic> order) {
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    print("Order data in _showOrderDetailsDialog: $order");
    final List<dynamic> orderProducts = order['products'] ?? [];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Order Details"),
          content: orderProducts.isEmpty
              ? Text("No products in this order.")
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: orderProducts.map((productEntry) {
                    final product = productsProvider.products.firstWhere(
                      (prod) => prod['id'] == productEntry['product_id'],
                      orElse: () => {"name": "Unknown Product"},
                    );
                    return ListTile(
                      title: Text(product["name"]),
                      subtitle: Text("Quantity: ${productEntry["quantity"]}"),
                    );
                  }).toList(),
                ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context), child: Text("Close")),
          ],
        );
      },
    );
  }
}
