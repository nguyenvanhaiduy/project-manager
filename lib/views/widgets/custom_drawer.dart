import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_manager/controllers/auth_controller.dart';
import 'package:project_manager/controllers/drawer_controller.dart';
import 'package:project_manager/controllers/language_controller.dart';
import 'package:project_manager/controllers/theme_controller.dart';
import 'package:project_manager/views/widgets/widgets.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({super.key, this.isLogout = true});

  final DrawerrController drawerController = Get.find();
  final ThemeController themeController = Get.find();
  final AuthController authController = Get.find();
  final LanguageController languageController = Get.find();

  final bool isLogout;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Material(
      child: Drawer(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 100.0),
            child: Column(
              children: [
                _buildHeader(context),
                const SizedBox(height: 10),
                _buildProfileCard(),
                const SizedBox(height: 10),
                _buildTagTile(),
                const SizedBox(height: 10),
                _buildThemeAndLanguageTiles(size),
                const SizedBox(height: 10),
                _buildRateUsAndFeatureRequestTile(),
                const SizedBox(height: 10),
                _buildLogoutTile(),
                // const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Text(
      'project manager'.tr,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildProfileCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: GestureDetector(
        onTap: () {
          // print(Get.isRegistered<DrawerrController>());
          // print(Get.isRegistered<AuthController>());
          // print(Get.isRegistered<ThemeController>());
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: Theme.of(Get.context!).brightness == Brightness.light
                ? Colors.white
                : Colors.black38,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                // leading: CircleAvatar(
                //   radius: 30,
                //   backgroundImage: const AssetImage('assets/profile.jpg'),
                //   onBackgroundImageError: (_, __) => const Icon(
                //     Icons.account_circle,
                //     size: 50,
                //     color: Colors.white,
                //   ),
                // ),
                leading: Obx(() {
                  if (authController.currentUser.value?.image != null) {
                    return CircleAvatar(
                      radius: 30,
                      backgroundImage:
                          authController.currentUser.value?.image!.image,
                      onBackgroundImageError: (_, __) =>
                          const Icon(Icons.account_circle),
                    );
                  } else if (authController.currentUser.value?.color != null &&
                      authController.currentUser.value?.name != null) {
                    return CircleAvatar(
                      radius: 30,
                      backgroundColor: authController.currentUser.value!.color,
                      child: Text(
                        authController.currentUser.value!.name[0].toUpperCase(),
                      ),
                    );
                  } else {
                    return CircleAvatar(
                      radius: 30,
                      backgroundImage: const AssetImage('assets/profile.jpg'),
                      onBackgroundImageError: (_, __) => const Icon(
                        Icons.account_circle,
                        size: 50,
                      ),
                    );
                  }
                }),
                title: Text(
                  authController.currentUser.value?.name ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Theme.of(Get.context!).brightness == Brightness.light
                        ? Colors.black87
                        : Colors.white,
                  ),
                ),
                subtitle: Text(
                  'Software Developer',
                  style: TextStyle(
                    color: Theme.of(Get.context!).brightness == Brightness.light
                        ? Colors.black54
                        : Colors.white70,
                  ),
                ),
              ),
              const Divider(
                color: Colors.grey,
                thickness: 0.5,
                indent: 20,
                endIndent: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(Get.context!).brightness ==
                                Brightness.light
                            ? const Color.fromARGB(255, 210, 230, 250)
                            : const Color(0xFF3C4251),
                        foregroundColor: Theme.of(Get.context!).brightness ==
                                Brightness.light
                            ? Colors.black87
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.remove_red_eye_outlined),
                      label: Text('view'.tr),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(Get.context!).brightness ==
                                Brightness.light
                            ? const Color.fromARGB(255, 210, 230, 250)
                            : const Color(0xFF3C4251),
                        foregroundColor: Theme.of(Get.context!).brightness ==
                                Brightness.light
                            ? Colors.black87
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.edit),
                      label: Text('edit'.tr),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTagTile() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.hardEdge,
      child: Material(
        child: isLogout
            ? _customListTile(
                'tag'.tr,
                '1',
                const ImageIcon(
                  AssetImage('assets/icons/icons8-tag-96.png'),
                ),
                BorderRadius.circular(10),
                () => _handleTagAction(),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                ),
              )
            : Container(),
      ),
    );
  }

  Widget _buildThemeAndLanguageTiles(Size size) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.hardEdge,
      child: Material(
        child: Column(
          children: [
            _customListTile(
              'theme'.tr,
              '2',
              const ImageIcon(
                AssetImage('assets/icons/icons8-paint-50.png'),
              ),
              const BorderRadius.vertical(
                top: Radius.circular(10),
              ),
              () => _handleThemeDialog(size),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 20,
              ),
            ),
            const Divider(
              height: 0,
              thickness: 0,
            ),
            _customListTile(
              'language'.tr,
              '3',
              const Icon(
                Icons.language,
              ),
              const BorderRadius.vertical(
                bottom: Radius.circular(10),
              ),
              () => _handleLanguageDialog(size),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRateUsAndFeatureRequestTile() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.hardEdge,
      child: Material(
        child: Column(
          children: [
            _customListTile(
              'rate us'.tr,
              '4',
              const Icon(Icons.star_rate_rounded),
              const BorderRadius.vertical(
                top: Radius.circular(10),
              ),
              () => _handleRateUsAction(),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 20,
              ),
            ),
            const Divider(
              thickness: 0,
              height: 0,
            ),
            _customListTile(
              'feature request'.tr,
              '5',
              const ImageIcon(
                AssetImage('assets/icons/icons8-orthogonal-view-96.png'),
              ),
              const BorderRadius.vertical(bottom: Radius.circular(10)),
              () => _handleFeatureRequestAction(),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 20,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutTile() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.hardEdge,
      child: Material(
        child: isLogout
            ? _customListTile(
                'logout'.tr,
                '6',
                const Spacer(),
                BorderRadius.circular(10),
                () => _handleLogoutAction(),
              )
            : Container(),
      ),
    );
  }

  Widget _customListTile(String title, String id, Widget leading,
      BorderRadiusGeometry borderRadiusGeometry, Function() onPressed,
      {Widget? trailing}) {
    return Obx(
      () => ListTile(
        key: Key(id),
        title: Text(title),
        onTap: onPressed,
        selected: drawerController.selectedIndex.value == id,
        // splashColor: Colors.lime,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadiusGeometry,
        ),
        leading: leading,
        trailing: trailing,
      ),
    );
  }

  void _handleTagAction() {
    drawerController.changeIndex('1');
    Get.back();
    Get.defaultDialog(onCancel: () => Get.back(), onConfirm: () => Get.back());
  }

  void _handleThemeDialog(Size size) {
    Get.back();
    drawerController.changeIndex('2');
    Get.dialog(
      barrierDismissible: true,
      Center(
        child: Material(
          borderRadius: BorderRadius.circular(10),
          clipBehavior: Clip.hardEdge,
          child: SizedBox(
            width: 300,
            child: Obx(
              () => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  customTextButton(
                      child: const Icon(
                        Icons.light_mode,
                        size: 20,
                      ),
                      title: 'light',
                      onPress: () {
                        themeController.setThemeMode(ThemeMode.light);
                      },
                      themeMode: ThemeMode.light),
                  const Divider(
                    height: 0,
                    thickness: 0,
                  ),
                  customTextButton(
                      child: const Icon(
                        Icons.dark_mode,
                        size: 20,
                      ),
                      title: 'dark',
                      onPress: () {
                        themeController.setThemeMode(ThemeMode.dark);
                      },
                      themeMode: ThemeMode.dark),
                  const Divider(
                    height: 0,
                    thickness: 0,
                  ),
                  customTextButton(
                    child: const Icon(
                      Icons.settings,
                      size: 20,
                    ),
                    title: 'system',
                    onPress: () {
                      themeController.setThemeMode(ThemeMode.system);
                    },
                    themeMode: ThemeMode.system,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleLanguageDialog(Size size) {
    Get.back();
    drawerController.changeIndex('3');
    Get.dialog(
      barrierDismissible: true,
      Center(
        child: Material(
          borderRadius: BorderRadius.circular(10),
          clipBehavior: Clip.hardEdge,
          child: SizedBox(
            width: 200,
            child: Obx(
              () => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  customTextButton(
                      child: Image.asset(
                        'assets/icons/icon_united_kingdom.jpg',
                        width: 30,
                      ),
                      title: 'english',
                      onPress: () {
                        // print(drawerController.selectLanguage.value);
                        languageController
                            .changeLanguage(const Locale('en', 'US'));
                      },
                      name: 'en'),
                  customTextButton(
                      child: Image.asset(
                        'assets/icons/icon_vietname.png',
                        width: 30,
                      ),
                      title: 'vietnamese',
                      onPress: () {
                        // print(drawerController.selectLanguage.value);
                        languageController
                            .changeLanguage(const Locale('vi', 'VN'));
                      },
                      name: 'vi')
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleRateUsAction() {
    drawerController.changeIndex('4');
    // Get.back();
    // Get.defaultDialog(onCancel: () => Get.back(), onConfirm: () => Get.back());
  }

  void _handleFeatureRequestAction() {
    drawerController.changeIndex('5');
  }

  void _handleLogoutAction() {
    drawerController.changeIndex('6');
    authController.signOut();
  }
}
