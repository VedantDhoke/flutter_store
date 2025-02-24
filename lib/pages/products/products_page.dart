import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:responsive_table/responsive_table.dart';

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  List<DatatableHeader> _headers = [];
  List<int> _perPages = [5, 10, 15, 100];
  int _total = 0;
  int _currentPerPage = 10;
  int _currentPage = 1;
  bool _isSearch = false;
  List<Map<String, dynamic>> _source = [];
  List<Map<String, dynamic>> _selecteds = [];
  String? _sortColumn;
  bool _sortAscending = true;
  bool _isLoading = true;
  bool _showSelect = true;

  @override
  void initState() {
    super.initState();
    _headers = [
      DatatableHeader(
          text: "ID",
          value: "id",
          show: true,
          sortable: true,
          textAlign: TextAlign.right),
      DatatableHeader(
          text: "Name",
          value: "name",
          show: true,
          flex: 2,
          sortable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "SKU",
          value: "sku",
          show: true,
          sortable: true,
          textAlign: TextAlign.center),
      DatatableHeader(
          text: "Category",
          value: "category",
          show: true,
          sortable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "Price",
          value: "price",
          show: true,
          sortable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "Margin",
          value: "margin",
          show: true,
          sortable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "In Stock",
          value: "in_stock",
          show: true,
          sortable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "Alert",
          value: "alert",
          show: true,
          sortable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "Received",
          value: "received",
          show: true,
          sortable: false,
          sourceBuilder: (value, row) {
            if (value is List && value.length == 2) {
              return Column(
                children: [
                  SizedBox(
                    width: 85,
                    child: LinearProgressIndicator(value: value[0] / value[1]),
                  ),
                  Text("${value[0]} of ${value[1]}")
                ],
              );
            }
            return const Text("Invalid Data");
          },
          textAlign: TextAlign.center),
    ];
    _initData();
  }

  List<Map<String, dynamic>> _generateData({int n = 10}) {
    List<Map<String, dynamic>> temps = [];
    int start = _source.length;
    for (int i = start; i < start + n; i++) {
      temps.add({
        "id": i,
        "sku": "$i-$i",
        "name": "Product $i",
        "category": "Category-$i",
        "price": "${i}0.00",
        "cost": "20.00",
        "margin": "${i}0.20",
        "in_stock": "${i}0",
        "alert": "5",
        "received": [i + 20, 150]
      });
    }
    return temps;
  }

  _initData() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _source.addAll(_generateData(n: 100));
      _total = _source.length;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PRODUCTS')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.7),
              child: Card(
                elevation: 1,
                shadowColor: Colors.black,
                child: ResponsiveDatatable(
                  title: !_isSearch
                      ? ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.add),
                          label: const Text("ADD CATEGORY"))
                      : null,
                  actions: [
                    if (_isSearch)
                      Expanded(
                          child: TextField(
                        decoration: InputDecoration(
                            prefixIcon: IconButton(
                                icon: const Icon(Icons.cancel),
                                onPressed: () {
                                  setState(() {
                                    _isSearch = false;
                                  });
                                }),
                            suffixIcon: IconButton(
                                icon: const Icon(Icons.search),
                                onPressed: () {})),
                      )),
                    if (!_isSearch)
                      IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            setState(() {
                              _isSearch = true;
                            });
                          })
                  ],
                  headers: _headers,
                  source: _source,
                  selecteds: [],
                  showSelect: _showSelect,
                  autoHeight: false,
                  expanded: List.filled(_source.length, false),
                  onSort: (value) {
                    setState(() {
                      _sortColumn = value;
                      _sortAscending = !_sortAscending;
                      _source.sort((a, b) {
                        var aValue = a[value];
                        var bValue = b[value];
                        return _sortAscending
                            ? aValue.toString().compareTo(bValue.toString())
                            : bValue.toString().compareTo(aValue.toString());
                      });
                    });
                  },
                  sortAscending: _sortAscending,
                  sortColumn: _sortColumn,
                  isLoading: _isLoading,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
