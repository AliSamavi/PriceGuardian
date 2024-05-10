import 'dart:convert';
import 'dart:io';

import 'package:PriceGuardian/Core/Widgets/product_dialog.dart';
import 'package:PriceGuardian/Core/Widgets/clear_product.dart';
import 'package:PriceGuardian/Features/Controllers/products.dart';
import 'package:PriceGuardian/Features/Models/product.dart';
import 'package:PriceGuardian/Features/Models/store.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductView extends StatefulWidget {
  final StoreModel store;
  const ProductView({required this.store, super.key});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  late ProductsController controller;

  @override
  void initState() {
    controller = Get.put(ProductsController(store: widget.store));
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<ProductsController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.store.name,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 20),
        ),
        actions: [
          PopupMenuButton(
            color: Colors.grey.shade200,
            onSelected: (value) {
              switch (value) {
                case 0:
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ProductDialog(controller: controller);
                    },
                  );
                case 1:
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ClearProduct(controller: controller);
                    },
                  );
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 0,
                child: Row(
                  children: [
                    Icon(
                      Icons.add_outlined,
                      color: Colors.green.shade800,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text("اضافه کردن محصول")
                  ],
                ),
              ),
              PopupMenuItem(
                value: 1,
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_outlined,
                      color: Colors.red.shade800,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text("حذف همه")
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: GetX<ProductsController>(
          builder: (controller) {
            if (controller.products.isEmpty) {
              return Center(
                child: TextButton(
                  onPressed: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ["csv"],
                    );
                    final File file = File(result!.files.single.path ?? "");
                    Stream<List> input = file.openRead();

                    Stream<List<String>> lines = input
                        .transform(utf8.decoder)
                        .transform(const LineSplitter())
                        .map((line) => line.split(','));
                    await for (List<String> row in lines) {
                      if (row.length != 3) {
                        break;
                      }
                      controller.addProduct(
                        int.parse(row[0]),
                        row[1],
                        row[2],
                      );
                    }
                    file.delete();
                  },
                  child: const Text("خواندن از فایل"),
                ),
              );
            }
            return ListView.builder(
              itemCount: controller.products.length,
              physics: const ClampingScrollPhysics(),
              itemBuilder: (_, index) {
                ProductModel product = controller.products[index];
                return Container(
                  height: 65,
                  margin: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 6,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 10,
                        child: Text(
                          product.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        color: Colors.green.shade600,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ProductDialog(
                                controller: controller,
                                model: product,
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.edit_outlined),
                      ),
                      IconButton(
                        color: Colors.red.shade600,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ClearProduct(
                                controller: controller,
                                model: product,
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.delete_outlined),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
