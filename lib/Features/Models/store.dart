import 'package:hive/hive.dart';

part 'store.g.dart';

@HiveType(typeId: 1)
class StoreModel extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  String xpathPrice;
  @HiveField(2)
  String? xpathDiscounted;
  @HiveField(3)
  String currency;
  @HiveField(4)
  double? percent;

  StoreModel(this.name, this.xpathPrice, this.xpathDiscounted, this.currency,
      this.percent);
}
