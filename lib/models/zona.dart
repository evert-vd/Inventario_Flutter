class Zona {
  final int idzona;
  final String descripcion;

  Zona({
    this.idzona,
    this.descripcion
  });

  factory Zona.fromJson(Map<String, dynamic> json){
    return new Zona(
      idzona: json['idzona'] as int,
      descripcion: json['descripcion'],
    );
  }
}

class ZonaList {
  final List<Zona> zonas;

  ZonaList({
    this.zonas,
  });

  factory ZonaList.fromJson(List<dynamic> parsedJson) {
    List<Zona> zonas = new List<Zona>();
    zonas = parsedJson.map((i) => Zona.fromJson(i)).toList();
    return new ZonaList(zonas: zonas);
  }
}