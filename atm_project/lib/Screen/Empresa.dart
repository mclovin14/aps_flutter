import 'package:flutter/material.dart';

class Empresa extends StatefulWidget {
  @override
  _EmpresaState createState() => _EmpresaState();
}

class _EmpresaState extends State<Empresa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Sobre a NMB"),
        backgroundColor: Colors.redAccent,
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.only(bottom: 25, top: 10),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 100),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment:  CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset("imagens/detalhe_empresa.png"),
                  Text(
                    "NMB",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 40),
              child: Container(
                padding: EdgeInsets.all(40),
                child:  Text(
                  "A NMB é uma organização que preza pelo meio ambiente. Acabamos de criar este App para que a pessoas façam chamados caso vejam queimadas. Ao abrir esse chamado, enviaremos uma equipe especializada ao local para sanar o problema. A NMB pede a ajuda e calobaração de todos para que possamos proteger o meio ambiente. Caso se sinta comprometod com a causa, entre em contato conosco. Assim analizaremos o seu histórico e podemos de adicionar aos usuários administradores. Assim você poderá acompanhar os últimos chamados conosco.",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
