import 'dart:io';
import 'package:atm_project/FLogin.dart';
import 'package:atm_project/Servico.dart';
import 'package:atm_project/Utils.dart';
import 'package:atm_project/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class TLogin extends StatefulWidget {
  @override
  _TLoginState createState() => _TLoginState();
}

class _TLoginState extends State<TLogin> {
  static var _urlBase = "https://funcionarios-tst-api.herokuapp.com";
  TextEditingController _loginController = TextEditingController();
  TextEditingController _senhaController = TextEditingController();


  _post() async {
    var username = _loginController.text;
    var password = _senhaController.text;
    var corpo = json.encode(
        {"username": username, "password": password }
    );

    http.Response response = await http.post(
        _urlBase + "/authenticate",
        headers: {
          "Content-type": "application/json; charset=UTF-8"
        },
        body: corpo
    );

    print("resposta: ${response.statusCode}");
    print("resposta: ${response.body}");

    if(response.statusCode == 200){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => new Home(token: new Utils(response.body) //função anonima curta que instacia a tela secudaria
          ))
      );
    }else{
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FLogin() //função anonima curta que instacia a tela secudaria
          )
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("No More Burns"),
        backgroundColor: Colors.red,
      ),
      body: Container(
        padding: EdgeInsets.all(32),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              child: Image.asset("imagens/nmb.jpg"),
            ),
            TextField(
              decoration: InputDecoration(labelText: "login"),
              style: TextStyle(fontSize: 22),
              controller: _loginController,
            ),
            TextField(
              decoration: InputDecoration(labelText: "senha"),
              style: TextStyle(fontSize: 22),
              controller: _senhaController,
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10),
                  child: RaisedButton(
                    color: Colors.redAccent,
                    textColor: Colors.white,
                    padding: EdgeInsets.all(15),
                    onPressed: _post,
                    child: Text(
                      "Entrar",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
