import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/dialog.dart';
import 'package:flutterwithgraphql/firebase/firebase_authentication.dart';
import '../../style.dart';
import 'login_page.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<RegistrationPage> {
  final mNameController = TextEditingController();
  final mEmailController = TextEditingController();
  final mPasswordController = TextEditingController();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  static BuildContext _context;
  bool visible = false;

  @override
  void dispose() {
    mNameController.dispose();
    mEmailController.dispose();
    mPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: new Text(
          "Registration Page",
          style: TextStyle(fontFamily: 'RobotoRegular', fontSize: 22),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          height: 1050,
          child: Column(
            children: <Widget>[
              new SizedBox(
                height: 70,
              ),
              new Align(
                alignment: Alignment.center,
                child: new Text(
                  "Registration",
                  style: TitleTextStyle,
                ),
              ),
              new SizedBox(
                height: 30,
              ),
              new Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      new Container(
                        margin: const EdgeInsets.only(left: 30, right: 30),
                        child: new TextFormField(
                          controller: mNameController,
                          decoration: InputDecoration(
                              labelText: "Name",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              )),
                        ),
                      ),
                      new SizedBox(
                        height: 20,
                      ),
                      new Container(
                        margin: const EdgeInsets.only(left: 30, right: 30),
                        child: new TextFormField(
                          controller: mEmailController,
                          decoration: InputDecoration(
                              labelText: "Email",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              )),
                        ),
                      ),
                      new SizedBox(
                        height: 20,
                      ),
                      new Container(
                        margin: const EdgeInsets.only(left: 30, right: 30),
                        child: new TextFormField(
                          controller: mPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                              labelText: "Password",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              )),
                        ),
                      ),
                      new SizedBox(
                        height: 30,
                      ),
                      new SizedBox(
                          width: 350,
                          height: 55,
                          child: new RaisedButton(
                            onPressed: () async {
                              visible = true;
                              showHideProgress();
                              final email =
                                  mEmailController.text.toString().trim();
                              final password =
                                  mPasswordController.text.toString().trim();
                              final name =
                                  mNameController.text.toString().trim();

                              FirebaseBaseAuthentication.registerAuthentication(
                                      email, password, name)
                                  .then((result) {
                                if (result) {
                                  visible = false;
                                  showHideProgress();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage()));
                                } else {
                                  visible = false;
                                  showHideProgress();
                                  print("error");
                                }
                              });
                            },
                            child: new Text(
                              "Registration",
                              style: TextStyle(fontSize: 20),
                            ),
                            color: Colors.blue,
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                          )),
                    ],
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
              )
            ],
          ),
        ),
      ),
    );
  }

  validationField(BuildContext context) {
    if (mNameController.text.isEmpty &&
        mEmailController.text.isEmpty &&
        mPasswordController.text.isEmpty) {
      showAlertDialog(context);
    }
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: Text("Registration"),
      content: Text("Field should not be empty!!!"),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        _context = context;
        return alert;
      },
    );
  }

  Widget okButton = FlatButton(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
    child: Text("OK"),
    onPressed: () {
      Navigator.of(_context).pop();
    },
  );

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  @override
  void onLoginError(String errorTxt) {
    print(errorTxt);
    _showSnackBar(errorTxt);
  }

  showHideProgress() {
    setState(() {
      visible = visible;
    });
  }
}
