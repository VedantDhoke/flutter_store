import 'package:flutter/material.dart';
import 'package:responsive_table/responsive_table.dart';

class UsersProvider with ChangeNotifier {
  List<Map<String, dynamic>> users = [
    {"id": 1, "name": "John Doe", "email": "john@example.com", "role": "Admin"},
    {
      "id": 2,
      "name": "Jane Smith",
      "email": "jane@example.com",
      "role": "User"
    },
  ];

  List<DatatableHeader> headers = [
    // Change usersTableHeader to headers
    DatatableHeader(
        text: "ID",
        value: "id",
        show: true,
        sortable: true,
        textAlign: TextAlign.center),
    DatatableHeader(
        text: "Name",
        value: "name",
        show: true,
        sortable: true,
        textAlign: TextAlign.left),
    DatatableHeader(
        text: "Email",
        value: "email",
        show: true,
        sortable: false,
        textAlign: TextAlign.left),
    DatatableHeader(
        text: "Role",
        value: "role",
        show: true,
        sortable: true,
        textAlign: TextAlign.left),
  ];
}
