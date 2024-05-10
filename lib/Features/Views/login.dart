import 'dart:convert';

import 'package:PriceGuardian/Core/Utils/currency.dart';
import 'package:PriceGuardian/Core/Widgets/custom_dropdown.dart';
import 'package:PriceGuardian/Core/Widgets/custom_text_field.dart';
import 'package:PriceGuardian/Features/Views/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// ignore: must_be_immutable
class LoginView extends StatelessWidget {
  LoginView({super.key});

  final TextEditingController _domain = TextEditingController();
  final TextEditingController _token = TextEditingController();
  Currency _currency = Currency.rial;

  final RxBool _validator = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF140F2D), Color(0xFFFBFCFC)],
                stops: [0.5, 0.5],
              ),
            ),
          ),
          const Positioned(
            left: 50,
            top: 125,
            child: Text(
              "PriceGuardian",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Center(
            child: Container(
              height: 450,
              width: 350,
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 5,
                    color: Colors.grey,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "دامنه:",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  CustomTextField(
                    controller: _domain,
                    radius: 18,
                    hintText: "example.com",
                    onChanged: (value) {
                      if (value.isURL && _token.text.isNotEmpty) {
                        _validator.value = true;
                      } else {
                        _validator.value = false;
                      }
                    },
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "توکن:",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  CustomTextField(
                    controller: _token,
                    radius: 18,
                    onChanged: (value) {
                      if (value.isNotEmpty && _domain.text.isURL) {
                        _validator.value = true;
                      } else {
                        _validator.value = false;
                      }
                    },
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
                    value: _currency,
                    onChanged: (value) {
                      _currency = value!;
                    },
                  ),
                  const Spacer(),
                  Obx(
                    () {
                      return ElevatedButton(
                        onPressed:
                            _validator.value ? () => onPressed(context) : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF140F2D),
                          elevation: 2.5,
                          minimumSize: const Size(500, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: const Text(
                          "ورود",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onPressed(BuildContext context) {
    final storage = GetStorage();
    Codec<String, String> b64 = utf8.fuse(base64);
    String authorization = b64.encode(_token.text);

    storage.write("data", {
      "domain": _domain.text,
      "authorization": "Basic $authorization",
      "currency": _currency.toString(),
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeView()),
    );
  }
}
