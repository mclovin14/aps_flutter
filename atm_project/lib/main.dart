import 'dart:developer';
import 'dart:convert';
import 'package:atm_project/Cliente.dart';
import 'package:atm_project/Contato.dart';
import 'package:atm_project/Empresa.dart';
import 'package:atm_project/Servico.dart';
import 'package:atm_project/TLogin.dart';
import 'package:atm_project/Utils.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: TLogin(),
    debugShowCheckedModeBanner: false,
  ));
}
class Home extends StatelessWidget {
  Utils token ;

  Home({Key key, @required this.token}) : super(key: key);

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Cliente() //função anonima curta que instacia a tela secudaria
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
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => new Servico(token: new Utils(token.recuperarToken)) //função anonima curta que instacia a tela secudaria
                      )
                  ),
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

