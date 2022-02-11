import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:leg_barkr_app/home.dart';
import 'package:leg_barkr_app/utils/endpoints.dart' as Endpoints;

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _firstName, _lastName, _email, _password, _confirmPassword, _deviceId;
  bool _registering = false;

  void attemptRegistration(){
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      if (_password != _confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Passwords do not match")));
        setState(() { _registering = false; });
      }
      form.save();
      setState(() { _registering = true; });
      registerUser();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter all required fields")));
      setState(() { _registering = false; });
    }
  }

  void registerUser() async {
    final response = await http.post(
      Uri.parse(Endpoints.register),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': _firstName + _lastName,
        'deviceid': _deviceId,
        'email': _email,
        'password': _password
      }),
    );
    if (response.statusCode == 201){
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else if (response.statusCode == 400){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Fields missing!")));
    } else if (response.statusCode == 409){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User with given email already exists")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed registration, please try again later")));
    }
    setState(() {
      _registering = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextFormField firstNameInput = TextFormField(
      autofocus: false,
      cursorColor: Colors.green,
      decoration: const InputDecoration(
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.green,
              width: 2
            )
          ),
          hintText: 'First Name',
          //labelStyle: TextStyle(color: Colors.green),
      ),
      validator: (value) => value!.isEmpty ? "Please enter first name" : null,
      onSaved: (value) => _firstName = value!,
    );

    final TextFormField lastNameInput = TextFormField(
      autofocus: false,
      cursorColor: Colors.green,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.green,
                width: 2
            )
        ),
        hintText: 'Last Name',
        //labelStyle: TextStyle(color: Colors.green),
      ),
      validator: (value) => value!.isEmpty ? "Please enter last name" : null,
      onSaved: (value) => _lastName = value!,
    );

    final TextFormField deviceInput = TextFormField(
      autofocus: false,
      cursorColor: Colors.green,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.green,
                width: 2
            )
        ),
        hintText: 'Device ID',
        //labelStyle: TextStyle(color: Colors.green),
      ),
      validator: (value) => value!.isEmpty ? "Please enter device ID" : null,
      onSaved: (value) => _deviceId = value!,
    );

    final TextFormField emailInput = TextFormField(
      autofocus: false,
      cursorColor: Colors.green,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.green,
                width: 2
            )
        ),
        hintText: 'Email',
        //labelStyle: TextStyle(color: Colors.green),
      ),
      validator: (value) => value!.isEmpty ? "Please enter email" : null,
      onSaved: (value) => _email = value!,
    );

    final TextFormField passwordInput = TextFormField(
      autofocus: false,
      obscureText: true,
      cursorColor: Colors.green,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.green,
                width: 2
            )
        ),
        hintText: 'Password',
        //labelStyle: TextStyle(color: Colors.green),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter password';
        }
        return null;
      },
      onSaved: (value) => _password = value!,
    );

    final TextFormField confirmPasswordInput = TextFormField(
      autofocus: false,
      obscureText: true,
      cursorColor: Colors.green,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.green,
                width: 2
            )
        ),
        hintText: 'Confirm password',
        //labelStyle: TextStyle(color: Colors.green),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please confirm password';
        }
        return null;
      },
      onSaved: (value) => _confirmPassword = value!,
    );

    final Container loading = Container(
      alignment: Alignment.center,
      child: CircularProgressIndicator(
          backgroundColor: Colors.green,
          color: Colors.green,
        ),
    );

    final Container registerBtn = Container(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
            onPressed: attemptRegistration,
            child: Text('Register'),
            style: ElevatedButton.styleFrom(
              alignment: Alignment.center,
              primary: Colors.green,
            )
          )

    );

    return SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child:Container(
              padding: EdgeInsets.all(10),
              child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 100),
                      firstNameInput,
                      SizedBox(height: 20),
                      lastNameInput,
                      SizedBox(height: 20),
                      deviceInput,
                      SizedBox(height: 20),
                      emailInput,
                      SizedBox(height: 20),
                      passwordInput,
                      SizedBox(height: 20),
                      confirmPasswordInput,
                      SizedBox(height: 20),
                      _registering ? loading : registerBtn
                    ]
              )
            )
          ),
        )
    );
  }
}