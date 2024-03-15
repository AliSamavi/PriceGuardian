import 'dart:convert';
import 'dart:io';

import 'package:PriceGuardian/Core/Constants/images.dart';
import 'package:PriceGuardian/Core/Widgets/custom_dialog.dart';
import 'package:PriceGuardian/Core/Widgets/custom_text_field.dart';
import 'package:PriceGuardian/Features/Models/product.dart';
import 'package:PriceGuardian/Features/Models/store.dart';
import 'package:PriceGuardian/Features/Controllers/stores.dart';
import 'package:PriceGuardian/Features/Views/store.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final controller = Get.put(StoresController());
  List<StoreModel> updateStore = [];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF140F2D),
      body: Stack(
        children: [
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () async {
                if (updateStore.isNotEmpty) {
                  await showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => CustomDialog(stores: updateStore),
                  );
                  updateStore = [];
                  controller.update();
                }
              },
              child: Container(
                height: 125,
                width: 125,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(blurRadius: 5, color: Colors.white),
                  ],
                ),
                child: Center(
                  child: SvgPicture.asset(
                    Images.play,
                    height: 120,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF140F2D),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              child: Container(
                height: 600,
                color: const Color(0xFFFBFCFC),
                child: GetX<StoresController>(
                  builder: (controller) {
                    return Stack(
                      children: [
                        ListView.builder(
                          itemCount: controller.stores.length,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.only(
                            top: 6,
                            left: 10,
                            right: 10,
                            bottom: 80,
                          ),
                          itemBuilder: (context, index) {
                            return itemBuilder(controller.stores[index]);
                          },
                        ),
                        Positioned(
                          bottom: 10,
                          left: 15,
                          child: GestureDetector(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const StoreView(),
                                ),
                              );
                              controller.update();
                            },
                            child: Container(
                              height: 60,
                              width: 60,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: SvgPicture.asset(Images.add),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget itemBuilder(StoreModel store) {
    final Rx<Color> color = Colors.white.obs;
    return Dismissible(
      key: Key(store.key.toString()),
      onDismissed: (direction) => controller.removeStore(store.key),
      background: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        color: Colors.red.shade900,
        alignment: Alignment.centerRight,
        child: SvgPicture.asset(
          Images.delete,
          height: 35,
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
      ),
      child: GestureDetector(
        onTap: () {
          if (color.value == Colors.white) {
            color.value = Colors.blue.shade100;
            updateStore.add(store);
          } else {
            color.value = Colors.white;
            updateStore.remove(store);
          }
        },
        child: Obx(
          () => Container(
            height: 65,
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.value,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Text(
                  store.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => dialog(store),
                  child: SvgPicture.asset(
                    Images.add,
                    height: 35,
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StoreView(model: store),
                      ),
                    );
                    controller.update();
                  },
                  child: SvgPicture.asset(
                    Images.edit,
                    height: 32,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void dialog(StoreModel store) {
    TextEditingController id = TextEditingController();
    TextEditingController url = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: const Color(0xFFFBFCFC),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                const Text("شناسه:"),
                const SizedBox(height: 5),
                CustomTextField(
                    controller: id,
                    keyboardType: TextInputType.number,
                    radius: 14),
                const SizedBox(height: 8),
                const Text("آدرس اینترنتی:"),
                const SizedBox(height: 5),
                CustomTextField(
                    controller: url,
                    keyboardType: TextInputType.url,
                    radius: 14),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (id.text.isNotEmpty && url.text.isNotEmpty) {
                            final data = ProductModel(
                              store.key,
                              int.parse(id.text),
                              url.text,
                            );
                            var box =
                                await Hive.openBox<ProductModel>("products");
                            await box.add(data);
                            await box.close();
                            id.clear();
                            url.clear();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF140F2D),
                          elevation: 2.5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: const Text(
                          "ذخیره",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    TextButton(
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
                        var box = await Hive.openBox<ProductModel>("products");
                        await for (List<String> row in lines) {
                          if (row.length == 2) {
                            final data = ProductModel(
                              store.key,
                              int.parse(row[0]),
                              row[1],
                            );
                            await box.add(data);
                          }
                        }
                        await box.close();

                        Navigator.pop(context);
                      },
                      child: const Text("خواندن از فایل"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
