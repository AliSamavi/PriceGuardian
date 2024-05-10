import 'package:PriceGuardian/Core/Widgets/custom_text_field.dart';
import 'package:PriceGuardian/Features/Controllers/products.dart';
import 'package:PriceGuardian/Features/Models/product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDialog extends StatefulWidget {
  final ProductsController controller;
  final ProductModel? model;
  const ProductDialog({required this.controller, this.model, super.key});

  @override
  State<ProductDialog> createState() => _ProductDialogState();
}

class _ProductDialogState extends State<ProductDialog> {
  TextEditingController id = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController url = TextEditingController();

  RxBool validator = false.obs;

  @override
  void initState() {
    if (widget.model != null) {
      id.text = "${widget.model!.id}";
      name.text = widget.model!.name;
      url.text = widget.model!.url;
      validator.value = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              radius: 14,
              onChanged: assessment,
            ),
            const SizedBox(height: 8),
            const Text("نام محصول:"),
            const SizedBox(height: 5),
            CustomTextField(
              controller: name,
              radius: 14,
              textDirection: TextDirection.rtl,
              onChanged: assessment,
            ),
            const SizedBox(height: 8),
            const Text("آدرس اینترنتی:"),
            const SizedBox(height: 5),
            CustomTextField(
              controller: url,
              keyboardType: TextInputType.url,
              radius: 14,
              onChanged: assessment,
            ),
            const SizedBox(height: 20),
            Obx(() {
              return ElevatedButton(
                onPressed: validator.value
                    ? () {
                        if (widget.model == null) {
                          widget.controller.addProduct(
                            int.parse(id.text),
                            name.text,
                            url.text,
                          );
                        } else {
                          widget.controller.editProduct(
                            widget.model!.key,
                            int.parse(id.text),
                            name.text,
                            url.text,
                          );
                        }

                        Navigator.pop(context);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(300, 50),
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
              );
            })
          ],
        ),
      ),
    );
  }

  void assessment(String value) {
    if (id.text.isNum && name.text.isNotEmpty && url.text.isURL) {
      validator.value = true;
    } else {
      validator.value = false;
    }
  }
}
