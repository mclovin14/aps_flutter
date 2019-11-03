import 'dart:io';

import 'package:atm_project/Screen/Contato.dart';
import 'package:atm_project/Screen/Empresa.dart';
import 'package:atm_project/Screen/FormChamado.dart';
import 'package:atm_project/Screen/ListChamado.dart';
import 'package:atm_project/Util/Utils.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Home extends StatelessWidget {
  Utils token ;
  bool temPermissao;
  String _urlBase = Utils.Urlbase();
  Home({Key key, @required this.token, @required this.temPermissao});

  Future<bool>_recuperarCep() async {
    var teste = Utils.parseJwt(token.recuperarToken);
    teste = "Bearer " + teste;
    http.Response response = await http.get(
      _urlBase + "/chamados/usuarioSessao",
      headers: {HttpHeaders.authorizationHeader: teste},
    );

    String permissao = Utils.parseString(response.body);
    temPermissao = permissao.contains("ROLE_ADMIN");
     return temPermissao;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("No More Burns"),
        backgroundColor: Colors.red,
        automaticallyImplyLeading: false,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FormChamado(token: new Utils(token.recuperarToken)) //função anonima curta que instacia a tela secudaria
                        )
                    ),
                    child: Column(
                      children: <Widget>[
                        Icon(
                            Icons.add_call,
                            size: 100,
                            color: Colors.blueAccent
                        ),
                        Text("DENUNCIE",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    )
                ),
                GestureDetector(
                  onTap: () async {
                    bool permissao = (await _recuperarCep());
                    if(permissao){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => new ListChamado(token: new Utils(token.recuperarToken)) //função anonima curta que instacia a tela secudaria
                          )
                      );
                    }else{
                      var alertDialog = AlertDialog(
                        title: Text("Atenção!"),
                        content: Text("Você nao é um membro da NMB para poder ver os últimos chamados. Caso queira se tornar membro, entre em contato conosco pelo menu de contato."),
                        actions: <Widget>[
                          RaisedButton(
                            child: Text('Ok'),
                            color: Colors.red,
                            textColor: Colors.white,
                            onPressed: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      new Home(
                                          token: new Utils(token.recuperarToken) //função anonima curta que instacia a tela secudaria
                                      )),  (Route<dynamic> route) => false
                              );
                            },
                          )
                        ],
                      );
                      showDialog(
                          context: context, builder: (BuildContext context) => alertDialog);
                    }
                  },
                  child: Column(
                    children: <Widget>[
                      Icon(
                        MdiIcons.fire,
                        size: 100,
                        color: Colors.deepOrangeAccent,
                      ),
                      Text("CHAMADOS",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.deepOrangeAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Empresa() //função anonima curta que instacia a tela secudaria
                      )
                  ),
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.account_box,
                          size: 100,
                          color: Colors.redAccent
                      ),
                      Text("NMB",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Contato() //função anonima curta que instacia a tela secudaria
                      )
                  ),
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.markunread,
                          size: 100,
                          color: Colors.green
                      ),
                      Text("CONTATO",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
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

