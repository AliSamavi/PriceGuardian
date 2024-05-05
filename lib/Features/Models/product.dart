import 'package:hive/hive.dart';

part 'product.g.dart';

@HiveType(typeId: 2)
class ProductModel {
  @HiveField(0)
  int store;
  @HiveField(1)
  int id;
  @HiveField(2)
  String name;
  @HiveField(3)
  String url;

  ProductModel(this.store, this.id, this.name, this.url);
}
