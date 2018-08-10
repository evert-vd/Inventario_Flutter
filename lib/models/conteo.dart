class Conteo {
   int idconteo;
   int idproducto;
   int idzona;
   int idinventario;
   double cantidad;
   String fregistro;

  Conteo({
    this.idconteo,
    this.idproducto,
    this.idzona,
    this.cantidad,
    this.idinventario,
    this.fregistro
  });

  factory Conteo.fromJson(Map<String, dynamic> json){
    return new Conteo(
      idconteo: json['idconteo'] as int,
      idproducto: json['idproducto'] as int,
      idzona: json['idzona'] as int,
      idinventario: json['idinventario'] as int,
      cantidad: json['cantidad'] as double,
      fregistro: json['fregistro'],
    );
  }


  Map<String, dynamic> toJson() =>
      {
        'idproducto': idproducto,
        'idzona': idzona,
        'cantidad':cantidad,
        'idinventario':idinventario,
        'fregistro':fregistro,
      };

}


class ConteoList {
  final List<Conteo> conteos;

  ConteoList({
    this.conteos,
  });

  factory ConteoList.fromJson(List<dynamic> parsedJson) {
    List<Conteo> productoList = new List<Conteo>();
    productoList = parsedJson.map((i) => Conteo.fromJson(i)).toList();
    return new ConteoList(conteos: productoList);
  }
}