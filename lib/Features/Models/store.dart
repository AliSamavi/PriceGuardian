import 'package:hive/hive.dart';

part 'store.g.dart';

@HiveType(typeId: 1)
class StoreModel extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  String S1;
  @HiveField(2)
  String? S2;
  @HiveField(3)
  String currency;
  @HiveField(4)
  double? percent;

  StoreModel(this.name, this.S1, this.S2, this.currency, this.percent);
}
