import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FLogin extends StatelessWidget {
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
            Text("Nao Foi possivel logar no sistema.Contate o administrador.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontStyle: FontStyle.italic,
              color: Colors.black
            ),)
          ],
        ),
      ),
    );
  }
}
