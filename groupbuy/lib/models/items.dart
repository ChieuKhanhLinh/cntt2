class Item {
  String id;
  final String name;
  final String detail;
  final String imgLink;
  final int initialprice;
  final int minprice;
  final int totalorder;
  final int ordered;

  Item({
    this.id = '',
    required this.name,
    this.detail = '',
    this.imgLink = '',
    required this.minprice,
    required this.initialprice,
    required this.totalorder,
    this.ordered = 0,
  });

  @override
  String toString() {
    return 'Item(id: $id, name: $name, detail: $detail, imgLink: $imgLink, initialprice: $initialprice, minprice: $minprice, totalorder: $totalorder, ordered: $ordered,)';
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'detail': detail,
      'imgLink': imgLink,
      'minprice': minprice,
      'initialprice': initialprice,
      'totalorder': totalorder,
      'ordered': ordered,
    };
  }

  static Item fromJson(Map<String, dynamic> json) => Item(
        id: json['id'],
        name: json['name'],
        detail: json['detail'],
        imgLink: json['imgLink'],
        minprice: int.parse(json['minprice'].toString()),
        initialprice: int.parse(json['initialprice'].toString()),
        totalorder: int.parse(json['totalorder'].toString()),
        ordered: int.parse(json['ordered'].toString()),
      );
}
