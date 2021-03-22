import 'package:flutter/material.dart';
import 'package:flutterwithgraphql/graphql_query/graphql_configuration.dart';
import 'package:flutterwithgraphql/graphql_query/query_mutation.dart';
import 'package:flutterwithgraphql/model/employee_model.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class AlertDialogWindow extends StatefulWidget {
  final Employee employee;
  final bool isAdd;
  final bool isDelete;

  AlertDialogWindow({Key key, this.employee, this.isAdd, this.isDelete})
      : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _AlertDialogWindow(this.employee, this.isAdd, this.isDelete);
}

class _AlertDialogWindow extends State<AlertDialogWindow> {
  TextEditingController txtId = TextEditingController();
  TextEditingController txtName = TextEditingController();
  TextEditingController txtDesignation = TextEditingController();
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  QueryMutation addMutation = QueryMutation();

  final Employee employee;
  final bool isAdd;
  final bool isDelete;

  _AlertDialogWindow(this.employee, this.isAdd, this.isDelete);

  @override
  void initState() {
    super.initState();
    if (!this.isAdd) {
      txtId.text = employee.getCompanyId();
      txtName.text = employee.getName();
      txtDesignation.text = employee.getDesignation();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isDelete) {
      return AlertDialog(
        title: Text("Delete Employee"),
        content: Container(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width, maxHeight: 300),
            child: Text("Are you sure want to delete this employee detail?"),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text("Cancel"),
            onPressed: () =>
                Navigator.of(context, rootNavigator: true).pop('dialog'),
          ),
          FlatButton(
            child: Text("Delete"),
            onPressed: () async {
              GraphQLClient _client = graphQLConfiguration.clientToQuery();
              QueryResult result = await _client.mutate(
                MutationOptions(
                  document: addMutation.deleteEmployee(txtId.text),
                ),
              );

              if (result.data != null) {
                Navigator.of(context).pop();
              }
            },
          )
        ],
      );
    } else {
      return AlertDialog(
        title: Text(this.isAdd ? "Add Employee" : "Edit Employee"),
        content: Container(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width, maxHeight: 300),
              child: Stack(
                children: <Widget>[
                  Container(
                    child: TextField(
                      maxLength: 7,
                      controller: txtId,
                      enabled: this.isAdd,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
//                      icon: Icon(Icons.perm_identity),
                        labelText: "ID",
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 80.0),
                    child: TextField(
                      maxLength: 40,
                      controller: txtName,
                      decoration: InputDecoration(
//                      icon: Icon(Icons.text_format),
                        labelText: "Name",
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 160.0),
                    child: TextField(
                      maxLength: 40,
                      controller: txtDesignation,
                      decoration: InputDecoration(
//                      icon: Icon(Icons.text_rotate_vertical),
                        labelText: "Designation",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text("Close"),
            onPressed: () =>
                Navigator.of(context, rootNavigator: true).pop('dialog'),
          ),
          FlatButton(
            child: Text(this.isAdd ? "Add" : "Edit"),
            onPressed: () async {
              if (txtId.text.isNotEmpty &&
                  txtName.text.isNotEmpty &&
                  txtDesignation.text.isNotEmpty) {
                if (this.isAdd) {
                  GraphQLClient _client = graphQLConfiguration.clientToQuery();
                  QueryResult result = await _client.mutate(
                    MutationOptions(
                      document: addMutation.addEmployee(
                          txtId.text, txtName.text, txtDesignation.text),
                    ),
                  );
                  if (result.data != null) {
                    txtId.clear();
                    txtName.clear();
                    txtDesignation.clear();
                    Navigator.of(context).pop();
                  }
                } else {
                  GraphQLClient _client = graphQLConfiguration.clientToQuery();
                  QueryResult result = await _client.mutate(
                    MutationOptions(
                      document: addMutation.editEmployee(
                          txtId.text, txtName.text, txtDesignation.text),
                    ),
                  );
                  if (result.data != null) {
                    txtId.clear();
                    txtName.clear();
                    txtDesignation.clear();
                    Navigator.of(context).pop();
                  }
                }
              }
            },
          )
        ],
      );
    }
  }
}
