import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as prefix0;
import 'package:atm_project/Model/Chamado.dart';
import 'package:atm_project/Screen/Home.dart';
import 'package:atm_project/Util/Utils.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DetalheChamado extends StatefulWidget {
  Utils token;
  String chamadoId;

  DetalheChamado({Key key, @required this.token, @required this.chamadoId})
      : super(key: key);

  @override
  _DetalheChamadoState createState() => _DetalheChamadoState();
}

class _DetalheChamadoState extends State<DetalheChamado> {
  Image _image;
  String _urlBase = Utils.Urlbase();

  Future<ChamadoDetalhe> _recuperarPostagem() async {
    var teste = Utils.parseJwt(widget.token.recuperarToken);
    var idChamado = int.parse(widget.chamadoId);
    teste = "Bearer " + teste;
    print(teste);
    http.Response response = await http.get(
      _urlBase + "/chamados/buscarChamado/${idChamado}",
      headers: {HttpHeaders.authorizationHeader: teste},
    );
    final dadosJson = json.decode(response.body);
    ChamadoDetalhe p = ChamadoDetalhe.fromJson(dadosJson);

    if (p.imagem != null) {
      _getImage(p.imagem);
    }
    return p;
  }

  Future<dynamic> _put(BuildContext context) async {
    var teste = Utils.parseJwt(widget.token.recuperarToken);
    var idChamado = int.parse(widget.chamadoId);
    teste = "Bearer " + teste;
    http.Response response = await http.put(_urlBase + "/chamados/inativar/${idChamado}",
        headers: {
          HttpHeaders.authorizationHeader: teste,
          "Content-type": "application/json; charset=UTF-8"
        },);

    if (response.statusCode == 200) {
      var alertDialog = AlertDialog(
        title: Text("Sucesso!"),
        content: Text(response.body),
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
                          token: new Utils(widget.token.recuperarToken) //função anonima curta que instacia a tela secudaria
                      )),  (Route<dynamic> route) => false
              );
            },
          )
        ],
      );
      showDialog(
          context: context, builder: (BuildContext context) => alertDialog);
    } else {
      var alertDialog = AlertDialog(
        title: Text("Erro!"),
        content: Text(response.body),
      );
      showDialog(
          context: context, builder: (BuildContext context) => alertDialog);
    }
  }

  _getImage(String base64) async {
    Uint8List _bytesImage;
    _bytesImage = Base64Decoder().convert(base64);
    _image = Image.memory(_bytesImage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("No More Burns"),
        backgroundColor: Colors.red,
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10),
                  child:  FutureBuilder<ChamadoDetalhe>(
                    future: _recuperarPostagem(),
                    builder: (context, snapshot) {
                      // ignore: missing_return
                      ChamadoDetalhe chamado = snapshot.data;
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                          break;
                        case ConnectionState.active:
                        case ConnectionState.done:
                          if (snapshot.hasError) {
                            print("lista: Erro ao carregar ");
                          } else {
                            print("lista: carregou!! ");
                            return Column(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 8),
                                    child:  Text("Descricão: ${chamado.chamadoDescricao}",
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 8),
                                    child:  Text("Localização: ${chamado.local}",
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 8),
                                    child: Text("Usuário da Denúncia: ${chamado.usuario}",
                                      style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                  ),

                                  Center(
                                      child: _image == null
                                          ? null
                                          : _image
                                  ),
                                ]
                            );
                          }
                          break;
                      }
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: RaisedButton(
                      child: Text(
                        "Finalizar Chamado",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      color: Colors.redAccent,
                      padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)),
                      onPressed: () {
                        _put(context);
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
