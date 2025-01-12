import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:teddy/sign%20in/controller.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SignInController>(
      create: (context) => SignInController(),
      child: Consumer<SignInController>(builder: (context, controller, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.grey.shade50,
            leading: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.close,
                  size: 32,
                  color: Colors.grey,
                )),
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (controller.teddyArtboard != null)
                    SizedBox(
                      width: 400,
                      height: 300,
                      child: Rive(
                        artboard: controller.teddyArtboard!,
                      ),
                    ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(blurRadius: 1, color: Colors.grey.shade300)
                      ],
                    ),
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: controller.emailController,
                            focusNode: controller.userNode,
                            keyboardType: TextInputType.text,
                            enableSuggestions: false,
                            autocorrect: false,
                            style: const TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              hintText: "رقم الهاتف",
                              filled: true,
                              fillColor: Colors.grey.shade200,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 18),
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'يرجى إدخال الاسم';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: controller.passwordController,
                            focusNode: controller.passNode,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                            style: const TextStyle(fontSize: 14),
                            cursorColor: const Color(0xffb04863),
                            decoration: InputDecoration(
                              hintText: "الرمز السري",
                              filled: true,
                              fillColor: Colors.grey.shade200,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 18),
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'يرجى إدخال رمز سري صعب';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            child: controller.checkBoxValue
                                ? Column(
                                    children: [
                                      TextFormField(
                                        controller:
                                            controller.repasswordController,
                                        focusNode: controller.repassNode,
                                        onTap: controller.handsOnTheEyes,
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        obscureText: true,
                                        style: const TextStyle(fontSize: 14),
                                        cursorColor: const Color(0xffb04863),
                                        decoration: InputDecoration(
                                          hintText: "إعادة كتابة الرمز السري",
                                          filled: true,
                                          fillColor: Colors.grey.shade200,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 24, vertical: 18),
                                          border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(8),
                                            ),
                                            borderSide: BorderSide.none,
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'يرجى إدخال رمز سري صعب';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 16),
                                    ],
                                  )
                                : Container(),
                          ),
                          const Text(
                            "نسيت الرمز السري ؟",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xffAB31B7),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: controller.checkBoxValue,
                                    activeColor: Color(0xffAB31B7),
                                    onChanged: (newvalue) =>
                                        controller.checkBox(newvalue!),
                                  ),
                                  const Text(
                                    "إنشاء حساب",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 24),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    if (controller.formKey.currentState!
                                        .validate()) {
                                      controller.isChecking?.change(false);
                                      controller.isHandsUp?.change(false);
                                      controller.failTrigger?.fire();
                                    } else {
                                      controller.isChecking?.change(false);
                                      controller.isHandsUp?.change(false);
                                      controller.failTrigger?.fire();
                                    }
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 18),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.grey.shade200),
                                    child: Text(
                                      !controller.checkBoxValue
                                          ? "تسجيل الدخول"
                                          : "إنشاء حساب",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
