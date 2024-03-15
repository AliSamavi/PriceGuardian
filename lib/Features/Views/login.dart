import 'dart:async';
import 'dart:convert';

import 'package:PriceGuardian/Core/Constants/images.dart';
import 'package:PriceGuardian/Core/Utils/currency.dart';
import 'package:PriceGuardian/Core/Widgets/custom_dropdown.dart';
import 'package:PriceGuardian/Core/Widgets/custom_text_field.dart';
import 'package:PriceGuardian/Features/Views/home.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late StreamSubscription<ConnectivityResult> connectivity;
  final StreamController<ConnectivityResult> controller =
      StreamController<ConnectivityResult>();

  TextEditingController domain = TextEditingController();
  TextEditingController token = TextEditingController();
  Currency currency = Currency.rial;

  @override
  void initState() {
    controller.sink.add(ConnectivityResult.none);
    connectivity = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      controller.sink.add(result);
    });
    super.initState();
  }

  @override
  dispose() {
    controller.close();
    connectivity.cancel();
    domain.dispose();
    token.dispose();
    super.dispose();
  }

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
                fontSize: 24,
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
              child: StreamBuilder<ConnectivityResult>(
                  stream: controller.stream,
                  builder: (context, snapshot) {
                    if (snapshot.data == ConnectivityResult.none) {
                      return Column(
                        children: [
                          Image.asset(
                            Images.connection,
                            width: 250,
                          ),
                          const Text(
                            "لطفا اتصال خود را بررسی کنید.",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Column(
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
                            controller: domain,
                            radius: 18,
                            hintText: "example.com",
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
                            controller: token,
                            radius: 18,
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
                          const Spacer(),
                          ElevatedButton(
                            onPressed: onPressed,
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
                          ),
                        ],
                      );
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }

  void onPressed() {
    if (domain.text.isNotEmpty && token.text.isNotEmpty) {
      final storage = GetStorage();
      Codec<String, String> b64 = utf8.fuse(base64);
      String authorization = b64.encode(token.text);

      storage.write("data", {
        "domain": domain.text,
        "authorization": "Basic $authorization",
        "currency": currency.toString(),
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeView()),
      );
    }
  }
}
