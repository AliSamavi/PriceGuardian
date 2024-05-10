import 'package:PriceGuardian/Core/Utils/currency.dart';
import 'package:PriceGuardian/Core/Widgets/custom_dropdown.dart';
import 'package:PriceGuardian/Core/Widgets/custom_text_field.dart';
import 'package:PriceGuardian/Features/Models/store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class StoreView extends StatefulWidget {
  final StoreModel? model;
  const StoreView({this.model, super.key});

  @override
  State<StoreView> createState() => _StoreViewState();
}

class _StoreViewState extends State<StoreView> {
  TextEditingController name = TextEditingController();
  TextEditingController xpathPrice = TextEditingController();
  TextEditingController xpathDiscount = TextEditingController();
  TextEditingController xpathPriceBeforeDiscount = TextEditingController();
  TextEditingController percent = TextEditingController(text: "100");
  Currency currency = Currency.rial;

  final RxBool validator = false.obs;

  @override
  void initState() {
    if (widget.model != null) {
      name.text = widget.model!.name;
      xpathPrice.text = widget.model!.xpathPrice;
      xpathDiscount.text = widget.model!.xpathDiscount;
      xpathPriceBeforeDiscount.text = widget.model!.xpathPriceBeforeDiscount;
      percent.text = widget.model!.percent.toString();
      currency = widget.model!.currency == "Currency.rial"
          ? Currency.rial
          : Currency.toman;
      validator.value = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const Text(
              "نام:",
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 5),
            CustomTextField(
              controller: name,
              radius: 18,
              textDirection: TextDirection.rtl,
              onChanged: assessment,
            ),
            const SizedBox(height: 15),
            const Text(
              "آدرس قیمت:",
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 5),
            CustomTextField(
              controller: xpathPrice,
              radius: 18,
              onChanged: assessment,
            ),
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 5),
            const Text(
              "آدرس قیمت نهایی:",
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 5),
            CustomTextField(
              controller: xpathDiscount,
              radius: 18,
              onChanged: assessment,
            ),
            const SizedBox(height: 15),
            const Text(
              "آدرس قیمت قبل تخفیف:",
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 5),
            CustomTextField(
              controller: xpathPriceBeforeDiscount,
              radius: 18,
              onChanged: assessment,
            ),
            const Divider(),
            const Text(
              "درصد افزایش:",
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 5),
            CustomTextField(
              controller: percent,
              radius: 18,
              keyboardType: TextInputType.number,
              onChanged: assessment,
            ),
            const SizedBox(height: 15),
            const Text(
              "واحد پول:",
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 5),
            CustomDropdown(
              radius: 18,
              value: currency,
              onChanged: (value) {
                currency = value!;
              },
            ),
            const SizedBox(height: 25),
            Obx(() {
              return ElevatedButton(
                onPressed: validator.value ? onPressed : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF140F2D),
                  elevation: 2.5,
                  minimumSize: const Size(100, 50),
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
              );
            })
          ],
        ),
      ),
    );
  }

  void assessment(String? value) {
    if (name.text.isNotEmpty &&
        xpathPrice.text.isNotEmpty &&
        xpathDiscount.text.isNotEmpty &&
        xpathPriceBeforeDiscount.text.isNotEmpty &&
        percent.text.isNum) {
      validator.value = true;
    } else {
      validator.value = false;
    }
  }

  void onPressed() async {
    final data = StoreModel(
        name.text,
        xpathPrice.text,
        xpathDiscount.text,
        xpathPriceBeforeDiscount.text,
        currency.toString(),
        double.parse(percent.text));

    var box = await Hive.openBox<StoreModel>("stores");
    if (widget.model != null) {
      await box.put(widget.model!.key, data);
    } else {
      await box.add(data);
    }
    await box.close();

    Navigator.pop(context);
  }
}
