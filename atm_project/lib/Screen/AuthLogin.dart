import 'package:atm_project/Screen/FormUsuario.dart';
import 'package:atm_project/Screen/Home.dart';
import 'package:atm_project/Util/Utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthLogin extends StatefulWidget {
  @override
  _AuthLoginState createState() => _AuthLoginState();
}

class _AuthLoginState extends State<AuthLogin> {
  String _urlBase = Utils.Urlbase();
  TextEditingController _loginController = TextEditingController();
  TextEditingController _senhaController = TextEditingController();

  _post() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                new CircularProgressIndicator(
                ),
              ],
            ),
          );
        }
    );

    var username = _loginController.text;
    var password = _senhaController.text;
    var corpo = json.encode({"username": username, "password": password});

    http.Response response = await http.post(_urlBase + "/authenticate",
        headers: {"Content-type": "application/json; charset=UTF-8"},
        body: corpo);

    print("resposta: ${response.statusCode}");
    print("resposta: ${response.body}");

    if (response.statusCode == 200) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) =>
              new Home(
                  token: new Utils(response.body) //função anonima curta que instacia a tela secudaria
              )),  (Route<dynamic> route) => false
      );
    } else {
      var alertDialog = AlertDialog(
        title: Text("Erro!"),
        content: Text("Login incorreto!"),
      );
      showDialog(
          context: context, builder: (BuildContext context) => alertDialog);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 32),
                  child: Image.asset(
                    "imagens/nmb.jpg",
                    width: 200,
                    height: 150,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    autofocus: true,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Login",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32))),
                    controller: _loginController,
                  ),
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Senha",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32))),
                  controller: _senhaController,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: RaisedButton(
                      child: Text(
                        "Entrar",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      color: Colors.redAccent,
                      padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)
                      ),
                      onPressed: _post),
                ),
                Center(
                  child: GestureDetector(
                    child: Text(
                        "Não tem conta? cadastre-se!",
                        style: TextStyle(
                            color: Colors.black
                        )
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => new FormUsuario()));
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
