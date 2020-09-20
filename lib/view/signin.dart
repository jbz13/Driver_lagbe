import'package:driver_lagbe/Services/authentication.dart';
import 'package:driver_lagbe/model/userDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  BaseAuth auth = new Auth();
  @override
  State<StatefulWidget> createState() {
    return SignInState();
  }
}

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class SignInState extends State<SignIn> {
  final _formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  String _errorMessage;

  bool _isLoginForm;
  bool _isLoading;

  @override
  void initState() {
    AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
    String _userId = "";
    _errorMessage = "";
    _isLoading = false;
    _isLoginForm = true;

    super.initState();

    _isLoading = true;
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
        }
        authStatus =
        user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
    _isLoading = false;
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Widget showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Email',
            icon: new Icon(
              Icons.mail,
              color: Colors.black,
            )),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Password',
            icon: new Icon(
              Icons.lock,
              color: Colors.black,
            )),
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  void validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (validateAndSave()) {
      String userId = "";
      try {
        if (_isLoginForm) {
          userId = await widget.auth.signIn(_email, _password);
          print('Signed in: $userId');
        } else {
          userId = await widget.auth.signUp(_email, _password);
          //widget.auth.sendEmailVerification();
          //_showVerifyEmailSentDialog();
          print('Signed up user: $userId');
        }
        if (userId.length > 0 && userId != null && _isLoginForm) {
          UserDetails userDetails =
          new UserDetails(auth: widget.auth, userID: userId);
          Navigator.pushReplacementNamed(context, '/home',
              arguments: userDetails);
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          //_formKey.currentState.reset();
        });
      }
    }
  }

  Widget showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 60.0,
          width: 300,
          child: new RaisedButton(
            elevation: 2.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10.0)),
            color: Colors.orange,
            child: new Text('Sign In',
                style: new TextStyle(
                    fontSize: 15.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
            onPressed: validateAndSubmit,
          ),
        ));
  }

  Widget showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? Center(
        child: CupertinoActivityIndicator(
          animating: true,
          radius: 20,
        ),
      )
          : Stack(
        children: <Widget>[
          Positioned(
              top: 0,
              left: 0,
              child: Container(
                color: Colors.orange,
                height: MediaQuery.of(context).size.height * .4,
                width: MediaQuery.of(context).size.width,
                child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          CupertinoIcons.car_detailed,
                          size: 150,
                          color: Colors.white,
                        ),
                        Text(
                          'ড্রাইভার লাগবে?',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
              )),
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * .3,
            left: 0,
            height: MediaQuery.of(context).size.height * .6,
            width: MediaQuery.of(context).size.width,
            child: new SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: new Form(
                  key: _formKey,
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      showEmailInput(),
                      showPasswordInput(),
                      showPrimaryButton(),
                      SizedBox(
                        height: 20,
                      ),
                      showErrorMessage(),
                    ],
                  ),
                )),
          )
        ],
      ),
    );
  }
}