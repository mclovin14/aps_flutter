import 'dart:io';
import 'package:atm_project/Screen/Home.dart';
import 'package:atm_project/Util/Utils.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class FormChamado extends StatefulWidget {
  Utils token;

  FormChamado({Key key, @required this.token}) : super(key: key);

  @override
  _FormChamadoState createState() => _FormChamadoState();
}

class _FormChamadoState extends State<FormChamado> {
  File _image;
  static var _urlBase = "https://funcionarios-tst-api.herokuapp.com";
  TextEditingController _chamadoDescricaoController = TextEditingController();
  TextEditingController _localController = TextEditingController();

  TextEditingController _controllerCep = TextEditingController();
  String _resultado;

  _recuperarCep() async {
    String cepDigitado = _controllerCep.text;
    String url = "https://viacep.com.br/ws/${cepDigitado}/json/";
    http.Response response;

    response = await http.get(url);
    Map<String, dynamic> retorno = json.decode(response.body);
    String logradouro = retorno["logradouro"];
    String complemento = retorno["complemento"];
    String bairro = retorno["bairro"];
    String localidade = retorno["localidade"];

    setState(() {
      _resultado = "${logradouro}, ${localidade}, ${bairro} ";
    });

    print(
        "Resposta logradouro: ${logradouro} complemento: ${complemento} bairro: ${bairro} ");
  }

  Future<dynamic> _post(BuildContext context) async {
    String imagem;
    if (_image != null) {
      List<int> imageBytes = _image.readAsBytesSync();
      imagem = base64.encode(imageBytes);
    }
    var teste = Utils.parseJwt(widget.token.recuperarToken);
    teste = "Bearer " + teste;
    var chamadoDescricao = _chamadoDescricaoController.text;
    var local = _localController.text;
    var corpo = json.encode({
      "chamadoDescricao": chamadoDescricao,
      "local": local,
      "imagem": imagem
    });

    http.Response response = await http.post(_urlBase + "/chamados/cadastrar",
        headers: {
          HttpHeaders.authorizationHeader: teste,
          "Content-type": "application/json; charset=UTF-8"
        },
        body: corpo);

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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Home(token: new Utils(widget.token.recuperarToken))));
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

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
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
        color: Colors.white,
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
                        hintText: "Chamado",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32))),
                    controller: _chamadoDescricaoController,
                  ),
                ),
               Padding(
                 padding: EdgeInsets.only(bottom: 8),
                 child:  SizedBox(
                   child: Row(
                     children: <Widget>[
                       Container(
                         width: 263,
                         constraints: BoxConstraints(minWidth: 20.0, minHeight: 0),
                         margin: const EdgeInsets.only(right: 8),
                         child: TextField(
                           keyboardType: TextInputType.text,
                           style: TextStyle(fontSize: 20),
                           decoration: InputDecoration(
                               contentPadding:
                               EdgeInsets.fromLTRB(32, 16, 32, 16),
                               hintText: "Cep",
                               filled: true,
                               fillColor: Colors.white,
                               border: OutlineInputBorder(
                                   borderRadius: BorderRadius.circular(32))),
                           controller: _controllerCep,
                         ),
                       ),
                       FloatingActionButton(
                         heroTag: "cep",
                         backgroundColor: Colors.redAccent,
                         onPressed: () {
                           _recuperarCep();
                           if (_resultado != null) {
                             _localController.text = _resultado;
                           }
                         },
                         tooltip: 'Cep',
                         child: Icon(Icons.archive),
                       ),
                     ],
                   ),
                 ),
               ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Local",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32))),
                    controller: _localController,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(1),
                  color: Colors.redAccent,
                  child: new Center(
                    child:
                        _image == null ? new Text("") : new Image.file(_image),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      FloatingActionButton(
                        heroTag: "foto",
                        backgroundColor: Colors.redAccent,
                        onPressed: getImage,
                        tooltip: 'Pick Image',
                        child: Icon(Icons.add_a_photo),
                      ),
                      RaisedButton(
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
                            if (_controllerCep.text == null) {
                              _recuperarCep();
                            }
                          }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
