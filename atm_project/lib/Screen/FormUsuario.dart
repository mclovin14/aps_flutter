import 'package:atm_project/Screen/AuthLogin.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FormUsuario extends StatefulWidget {
  @override
  _FormUsuarioState createState() => _FormUsuarioState();
}

class _FormUsuarioState extends State<FormUsuario> {
  static var _urlBase = "https://aps-user-api.herokuapp.com";
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _loginController = TextEditingController();
  TextEditingController _senhaController = TextEditingController();

  Future<dynamic> _post(BuildContext context) async {
    var nomeCompleto = _nomeController.text;
    var login = _loginController.text;
    var senha = _senhaController.text;
    var corpo = json
        .encode({"login": login, "nomeCompleto": nomeCompleto, "senha": senha});

    http.Response response = await http.post(_urlBase + "/usuario/cadastrar",
        headers: {"Content-type": "application/json; charset=UTF-8"},
        body: corpo);

    if (response.statusCode == 200) {
      var alertDialog = AlertDialog(
        title: Text("Sucesso!"),
        content: Text("Usuário cadastrado com sucesso!"),
        actions: <Widget>[
          RaisedButton(
            child: Text("Ok"),
            color: Colors.red,
            textColor: Colors.white,
            onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AuthLogin()));
            },
          )
        ],
      );
      showDialog(
          context: context, builder: (BuildContext context) => alertDialog);

    } else {
      var alertDialog = AlertDialog(
        title: Text("Erro!"),
        content: Text("Ocorreu um erro! Tente novamente mais tarde.")
      );
      showDialog(
          context: context, builder: (BuildContext context) => alertDialog);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Cadastro de Usuário"),
        backgroundColor: Colors.redAccent,
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
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Nome completo",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32))),
                    controller: _nomeController,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
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
                        "Cadastrar",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      color: Colors.redAccent,
                      padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)),
                      onPressed: () {
                        _post(context);
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
