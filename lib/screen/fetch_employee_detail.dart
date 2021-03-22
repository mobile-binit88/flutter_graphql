import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterwithgraphql/config/network_configuration.dart';
import 'package:flutterwithgraphql/dialog/alert_dialog.dart';
import 'package:flutterwithgraphql/graphql_query/query_mutation.dart';
import 'package:flutterwithgraphql/model/employee_model.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../graphql_query/graphql_configuration.dart';

class EmployeeDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
    return GraphQLProvider(
      client: graphQLConfiguration.client,
      child: CacheProvider(child: FetchEmployeeDetail()),
    );
  }
}

class FetchEmployeeDetail extends StatefulWidget {
  @override
  _FetchEmployeeDetailState createState() => _FetchEmployeeDetailState();
}

class _FetchEmployeeDetailState extends State<FetchEmployeeDetail> {
  List<Employee> listEmployee = List<Employee>();
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  bool visible = false;

  Future<List<Employee>> fillList() async {
    NetworkConfig.check().then((intenet) async {
      QueryMutation queryMutation = QueryMutation();
      GraphQLClient _client = graphQLConfiguration.clientToQuery();
      QueryResult result = await _client.query(
        QueryOptions(
          document: queryMutation.getAll(),
        ),
      );
      if (result.data != null) {
        for (var i = 0; i < result.data["employee"].length; i++) {
          setState(() {
            listEmployee.add(
              Employee(
                result.data["employee"][i]["company_id"],
                result.data["employee"][i]["name"],
                result.data["employee"][i]["designation"],
              ),
            );
          });
        }
        return listEmployee;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fillList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (listEmployee.isEmpty) {
      visible = true;
      showHideProgress();
    } else {
      visible = false;
      showHideProgress();
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "List of Employee",
            style: TextStyle(
                fontSize: 22, color: Colors.white, fontFamily: 'RobotoRegular'),
          ),
          centerTitle: true,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              exit(0);
            },
          ),
          backgroundColor: Colors.blue.withOpacity(.8),
        ),
        body: Stack(
          children: <Widget>[
//            Container(
//              width: MediaQuery.of(context).size.width,
//              child: Text(
//                "Employee",
//                textAlign: TextAlign.center,
//                style: TextStyle(fontSize: 30.0),
//              ),
//            ),
            Container(
              padding: EdgeInsets.only(top: 10.0),
              child: ListView.builder(
                itemCount: listEmployee.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.blue.withOpacity(.3),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        selected: listEmployee == null ? false : true,
                        title: Text(
                          "${listEmployee[index].getName()}",
                          style: TextStyle(
                              fontSize: 22,
                              color: Colors.black,
                              fontFamily: 'RobotoRegular'),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Text(
                            "${listEmployee[index].getDesignation()}",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black45,
                                fontFamily: 'RobotoMedium'),
                          ),
                        ),
                        trailing: Container(
                          width: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              IconButton(
                                color: Colors.white,
                                icon: Icon(Icons.edit),
                                onPressed: () => _editDeleteEmployee(
                                    context, listEmployee[index]),
                              ),
                              IconButton(
                                color: Colors.red.withOpacity(.7),
                                icon: Icon(Icons.delete),
                                onPressed: () => _deleteEmployee(
                                    context, listEmployee[index]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Center(
              child: Visibility(
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  visible: visible,
                  child: Container(child: CircularProgressIndicator())),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _insertEmployeeDetail(context),
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  void _insertEmployeeDetail(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        AlertDialogWindow alertDialogWindow =
            new AlertDialogWindow(isAdd: true, isDelete: false);
        return alertDialogWindow;
      },
    ).whenComplete(() {
      listEmployee.clear();
      fillList();
    });
  }

  void _editDeleteEmployee(context, Employee employee) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        AlertDialogWindow alertDialogWindow = new AlertDialogWindow(
          isAdd: false,
          employee: employee,
          isDelete: false,
        );
        return alertDialogWindow;
      },
    ).whenComplete(() {
      listEmployee.clear();
      fillList();
    });
  }

  void _deleteEmployee(context, Employee employee) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        AlertDialogWindow alertDialogWindow = new AlertDialogWindow(
          isAdd: false,
          employee: employee,
          isDelete: true,
        );
        return alertDialogWindow;
      },
    ).whenComplete(() {
      listEmployee.clear();
      fillList();
    });
  }

  showHideProgress() {
    setState(() {
      visible = visible;
    });
  }

  showAlertDialog() {
    AlertDialog alert = AlertDialog(
      title: Text("Internet"),
      content: Text("Please check your network connection!!!"),
      actions: [
        FlatButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: Text("OK"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        context = context;
        return alert;
      },
    );
  }
}
