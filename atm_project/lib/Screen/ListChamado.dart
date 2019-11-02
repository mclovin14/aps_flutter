import 'dart:io';
import 'package:atm_project/Model/Chamado.dart';
import 'package:atm_project/Screen/DetalheChamado.dart';
import 'package:atm_project/Screen/Home.dart';
import 'package:atm_project/Util/Utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class ListChamado extends StatelessWidget {
  Utils token;

  ListChamado({Key key, @required this.token}) : super(key: key);
  String _urlBase = Utils.Urlbase();

  Future<List<Chamado>> _recuperarPostagens(BuildContext context) async {
    var teste = Utils.parseJwt(token.recuperarToken);
    teste = "Bearer " + teste;
    print(teste);
    http.Response response = await http.get(
      _urlBase + "/chamados/buscarTodos",
      headers: {HttpHeaders.authorizationHeader: teste},
    );
    if(response.statusCode != 200){
      var alertDialog = AlertDialog(
        title: Text("Sucesso!"),
        content: Text(response.body),
        actions: <Widget>[
          RaisedButton(
            child: Text('Ok'),
            color: Colors.red,
            textColor: Colors.white,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Home(token: new Utils(token.recuperarToken))));
            },
          )
        ],
      );
    }
    var dadosJson = json.decode(response.body);

    List<Chamado> postagens = List();
    for (var post in dadosJson) {
      Chamado p = Chamado(post["id"], post["chamadoDescricao"], post["local"],
          post["ativo"], post["usuario"], post["imagem"]);
      postagens.add(p);
    }
    return postagens;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Ultimos Chamados"),
          backgroundColor: Colors.deepOrangeAccent,
        ),
        body: FutureBuilder<List<Chamado>>(
          future: _recuperarPostagens(context),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.redAccent,
                  ),
                );
                break;
              case ConnectionState.active:
              case ConnectionState.done:
                if (snapshot.hasError) {
                } else {
                  print("lista: carregou!! ");
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        List<Chamado> lista = snapshot.data;
                        Chamado post = lista[index];

                        return ListTile(
                          title: Text(post.chamadoDescricao),
                          subtitle: Text(post.id.toString()),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => new DetalheChamado(
                                        token: new Utils(token.recuperarToken),
                                        chamadoId: post.id.toString())));
                          },
                        );
                      });
                }
                break;
            }
          },
        ),
      ),
    );
  }
}
