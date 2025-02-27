import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_admin_tut/provider/products_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // For Timestamp

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  final _nameController =
      TextEditingController(); // Controller for product name
  final _priceController =
      TextEditingController(); // Controller for product price

  @override
  void initState() {
    super.initState();
    // Fetch products when the page is loaded
    Provider.of<ProductsProvider>(context, listen: false).fetchProducts();
  }

  @override
  void dispose() {
    // Dispose the controllers to avoid memory leaks
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Products"),
      ),
      body: productsProvider.products.isEmpty
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : _buildProductList(productsProvider.products),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            _showAddProductDialog(context), // Open add product dialog
        child: Icon(Icons.add),
        tooltip: "Add New Product",
      ),
    );
  }

  Widget _buildProductList(List<Map<String, dynamic>> products) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            title: Text(
              product["name"] ?? "Unknown Product",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4),
                Text(
                  "Price: \$${product["price"]?.toStringAsFixed(2) ?? "0.00"}",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 4),
                Text(
                  "Added: ${product["timestamp"] != null ? (product["timestamp"] as Timestamp).toDate().toString() : "No Date"}",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                // Delete the product
                Provider.of<ProductsProvider>(context, listen: false)
                    .deleteProduct(product["id"]);
              },
            ),
          ),
        );
      },
    );
  }

  void _showAddProductDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add New Product"),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: "Product Name"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a product name";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(labelText: "Product Price"),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a product price";
                    }
                    if (double.tryParse(value) == null) {
                      return "Please enter a valid price";
                    }
                    return null;
                  },
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
                  // Get the name and price from the controllers
                  final name = _nameController.text;
                  final price = double.tryParse(_priceController.text) ?? 0.0;

                  // Add the product to Firestore
                  await Provider.of<ProductsProvider>(context, listen: false)
                      .addProduct(name, price);

                  // Clear the text fields
                  _nameController.clear();
                  _priceController.clear();

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
