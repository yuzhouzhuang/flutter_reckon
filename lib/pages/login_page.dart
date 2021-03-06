import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterApp/blocs/blocs.dart';
import 'package:flutterApp/pages/pages.dart';
import 'package:flutterApp/theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/LoginPage';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneNumberController = TextEditingController();

  AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    _authBloc = BlocProvider.of<AuthBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthStateCodeSent) {
          Navigator.of(context).pushNamed(OtpPage.routeName);
        }
        if (state is AuthStateAuthenticated) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: Stack(
                              children: <Widget>[
                                Center(
                                  child: Container(
                                    height: 200,
                                    constraints:
                                        const BoxConstraints(maxWidth: 500),
                                    margin: const EdgeInsets.only(top: 100),
                                    decoration: const BoxDecoration(
                                        color: MyColors.primaryColorLight,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30))),
                                  ),
                                ),
//                                Center(
//                                  child: Container(
//                                      constraints: const BoxConstraints(
//                                          maxHeight: 340),
//                                      margin: const EdgeInsets.symmetric(
//                                          horizontal: 8),
//                                      child: Image.asset(
//                                          'assets/img/login.png')),
//                                ),
                              ],
                            ),
                          ),
                          Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text('Reckoning App',
                                  style: TextStyle(
                                      color: MyColors.primaryColor,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w800)))
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: <Widget>[
                          Container(
                              constraints: const BoxConstraints(maxWidth: 500),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(children: <TextSpan>[
                                  TextSpan(
                                      text: 'We will send you an ',
                                      style: TextStyle(
                                          color: MyColors.primaryColor)),
                                  TextSpan(
                                      text: 'One Time Password ',
                                      style: TextStyle(
                                          color: MyColors.primaryColor,
                                          fontWeight: FontWeight.bold)),
                                ]),
                              )),
                          Container(
                            height: 40,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: CupertinoColors.lightBackgroundGray),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                            ),
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0, top: 0),
                                  child: Text('+44'),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: CupertinoTextField(
                                      decoration: BoxDecoration(
                                        color: Colors.white
                                      ),
                                      controller: _phoneNumberController,
                                      clearButtonMode:
                                          OverlayVisibilityMode.editing,
                                      keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                                      maxLines: 1,
                                      placeholder: 'Mobile number',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20,),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            constraints: const BoxConstraints(maxWidth: 500),
                            child: RaisedButton(
                              onPressed: () {
                                if (_phoneNumberController.text.isNotEmpty) {
                                  _authBloc.add(AuthEventSendCode(
                                      phoneNumber: _phoneNumberController.text
                                          .toString()));
                                } else {
                                  Scaffold.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(SnackBar(
                                      content: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text('Please enter phone number'),
                                          Icon(Icons.error),
                                        ],
                                      ),
                                      backgroundColor: Colors.red,
                                    ));
                                }
                              },
                              color: MyColors.primaryColor,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(14))),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      'Next',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20)),
                                        color: MyColors.primaryColorLight,
                                      ),
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
