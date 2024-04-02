import 'package:PriceGuardian/Core/Services/service.dart';
import 'package:PriceGuardian/Core/Utils/converters.dart';
import 'package:PriceGuardian/Features/Models/product.dart';
import 'package:PriceGuardian/Features/Models/store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html;
import 'package:webview_flutter/webview_flutter.dart';
import 'package:xpath_selector_html_parser/xpath_selector_html_parser.dart';

class CustomDialog extends StatefulWidget {
  final List<StoreModel> stores;
  const CustomDialog({required this.stores, super.key});

  @override
  State<CustomDialog> createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..clearLocalStorage()
    ..clearCache();
  bool updating = true;
  late Map<String, dynamic> data;

  RxInt updateds = 0.obs;
  final unavailable = RxList<Widget>().obs;
  RxBool buttonDisabled = true.obs;

  @override
  void initState() {
    GetStorage storage = GetStorage();
    data = storage.read("data");
    asyncState();
    super.initState();
  }

  void asyncState() async {
    final products = await Hive.openBox<ProductModel>("products");
    for (StoreModel store in widget.stores) {
      if (!updating) {
        break;
      }
      for (ProductModel product in products.values) {
        if (!updating) {
          break;
        } else if (store.key == product.store) {
          bool isPageFinished = false;
          controller
            ..loadRequest(Uri.parse(product.url))
            ..setNavigationDelegate(
              NavigationDelegate(
                onPageFinished: (url) async {
                  await controller
                      .runJavaScriptReturningResult(
                          "encodeURIComponent(document.documentElement.outerHTML)")
                      .then((value) async {
                    dom.Element? element = html
                        .parse(Uri.decodeComponent(value.toString()))
                        .documentElement;

                    if (element != null) {
                      final priceNode =
                          element.queryXPath(store.xpathPrice).node;
                      final discountNode =
                          element.queryXPath(store.xpathDiscount ?? "").node;
                      if (priceNode != null) {
                        update(store, product.id, priceNode.text!);
                      } else if (discountNode != null) {
                        update(store, product.id, discountNode.text!);
                      } else {
                        String? name = await Service.get(
                            data["domain"],
                            {"Authorization": data["authorization"]},
                            product.id);

                        unavailable.value.add(
                          Container(
                            height: 50,
                            margin: const EdgeInsets.symmetric(vertical: 2.5),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Text(product.id.toString()),
                                const SizedBox(width: 15),
                                Text(
                                  name ?? "",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    }
                  });
                  isPageFinished = true;
                },
              ),
            );

          while (!isPageFinished) {
            await Future.delayed(const Duration(milliseconds: 3000));
          }
        }
      }
    }
    await products.close();
    buttonDisabled.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) async {
        updating = false;
        await controller.clearCache();
        await controller.clearLocalStorage();
      },
      child: Dialog(
        child: Stack(
          children: [
            Container(
              height: 550,
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "تعداد محصولات آپدیت شده:",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Obx(
                          () => Text(
                            updateds.value.toString(),
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "محصولات ناموجود",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  Expanded(
                    child: Obx(
                      () => ListView(
                        physics: const BouncingScrollPhysics(),
                        children: unavailable.value,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Obx(
                    () => ElevatedButton(
                      onPressed: buttonDisabled.value
                          ? null
                          : () {
                              Navigator.pop(context);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF140F2D),
                        elevation: 2.5,
                        minimumSize: const Size(500, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Text(
                        "تایید",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Offstage(child: WebViewWidget(controller: controller)),
          ],
        ),
      ),
    );
  }

  void update(StoreModel store, int id, String text) {
    Service.put(
      data["domain"],
      {"Authorization": data["authorization"]},
      id,
      Converters.calculator(
          Converters.currency(
              Converters.number(text), data["currency"], store.currency),
          store.percent ?? 100),
    );
    updateds.value++;
  }
}
