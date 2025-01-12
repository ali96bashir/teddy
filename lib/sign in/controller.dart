import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class SignInController extends ChangeNotifier {
  // Animation assets and controllers
  static Artboard? staticArtboard;
  static StateMachineController? staticController;
  String animationURL = 'src/animation/auth_teddy.riv';
  Artboard? teddyArtboard;
  StateMachineController? stateMachineController;

  // Rive state machine inputs
  SMITrigger? successTrigger, failTrigger;
  SMIBool? isHandsUp, isChecking;
  SMINumber? numLook;

  // State variables
  bool checkBoxValue = false;
  Timer? _debounce;

  // Form and input controllers
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repasswordController = TextEditingController();

  FocusNode userNode = FocusNode();
  FocusNode passNode = FocusNode();
  FocusNode repassNode = FocusNode();
  // Constructor
  SignInController() {
    // Focus listeners for text fields
    userNode.addListener(() {
      if (userNode.hasFocus) {
        lookOnTheTextField();
      } else {
        dontLookOnTheTextField();
      }
    });

    passNode.addListener(() {
      if (passNode.hasFocus) {
        handsOnTheEyes();
      } else {
        dontLookOnTheTextField();
      }
    });

    repassNode.addListener(() {
      if (repassNode.hasFocus) {
        handsOnTheEyes();
      } else {
        dontLookOnTheTextField();
      }
    });

    // Text controller listener for eye movement
    emailController.addListener(() {
      moveEyeBalls(emailController.text);
    });

    // Checkbox initial state
    checkBox(checkBoxValue);

    // Load animation
    loadAnimation();
  }

  // Load the Rive animation and set up the state machine
  void loadAnimation() async {
    // Load and initialize the Rive animation
    final data = await rootBundle.load(animationURL);
    final file = RiveFile.import(data);
    final artboard = file.mainArtboard;

    stateMachineController =
        StateMachineController.fromArtboard(artboard, "Login Machine");

    if (stateMachineController != null) {
      artboard.addController(stateMachineController!);

      // Assign state machine inputs
      for (var element in stateMachineController!.inputs) {
        switch (element.name) {
          case "successTrigger":
            successTrigger = element as SMITrigger;
            break;
          case "failTrigger":
            failTrigger = element as SMITrigger;
            break;
          case "isPrivateField":
            isHandsUp = element as SMIBool;
            break;
          case "isFocus":
            isChecking = element as SMIBool;
            break;
          case "numLook":
            numLook = element as SMINumber;
            break;
        }
      }
    }

    teddyArtboard = artboard;
    staticArtboard = artboard;
    staticController = stateMachineController;
    notifyListeners();
  }

  // Checkbox state management
  void checkBox(bool check) {
    checkBoxValue = check;
    notifyListeners();
  }

  // Trigger hands covering the eyes
  void handsOnTheEyes() {
    isHandsUp?.change(true);
    notifyListeners();
  }

  // Focus on text field (look animation)
  void lookOnTheTextField() {
    isHandsUp?.change(false);
    isChecking?.change(true);
    numLook?.change(0);
    notifyListeners();
  }

  // Unfocus (stop looking)
  void dontLookOnTheTextField() {
    if (isHandsUp?.value == true || isChecking?.value == true) {
      isHandsUp?.change(false);
      isChecking?.change(false);
      numLook?.change(0);
      notifyListeners();
    }
  }

  // Adjust eye movement based on input
  void moveEyeBalls(String val) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 100), () {
      numLook?.change(val.length.toDouble());
      notifyListeners();
    });
  }

  // Login logic
  void login() {
    isChecking?.change(false);
    isHandsUp?.change(false);

    if (emailController.text == "admin@gmail.com" &&
        passwordController.text == "admin") {
      successTrigger?.fire();
    } else {
      failTrigger?.fire();
    }
  }

  // Dispose resources
  @override
  void dispose() {
    userNode.dispose();
    passNode.dispose();
    emailController.dispose();
    passwordController.dispose();
    _debounce?.cancel();
    super.dispose();
  }
}
