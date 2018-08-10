class Producto {
  final int idproducto;
  final int idzona;
  final int idinventario;
  final int codigo;
  final String descripcion;
  final double stock;

  Producto({
    this.idproducto,
    this.idzona,
    this.descripcion,
    this.stock,
    this.idinventario,
    this.codigo
  });

  factory Producto.fromJson(Map<String, dynamic> json){
    return new Producto(
      idproducto: json['idproducto'] as int,
      idzona: json['idzona'] as int,
      idinventario: json['idinventario'] as int,
      codigo: json['codigo'] as int,
      descripcion: json['descripcion'],
      stock: json['stock'] as double,
    );
  }
}


class ProductoList {
  final List<Producto> producto;

  ProductoList({
    this.producto,
  });

  factory ProductoList.fromJson(List<dynamic> parsedJson) {
    List<Producto> productoList = new List<Producto>();
    productoList = parsedJson.map((i) => Producto.fromJson(i)).toList();
    return new ProductoList(producto: productoList);
  }
}