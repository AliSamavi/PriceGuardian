import 'package:hive/hive.dart';

part 'store.g.dart';

@HiveType(typeId: 1)
class StoreModel extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  String xpathPrice;
  @HiveField(2)
  String xpathDiscount;
  @HiveField(3)
  String xpathPriceBeforeDiscount;
  @HiveField(5)
  String currency;
  @HiveField(6)
  double percent;

  StoreModel(
    this.name,
    this.xpathPrice,
    this.xpathDiscount,
    this.xpathPriceBeforeDiscount,
    this.currency,
    this.percent,
  );
}
