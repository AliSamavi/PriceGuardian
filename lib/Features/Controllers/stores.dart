import 'package:PriceGuardian/Features/Models/store.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class StoresController extends GetxController {
  final _stores = RxList<StoreModel>().obs;
  List<StoreModel> get stores => _stores.value;

  @override
  void onInit() {
    _loadStores();
    super.onInit();
  }

  @override
  void update([List<Object>? ids, bool condition = true]) {
    _stores.value.clear();
    _loadStores();
    super.update(ids, condition);
  }

  void _loadStores() async {
    final box = await Hive.openBox<StoreModel>("stores");
    box.values.forEach((element) {
      _stores.value.add(element);
    });
    await box.close();
  }

  void removeStore(int key) async {
    final box = await Hive.openBox<StoreModel>("stores");
    await box.delete(key);
    await box.close();
  }
}
