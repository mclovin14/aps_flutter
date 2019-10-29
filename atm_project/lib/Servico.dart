import 'dart:io';

import 'package:atm_project/Post.dart';
import 'package:atm_project/Utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';


class Servico extends StatelessWidget {
  Utils token ;


  Servico({Key key, @required this.token}) : super(key: key);

  String _urlBase = "https://funcionarios-tst-api.herokuapp.com";

  Future<List<Post>> _recuperarPostagens() async {
    var teste = parseJwt(token.recuperarToken);
    print(teste);
    http.Response response = await http.get( _urlBase + "/chamados/buscarTodos",
      headers: {'authorization': 'bearer $teste'},);
    var dadosJson = json.decode( response.body );

    List<Post> postagens = List();
    for( var post in dadosJson ){
      Post p = Post(post["id"], post["chamadoDescricao"], post["local"],post["ativo"], post["usuario"]);
      postagens.add( p );
    }
    return postagens;
    //print( postagens.toString() );

  }

 String parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }
    var teste = token;
    String output = token.replaceAll('token', '').replaceAll('{', '').replaceAll('}', '').replaceAll(':', '').replaceAll('"\"', '').replaceAll('\"', '').replaceAll('"', '');
    teste = output;
    return teste;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Ultimos Chamados"),
          backgroundColor: Colors.deepOrangeAccent,
        ),
        body: FutureBuilder<List<Post>>(
          future: _recuperarPostagens(),
          builder: (context, snapshot){

            switch( snapshot.connectionState ){
              case ConnectionState.none :
              case ConnectionState.waiting :
                return Center(
                  child: CircularProgressIndicator(),
                );
                break;
              case ConnectionState.active :
              case ConnectionState.done :
                if( snapshot.hasError ){
                  print("lista: Erro ao carregar ");
                }else {

                  print("lista: carregou!! ");
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index){

                        List<Post> lista = snapshot.data;
                        Post post = lista[index];

                        return ListTile(
                          title: Text( post.chamadoDescricao ),
                          subtitle: Text( post.id.toString() ),
                        );

                      }
                  );

                }
                break;
            }

          },
        ),
      ),

    );
  }
}

