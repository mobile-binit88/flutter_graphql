import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/dialog.dart';
import 'package:flutterwithgraphql/firebase/firebase_authentication.dart';
import 'package:flutterwithgraphql/screen/authentication/registration_page.dart';
import 'package:flutterwithgraphql/screen/fetch_employee_detail.dart';
import 'package:flutterwithgraphql/shared_prefs/prefs.dart';

import '../../style.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  TextEditingController mEmailController = TextEditingController();
  TextEditingController mPasswordController = TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  static BuildContext _context;
  bool visible = false;
  bool checkValue = false;

  @override
  void dispose() {
    mEmailController.dispose();
    mPasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getCredential();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: new Text(
          "Login Page",
          style: TextStyle(fontFamily: 'RobotoRegular', fontSize: 22),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
//        physics: const AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Container(
          height: 750,
          child: Column(
            children: <Widget>[
              new SizedBox(
                height: 70,
              ),
              new Align(
                alignment: Alignment.center,
                child: new Text("Firebase Login", style: TitleTextStyle),
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
                          controller: mEmailController,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
//                      hintText: "Enter email",
                            labelText: "Email",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          onChanged: (text) {
                            print(text);
                          },
                        ),
                      ),
                      new SizedBox(
                        height: 20,
                      ),
                      new Container(
                        margin: const EdgeInsets.only(left: 30, right: 30),
                        child: Center(
                          child: new TextFormField(
                            controller: mPasswordController,
                            textInputAction: TextInputAction.done,
                            obscureText: true,
                            decoration: InputDecoration(
//                      hintText: "Enter password",
                                labelText: "Password",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                )),
                          ),
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
                              validationField(context);
                              visible = true;
                              showHideProgress();
                              final email =
                                  mEmailController.text.toString().trim();
                              final password =
                                  mPasswordController.text.toString().trim();
                              visible = true;
                              FirebaseUser result =
                                  await FirebaseBaseAuthentication
                                          .loginAuthentication(email, password)
                                      .then((value) {
                                visible = false;
                                if (value != null) {
                                  visible = false;
                                  showHideProgress();
                                  PreferenceUtils.saveUsername(
                                      mEmailController.text);
                                  PreferenceUtils.savePassword(
                                      mPasswordController.text);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EmployeeDetail()));
                                } else {
                                  visible = false;
                                  showHideProgress();
                                  _showSnackBar("error");
                                  print("error");
                                }
                              });

//                      validationField(context);
                            },
                            child: new Text(
                              "Login",
                              style: TextStyle(
                                  fontSize: 20, fontFamily: 'RobotoRegular'),
                            ),
                            color: Colors.blue,
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                          )),
                      new SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 20),
                        child: new CheckboxListTile(
                          value: checkValue,
                          onChanged: _onChanged,
                          title: new Text(
                            "Remember me",
                            style: TextStyle(fontFamily: 'RobotoRegular'),
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ),
                      new Container(
                          margin: const EdgeInsets.only(right: 30),
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          RegistrationPage()));
                            },
                            child: Text(
                              "Registration",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.blue,
                                  fontFamily: 'RobotoRegular',
                                  decoration: TextDecoration.underline),
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
    if (mEmailController.text.isNotEmpty &&
        mPasswordController.text.isNotEmpty) {
    } else {
      showAlertDialog(context);
    }
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: Text("Login"),
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

  showHideProgress() {
    setState(() {
      visible = visible;
    });
  }

  _onChanged(bool value) async {
    setState(() {
      checkValue = value;
      PreferenceUtils.saveChecked(checkValue);
      PreferenceUtils.saveUsername(mEmailController.text);
      PreferenceUtils.savePassword(mPasswordController.text);
      getCredential();
    });
  }

  getCredential() async {
    setState(() {
      PreferenceUtils.isChecked().then((onValue) {
        setState(() {
          checkValue = onValue;
        });

        if (checkValue) {
          PreferenceUtils.getUsername().then((username) {
            mEmailController.text = username;
          });
          PreferenceUtils.getPassword().then((password) {
            mPasswordController.text = password;
          });
        } else {
          setState(() {
            checkValue = false;
          });

          mEmailController.text = "";
          mPasswordController.text = "";
          PreferenceUtils.clear();
          print("**************elsegetcredential $checkValue");
        }
      });
    });
  }
}
