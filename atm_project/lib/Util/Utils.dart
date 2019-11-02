class Utils{
    String recuperarToken;

    static  String Urlbase(){
      return "https://funcionarios-tst-api.herokuapp.com";
    }
    Utils(this.recuperarToken);
   static  String parseJwt(String token) {
        final parts = token.split('.');
        if (parts.length != 3) {
            throw Exception('invalid token');
        }
        var teste = token;
        String output = token
            .replaceAll('token', '')
            .replaceAll('{', '')
            .replaceAll('}', '')
            .replaceAll(':', '')
            .replaceAll('"\"', '')
            .replaceAll('\"', '')
            .replaceAll('"', '');
        teste = output;
        return teste;
    }

    static  String parseString(String token) {
      final parts = token.split('.');
      var teste = token;
      String output = token
          .replaceAll('token', '')
          .replaceAll('{', '')
          .replaceAll('[', '')
          .replaceAll(']', '')
          .replaceAll('}', '')
          .replaceAll(':', '')
          .replaceAll('"\"', '')
          .replaceAll('\"', '')
          .replaceAll('"', '');
      teste = output;
      return teste;
    }
}