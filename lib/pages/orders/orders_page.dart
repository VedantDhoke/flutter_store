import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:responsive_table/responsive_table.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
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
          text: "Order ID",
          value: "order_id",
          show: true,
          sortable: true,
          textAlign: TextAlign.right),
      DatatableHeader(
          text: "Customer Name",
          value: "customer_name",
          show: true,
          flex: 2,
          sortable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "Total Amount",
          value: "total_amount",
          show: true,
          sortable: true,
          textAlign: TextAlign.center),
      DatatableHeader(
          text: "Status",
          value: "status",
          show: true,
          sortable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "Order Date",
          value: "order_date",
          show: true,
          sortable: true,
          textAlign: TextAlign.left),
    ];
    _initData();
  }

  List<Map<String, dynamic>> _generateData({int n = 10}) {
    List<Map<String, dynamic>> temps = [];
    int start = _source.length;
    for (int i = start; i < start + n; i++) {
      temps.add({
        "order_id": i + 1000,
        "customer_name": "Customer $i",
        "total_amount": "${i * 50}.00",
        "status": i % 2 == 0 ? "Completed" : "Pending",
        "order_date": "2024-02-${i % 28 + 1}",
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
      appBar: AppBar(title: const Text('ORDERS')),
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
                          label: const Text("ADD ORDER"))
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
