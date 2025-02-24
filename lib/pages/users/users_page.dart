import 'package:flutter/material.dart';
import 'package:responsive_table/responsive_table.dart';
import 'package:ecommerce_admin_tut/widgets/page_header.dart';

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  List<Map<String, dynamic>> _source = []; // Ensure it is not null
  List<Map<String, dynamic>> _selecteds = [];
  String? _sortColumn = "id";
  int _currentPerPage = 10;
  int _currentPage = 1;
  bool _sortAscending = true;
  bool _isLoading = true;
  bool _isSearch = false;

  _initData() async {
    setState(() => _isLoading = true);
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _source = _generateData(n: 100);
        _isLoading = false;
      });
    });
  }

  List<Map<String, dynamic>> _generateData({int n = 100}) {
    return List.generate(
        n,
        (i) => {
              "id": i,
              "name": "User $i",
              "email": "user$i@example.com",
              "role": i % 2 == 0 ? "Admin" : "User"
            });
  }

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          PageHeader(text: 'USERS'),
          Container(
            margin: EdgeInsets.all(10),
            constraints: BoxConstraints(maxHeight: 700),
            child: Card(
              elevation: 1,
              child: _source.isEmpty && !_isLoading
                  ? Center(child: Text("No Data Available"))
                  : ResponsiveDatatable(
                      // Ensure correct import
                      headers: [
                        DatatableHeader(
                          text: "ID",
                          value: "id",
                          show: true,
                          sortable: true,
                          textAlign: TextAlign.center,
                        ),
                        DatatableHeader(
                          text: "Name",
                          value: "name",
                          show: true,
                          sortable: true,
                          flex: 2,
                          textAlign: TextAlign.left,
                        ),
                        DatatableHeader(
                          text: "Email",
                          value: "email",
                          show: true,
                          sortable: false,
                          textAlign: TextAlign.left,
                        ),
                        DatatableHeader(
                          text: "Role",
                          value: "role",
                          show: true,
                          sortable: true,
                          textAlign: TextAlign.left,
                        ),
                      ],
                      source: _source.isNotEmpty ? _source : [],
                      selecteds: _selecteds,
                      showSelect: true,
                      sortAscending: _sortAscending,
                      sortColumn: _sortColumn,
                      isLoading: _isLoading,
                      expanded: List.filled(_source.length, false),

                      onSort: (column) {
                        setState(() {
                          _sortColumn = column;
                          _sortAscending = !_sortAscending;
                          _source.sort((a, b) {
                            var aValue = a[column] as Comparable;
                            var bValue = b[column] as Comparable;
                            return _sortAscending
                                ? aValue.compareTo(bValue)
                                : bValue.compareTo(aValue);
                          });
                        });
                      },
                      onSelect: (value, item) {
                        setState(() {
                          if (value == true) {
                            _selecteds.add(item);
                          } else {
                            _selecteds.remove(item);
                          }
                        });
                      },
                      onSelectAll: (value) {
                        setState(() {
                          _selecteds =
                              (value ?? false) ? List.from(_source) : [];
                        });
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
