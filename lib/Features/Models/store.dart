import 'package:hive/hive.dart';

part 'store.g.dart';

@HiveType(typeId: 1)
class StoreModel extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  String xpath;
  @HiveField(2)
  String currency;
  @HiveField(3)
  double? percent;

  StoreModel(this.name, this.xpath, this.currency, this.percent);
}
