import 'package:PriceGuardian/Features/Models/product.dart';
import 'package:PriceGuardian/Features/Models/store.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class ProductsController extends GetxController {
  late Box box;
  final StoreModel _store;
  ProductsController({required StoreModel store}) : _store = store;

  final _products = RxList<ProductModel>().obs;
  List<ProductModel> get products => _products.value;

  @override
  void onInit() async {
    box = await Hive.openBox<ProductModel>("products");
    _loadProducts();
    super.onInit();
  }

  @override
  void onClose() {
    box.close();
    super.onClose();
  }

  @override
  void update([List<Object>? ids, bool condition = true]) {
    _products.value.clear();
    _loadProducts();
    super.update(ids, condition);
  }

  void _loadProducts() async {
    box.values.forEach((element) {
      if (_store.key == element.store) {
        _products.value.add(element);
      }
    });
  }

  void addProduct(int id, String name, String url) async {
    box.add(ProductModel(_store.key, id, name, url));
    update();
  }

  void editProduct(dynamic key, int id, String name, String url) {
    box.put(key, ProductModel(_store.key, id, name, url));
    update();
  }

  void clearAll() async {
    await box.clear();
    update();
  }

  void delete(dynamic key) async {
    await box.delete(key);
    update();
  }
}
