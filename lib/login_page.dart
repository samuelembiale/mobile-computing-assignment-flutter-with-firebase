import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'list_users.dart';

class LoginPage extends StatefulWidget {


  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

enum FormType{
  login,
  Register
}

  class _LoginPageState extends State<LoginPage>{

  final formKey = new GlobalKey<FormState>();
  final db = Firestore.instance;

  String _fName;
  String _lName;
  String _userName;
  String _mobile;
  String _gender;
  String _email;
  String _password;
  FormType _formType = FormType.login;

  bool validateAndSave(){
    final form = formKey.currentState;
    form.save();
    if(form.validate())
      return true;

      return false;
  }

  void validateAndSubmit() async{
    if(validateAndSave()) {
      try {
        if (_formType == FormType.login){

          AuthResult result = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
        print('signed in : ${result.user.uid}');
          if (result.user.uid != null) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ListPage()),
            );
      }
        }
        else{
          AuthResult result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);
          //print('registerd user: ${user.uid}');
            await db.collection("users").document(_email).setData({'Fname': _fName, 'Lname': _lName, 'user name': _userName,'mobile': _mobile,'Gender': _gender});
          print('registrerd user: ${result.user.uid}');
          if (result.user.uid != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ListPage()),
            );
          }
          else{

          }


        }
    }
      catch(e){
        print('Error: $e');
      }
    }
  }

  void moveToRegister(){
    formKey.currentState.reset();
    setState(() {
        _formType = FormType.Register;
    });

  }

  void moveToLogin(){
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      appBar: new AppBar(
        title: new Text('ሰነድ'),
      ),
        body: new Container(
          padding: EdgeInsets.all(10.0),
          child: new Form(
            key: formKey,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children:
                buildInputs()+buildSubmitButton(),
            ),
          ),
        ),
    );
  }

  List<Widget> buildInputs(){

    if(_formType == FormType.login) {
      return [Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
           _title2(),
          SizedBox(
          height: 0,
        ),
        new TextFormField(
          decoration: new InputDecoration(labelText: 'ኢሜይል',
            border: InputBorder.none,
            fillColor: Color(0xfff3f3f4),
            filled: true,
            contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),),
          validator: (value) => value.isEmpty ? 'እባክዎን ኢሜይል ይሙሉ' : null,
          onSaved: (value) => _email = value,
        ),
            SizedBox(
              height: 10,
            ),
        new TextFormField(
          decoration: new InputDecoration(
            labelText: 'ይለፍ ቃል',
            border: InputBorder.none,
            fillColor: Color(0xfff3f3f4),
            filled: true,
            contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          ),
          obscureText: true,
          validator: (value) =>
          value.isEmpty
              ? 'እባክዎን የይለፍ ቃል ይሙሉ'
              : null,
          onSaved: (value) => _password = value,
        ),
      ],
        ),
    ),];
    }
    else{
      return [
        Container(
            margin: EdgeInsets.symmetric(vertical: 5),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _title(),
            SizedBox(
            height: 0,

        ),
        new TextFormField(
          decoration: new InputDecoration(labelText: 'የመጀመሪያ ስም'),
          validator: (value) => value.isEmpty ? 'እባክዎን የመጀመሪያ ስም ይሙሉ' : null,
          onSaved: (value) => _fName = value,
        ),
        new TextFormField(
          decoration: new InputDecoration(labelText: 'የአያት ሥም'),
          validator: (value) => value.isEmpty ? 'እባክዎን የአያት ሥም ይሙሉ' : null,
          onSaved: (value) => _lName = value,
        ),
        new TextFormField(
          decoration: new InputDecoration(labelText: 'የተጠቃሚ ስም'),
          validator: (value) => value.isEmpty ? 'እባክዎን የአያት ሥም ይሙሉ' : null,
          onSaved: (value) => _userName = value,
        ),
        new TextFormField(
          decoration: new InputDecoration(labelText: 'ኢሜይል'),
          validator: (value) => value.isEmpty ? 'እባክዎን ኢሜይል ይሙሉ' : null,
          onSaved: (value) => _email = value,
        ),
        new TextFormField(
          decoration: new InputDecoration(labelText: 'ስልክ ቁጥር'),
          validator: (value) => value.isEmpty ? 'እባክዎን ስልክ ቁጥር ይሙሉ' : null,
          onSaved: (value) => _mobile = value,
        ),
        new TextFormField(
          decoration: new InputDecoration(labelText: 'ጾታ'),
          validator: (value) => value.isEmpty ? 'እባክዎን ጾታ ይሙሉ' : null,
          onSaved: (value) => _gender = value,
        ),
        new TextFormField(
          decoration: new InputDecoration(labelText: 'የይለፍ ቃል'),
          obscureText: true,
          validator: (value) => value.isEmpty ? 'እባክዎን የይለፍ ቃል ይሙሉ' : null,
          onSaved: (value) => _password = value,
        ),
        ],
    ),
        ),
      ];
    }
  }
  List<Widget> buildSubmitButton(){

    if(_formType == FormType.login) {
      return [
        new RaisedButton(
          child: new Text('ይግቡ', style: new TextStyle(fontSize: 20.0),),
          onPressed: validateAndSubmit,
        ),
        new FlatButton(
          child: new Text(
            'መለያ ይፍጠሩ', style: new TextStyle(fontSize: 20.0),),
          onPressed: moveToRegister,
        )
      ];
    }
    else{
      return [
        new RaisedButton(
          child: new Text('መለያ ይፍጠሩ', style: new TextStyle(fontSize: 20.0),),
          onPressed: validateAndSubmit,
        ),
        new FlatButton(
          child: new Text(
            'መለያ አልዎት? ይግቡ', style: new TextStyle(fontSize: 20.0),),
          onPressed: moveToLogin,
        )
      ];
    }
  }
  Widget _title() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: RichText(
        textAlign: TextAlign.left,
        text: TextSpan(
            text: 'ይመ',
            style: GoogleFonts.portLligatSans(
              textStyle: Theme.of(context).textTheme.display1,
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Color(0xffe46b10),
            ),
            children: [
              TextSpan(
                text: 'ዝ',
                style: TextStyle(color: Colors.black, fontSize: 30),
              ),
              TextSpan(
                text: 'ገቡ',
                style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
              ),
            ]),
      ),
    );
  }
  Widget _title2() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: RichText(
        textAlign: TextAlign.left,
        text: TextSpan(
            text: 'ይ',
            style: GoogleFonts.portLligatSans(
              textStyle: Theme.of(context).textTheme.display1,
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Color(0xffe46b10),
            ),
            children: [
              TextSpan(
                text: 'ግ',
                style: TextStyle(color: Colors.black, fontSize: 30),
              ),
              TextSpan(
                text: 'ቡ',
                style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
              ),
            ]),
      ),
    );
  }

}