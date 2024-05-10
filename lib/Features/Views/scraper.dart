// ignore_for_file: avoid_single_cascade_in_expression_statements

import 'dart:async';

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

class ScraperView extends StatefulWidget {
  final List<StoreModel> stores;
  const ScraperView({required this.stores, super.key});

  @override
  State<ScraperView> createState() => _ScraperViewState();
}

class _ScraperViewState extends State<ScraperView> {
  final WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..clearLocalStorage()
    ..clearCache();
  late Map<String, dynamic> data;

  final unavailable = RxList<Widget>().obs;
  RxInt updateds = 0.obs;
  bool updating = true;
  RxBool buttonDisabled = true.obs;

  @override
  void initState() {
    data = GetStorage().read("data");
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
          final completer = Completer<void>();
          controller
            ..loadRequest(Uri.parse(product.url))
            ..setNavigationDelegate(
              NavigationDelegate(
                onPageFinished: (url) {
                  controller
                    ..runJavaScriptReturningResult(
                      "encodeURIComponent(document.documentElement.outerHTML)",
                    ).then((value) async {
                      dom.Element? element = html
                          .parse(Uri.decodeComponent(value.toString()))
                          .documentElement;
                      if (element != null) {
                        final priceNode =
                            element.queryXPath(store.xpathPrice).node;
                        if (priceNode != null) {
                          update(store, product.id, priceNode.text!);
                          completer.complete();
                        } else {
                          final discountNode =
                              element.queryXPath(store.xpathDiscount).node;
                          final discountBeforeNode = element
                              .queryXPath(store.xpathPriceBeforeDiscount)
                              .node;

                          if (discountNode != null &&
                              discountBeforeNode != null) {
                            await showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  backgroundColor: const Color(0xFFFBFCFC),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(product.name),
                                        const SizedBox(height: 25),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                update(store, product.id,
                                                    discountBeforeNode.text!);
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                  discountBeforeNode.text!),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                update(store, product.id,
                                                    discountNode.text!);
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(discountNode.text!),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                            completer.complete();
                          } else {
                            unavailable.value.add(
                              Container(
                                height: 50,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 2.5),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
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
                                      product.name,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            );
                            completer.complete();
                          }
                        }
                      } else {
                        completer.complete();
                      }
                    });
                },
              ),
            );
          await completer.future;
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
      child: Scaffold(
        appBar: AppBar(),
        body: Stack(
          children: [
            Container(
              height: 800,
              padding: const EdgeInsets.all(15),
              child: Obx(
                () {
                  return Column(
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
                            Text(
                              updateds.value.toString(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "محصولات ناموجود",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              unavailable.value.length.toString(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          children: unavailable.value,
                        ),
                      ),
                      ElevatedButton(
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
                    ],
                  );
                },
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
            Converters.number(text),
            data["currency"],
            store.currency,
          ),
          store.percent),
    );
    updateds.value++;
  }
}
