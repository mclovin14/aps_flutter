class Chamado{
  int id;
  String chamadoDescricao;
  String local;
  bool ativo;
  String usuario;
  String imagem;

  Chamado( this.id, this.chamadoDescricao, this.local, this.ativo, this.usuario, this.imagem);

}

class ChamadoDetalhe{
  int id;
  String chamadoDescricao;
  String local;
  bool ativo;
  String usuario;
  String imagem;

  ChamadoDetalhe({this.id, this.chamadoDescricao, this.local, this.ativo, this.usuario, this.imagem});



  factory ChamadoDetalhe.fromJson(Map<String, dynamic> json) {
    return ChamadoDetalhe(
        id: json['id'],
        chamadoDescricao: json['chamadoDescricao'],
        local: json['local'],
        ativo: json['ativo'],
        usuario: json['usuario'],
        imagem: json['imagem']
    );
  }
}