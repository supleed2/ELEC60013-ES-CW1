import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _email, _password;
  bool _loggingIn = false;

  void attemptLogin(){
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      setState(() { _loggingIn = true; });
      loginUser();
    } else {
      setState(() { _loggingIn = false; });
    }
  }

  Future<void> loginUser() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
      Navigator.pushNamed(context, "/");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid email")));
        setState(() { _loggingIn = false; });
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Incorrect password")));
        setState(() { _loggingIn = false; });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
      validator: (value) => value!.isEmpty ? "Please enter password" : null,
      onSaved: (value) => _password = value!,
    );
    
    final Container loading = Container(
      alignment: Alignment.center,
      child: CircularProgressIndicator(
        backgroundColor: Colors.green,
        color: Colors.green,
      ),
    );

    final Container loginBtn = Container(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
            onPressed: attemptLogin,
            child: Text('Sign In'),
            style: ElevatedButton.styleFrom(
              alignment: Alignment.center,
              primary: Colors.green,
            )
        )
    );

    final Container registerBtn = Container(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
            onPressed: (){ Navigator.pushNamed(context, '/register'); },
            child: Text('No account? Register now!',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15
                )
            ),
            style: ElevatedButton.styleFrom(
              alignment: Alignment.center,
              primary: Colors.white,
              side: BorderSide(
                color: Colors.green,
                width: 2
              )
            )
        )
    );

    return Scaffold(
        appBar: null,
        body: Center(
          child: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child:Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                        children: [
                          emailInput,
                          SizedBox(height: 20),
                          passwordInput,
                          SizedBox(height: 20),
                          _loggingIn ? loading : loginBtn,
                          SizedBox(height: 20),
                          _loggingIn ? Text("") : registerBtn
                        ]
                    )
                )
            ),
          )
      )
    );
  }
}