// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:project_manager/controllers/auth_controller.dart';
// import 'package:project_manager/controllers/theme_controller.dart';
// import 'package:rive/rive.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();

//   final _emailController = TextEditingController();

//   final _passwordController = TextEditingController();

//   var riveUrl = 'assets/animated_login_character.riv';
//   var isSelectLanguage = false.obs;

//   SMITrigger? failTrigger, successTrigger;

//   SMIBool? isHandsUp, isChecking;

//   SMINumber? lookNum;

//   StateMachineController? stateMachineController;

//   Artboard? artboard;

//   final AuthController _authController = Get.find<AuthController>();

//   @override
//   void initState() {
//     super.initState();
//     rootBundle.load(riveUrl).then((value) {
//       final file = RiveFile.import(value);
//       final art = file.mainArtboard;
//       stateMachineController =
//           StateMachineController.fromArtboard(art, 'Login Machine');
//       if (stateMachineController != null) {
//         art.addController(stateMachineController!);
//         for (var element in stateMachineController!.inputs) {
//           if (element.name == 'isChecking') {
//             isChecking = element as SMIBool;
//           } else if (element.name == 'isHandsUp') {
//             isHandsUp = element as SMIBool;
//           } else if (element.name == 'trigSuccess') {
//             successTrigger = element as SMITrigger;
//           } else if (element.name == 'trigFail') {
//             failTrigger = element as SMITrigger;
//           } else if (element.name == 'numLook') {
//             lookNum = element as SMINumber;
//           }
//         }
//       }
//       setState(() {
//         artboard = art;
//       });
//     });
//   }

//   void lookAround() {
//     isChecking?.change(true);
//     isHandsUp?.change(false);
//     lookNum?.change(0);
//   }

//   void moveEyes(value) {
//     lookNum?.change(value.length.toDouble());
//   }

//   void handsUpOnEyes() {
//     isHandsUp?.change(true);
//     isChecking?.change(false);
//   }

//   void loginClick() {
//     isChecking?.change(false);
//     isHandsUp?.change(false);
//     if (_emailController.text == 'email' && _passwordController.text == '123') {
//       successTrigger?.fire();
//     } else {
//       failTrigger?.fire();
//     }

//     _authController.signInWithEmailAndPassword(
//         _emailController.text, _passwordController.text);
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     final ThemeController themeController = Get.find();

//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(),
//         drawer: Drawer(
//           child: Obx(
//             () {
//               return Column(
//                 children: [
//                   const SizedBox(height: 10),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text('change theme'.tr),
//                       const Icon(Icons.change_circle),
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   RadioListTile(
//                     title: Text('light mode'.tr),
//                     value: ThemeMode.light,
//                     groupValue: themeController.themeMode.value,
//                     onChanged: (ThemeMode? value) {
//                       if (value != null) {
//                         themeController.setThemeMode(value);
//                       }
//                     },
//                   ),
//                   RadioListTile(
//                     title: Text('dark mode'.tr),
//                     value: ThemeMode.dark,
//                     groupValue: themeController.themeMode.value,
//                     onChanged: (ThemeMode? value) {
//                       if (value != null) {
//                         themeController.setThemeMode(value);
//                       }
//                     },
//                   ),
//                   RadioListTile(
//                     title: Text('system default'.tr),
//                     value: ThemeMode.system,
//                     groupValue: themeController.themeMode.value,
//                     onChanged: (ThemeMode? value) {
//                       if (value != null) {
//                         themeController.setThemeMode(value);
//                       }
//                     },
//                   ),
//                   const SizedBox(height: 10),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text('select language'.tr),
//                       const Icon(Icons.language),
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   Obx(
//                     () => ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                           side: isSelectLanguage.value ? null : BorderSide()),
//                       onPressed: () {
//                         Get.updateLocale(const Locale('en', 'US'));
//                         isSelectLanguage.value = false;
//                       },
//                       child: const Row(
//                         children: [
//                           Text('English'),
//                           SizedBox(width: 10),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Obx(
//                     () => ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                           side: isSelectLanguage.value ? BorderSide() : null),
//                       onPressed: () {
//                         Get.updateLocale(const Locale('vi', 'VN'));
//                         isSelectLanguage.value = true;
//                       },
//                       child: const Row(
//                         children: [
//                           Text('Tiếng Việt'),
//                           SizedBox(width: 10),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             },
//           ),
//         ),
//         body: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   if (artboard != null)
//                     SizedBox(
//                       height: 300,
//                       width: 500,
//                       child: Rive(
//                         artboard: artboard!,
//                       ),
//                     ),
//                   const SizedBox(height: 4),
//                   Text(
//                     'login'.tr,
//                     style: const TextStyle(
//                         fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 4),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 15),
//                     child: TextFormField(
//                       controller: _emailController,
//                       onChanged: (value) => moveEyes(value),
//                       onTap: lookAround,
//                       decoration: InputDecoration(
//                         labelText: 'email'.tr,
//                         prefixIcon: const Icon(Icons.person),
//                         labelStyle: const TextStyle(fontSize: 18),
//                         contentPadding: const EdgeInsets.all(10),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 15.0),
//                     child: TextFormField(
//                       controller: _passwordController,
//                       onChanged: (value) => (),
//                       onTap: handsUpOnEyes,
//                       obscureText: true,
//                       decoration: InputDecoration(
//                           prefixIcon: const Icon(Icons.lock),
//                           labelText: 'password'.tr,
//                           labelStyle: const TextStyle(fontSize: 18),
//                           contentPadding: const EdgeInsets.all(10),
//                           border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(4))),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   MaterialButton(
//                     onPressed: () {},
//                     child: Text(
//                       'not having account? sign up!'.tr,
//                     ),
//                   ),
//                   Container(
//                     height: 50,
//                     width: 250,
//                     decoration: BoxDecoration(
//                       color: Colors.blueGrey,
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     clipBehavior: Clip.hardEdge,
//                     child: MaterialButton(
//                       onPressed: () {
//                         loginClick();
//                       },
//                       child: Text(
//                         'login'.tr,
//                         style: TextStyle(color: Colors.white, fontSize: 25),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardController extends GetxController with SingleGetTickerProviderMixin {
  RxBool isCardVisible = false.obs;

  late AnimationController animationController;
  late Animation<double> rotationAnimation;
  late Animation<Offset> slideAnimation;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    rotationAnimation = Tween<double>(begin: -0.2, end: 0.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeOut));

    slideAnimation = Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: animationController, curve: Curves.easeOut));
  }

  void toggleCard() {
    if (isCardVisible.value) {
      animationController.reverse();
    } else {
      animationController.forward();
    }
    isCardVisible.value = !isCardVisible.value;
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}

class ProfileCardPage extends StatelessWidget {
  ProfileCardPage({super.key});

  final CardController cardController = Get.put(CardController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLightMode = theme.brightness == Brightness.light;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile Card with Animation')),
      body: Stack(
        children: [
          // Nền chính
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                GestureDetector(
                  onTap: cardController.toggleCard,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isLightMode
                            ? [Colors.blue.shade700, Colors.blue.shade300]
                            : [Colors.grey.shade800, Colors.grey.shade600],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: const CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage('assets/profile.jpg'),
                      ),
                      title: const Text(
                        'Hải Duy',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: const Text(
                        'Software Developer',
                        style: TextStyle(color: Colors.white70),
                      ),
                      trailing: const Icon(
                        Icons.arrow_upward,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Card nổi lên với hiệu ứng xoay + rơi
          Obx(() {
            return Visibility(
              visible: cardController.isCardVisible.value,
              child: GestureDetector(
                onTap: cardController.toggleCard, // Đóng card khi nhấn ra ngoài
                child: Container(
                  color: Colors.black54, // Nền mờ
                  child: Center(
                    child: SlideTransition(
                      position: cardController.slideAnimation,
                      child: AnimatedBuilder(
                        animation: cardController.rotationAnimation,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: cardController.rotationAnimation.value,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 12,
                              child: Container(
                                width: 300,
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const CircleAvatar(
                                      radius: 50,
                                      backgroundImage:
                                          AssetImage('assets/profile.jpg'),
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      'Hải Duy',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    const Text(
                                      'Software Developer',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    ElevatedButton.icon(
                                      onPressed: cardController.toggleCard,
                                      icon: const Icon(Icons.close),
                                      label: const Text('Close'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
