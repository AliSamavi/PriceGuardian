import 'package:PriceGuardian/Core/Constants/images.dart';
import 'package:PriceGuardian/Features/Models/store.dart';
import 'package:PriceGuardian/Features/Controllers/stores.dart';
import 'package:PriceGuardian/Features/Views/product.dart';
import 'package:PriceGuardian/Features/Views/scraper.dart';
import 'package:PriceGuardian/Features/Views/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final controller = Get.put(StoresController());
  final stores = RxList<StoreModel>().obs;

  @override
  void dispose() {
    Get.delete<StoresController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: GestureDetector(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const StoreView(),
              ),
            );
            controller.update();
          },
          child: SvgPicture.asset(
            Images.add,
            height: 32,
            colorFilter: const ColorFilter.mode(
              Colors.green,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            GetX<StoresController>(
              builder: (controller) {
                return ListView.builder(
                  itemCount: controller.stores.length,
                  physics: const ClampingScrollPhysics(),
                  itemBuilder: (_, index) {
                    StoreModel store = controller.stores[index];
                    final Rx<Color> color = Colors.white.obs;
                    return GestureDetector(
                      onTap: () {
                        if (color.value == Colors.white) {
                          color.value = Colors.blue.shade50;
                          stores.value.add(store);
                        } else {
                          color.value = Colors.white;
                          stores.value.remove(store);
                        }
                      },
                      child: Obx(
                        () => Container(
                          height: 65,
                          margin: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 6,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
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
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ProductView(store: store),
                                    ),
                                  );
                                  ProductView(store: store);
                                },
                                child: SvgPicture.asset(
                                  Images.bag,
                                  height: 28,
                                  colorFilter: const ColorFilter.mode(
                                    Colors.green,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              GestureDetector(
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => StoreView(model: store),
                                    ),
                                  );
                                  controller.update();
                                },
                                child: SvgPicture.asset(
                                  Images.edit,
                                  height: 28,
                                  colorFilter: const ColorFilter.mode(
                                    Colors.yellow,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            Obx(() {
              return Visibility(
                visible: stores.value.isNotEmpty,
                child: Positioned(
                  left: 10,
                  bottom: 10,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              ScraperView(stores: stores.value),
                        ),
                      );
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: const BoxDecoration(
                        color: Color(0xFF140F2D),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 2.5,
                            color: Color(0xFF140F2D),
                          ),
                        ],
                      ),
                      child: SvgPicture.asset(
                        Images.play,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}
