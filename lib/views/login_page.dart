import 'package:flutter/material.dart';

import '../apis/authentication.dart';

class LoginPage extends StatelessWidget{
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(  
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Prihlásenie')
        ),
        body: LoginWidget()
      ); 
  }
}

class LoginWidget extends StatelessWidget{
  
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  LoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    PasswordTextField pwField = PasswordTextField(_passwordController);
    EmailTextField emailField = EmailTextField(_emailController);
    return Column(  
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [ 
            emailField,
            pwField,
            const SizedBox(height: 20),
            LoginButton(_emailController, pwField)
          ],
        );
  }
}

class EmailTextField extends StatelessWidget{

  final TextEditingController _emailController;

  const EmailTextField(this._emailController, {super.key});


  @override
  Widget build(BuildContext context) {
    return TextFormField(  
              controller: _emailController,
              autocorrect: false,
              decoration: const InputDecoration(  
                labelText: 'Email',
                hintText: 'Email',
                prefixIcon: Icon(Icons.email)
              )
            );
  }
}

class PasswordTextField extends StatefulWidget{
  final TextEditingController _passwordController;
  bool _loginFailed = false;
  PasswordTextField(this._passwordController, {super.key});
  


  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
 
  var _isObscured;
  
  @override
  void initState(){
     super.initState();
     _isObscured = true;
  }

  void setLoginState(bool value){
    setState(() {
      widget._loginFailed = value;
    });
  }

  

  @override
  Widget build(BuildContext context) {

    return TextFormField(  
              controller: widget._passwordController,
              obscureText: _isObscured,
              decoration:  InputDecoration(  
                labelText: 'Heslo',
                hintText: 'Heslo',
                prefixIcon: const Icon(Icons.password),
                suffixIcon: IconButton(
                  icon: _isObscured ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _isObscured = !_isObscured;
                   });
                  }, 
                ),
                errorText: widget._loginFailed ? 'Zlý email alebo heslo' : null,
              )
            );
  }
}

class LoginButton extends StatelessWidget{
  AuthAPI login = AuthAPI();
  final TextEditingController emailController;
  final PasswordTextField pwField;

  LoginButton(this.emailController,this.pwField, {super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(  
      onPressed: (() async {
        if(await login.login(emailController.text, pwField._passwordController.text)){
          Navigator.of(context).pushReplacementNamed('/mainPage');
        } else{
          //TO DO: error handling
        }
      }
     ), 
     child:  const Text('Prihlásiť'),
    );
  }

}