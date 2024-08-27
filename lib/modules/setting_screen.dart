import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/todo/provider/mains_provider.dart';
import 'package:todo/todo/provider/theme_provider.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final themeMode = themeNotifier.applight;

    return Scaffold(
      backgroundColor:
          themeNotifier.isDarkMode ? const Color(0xff141A2E) : Colors.grey[300],
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 200.0,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              Positioned(
                bottom: 40.0,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 50.0,
                    ),
                    Text(
                      'To Do List'.tr(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 40.0,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: DropdownButtonFormField<ThemeMode>(
              items: [
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text(
                    "Light",
                    style: TextStyle(
                      color: themeMode == ThemeMode.light
                          ? Colors.amber
                          : Colors.black,
                    ),
                  ),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text(
                    "Dark",
                    style: TextStyle(
                      color: themeMode == ThemeMode.dark
                          ? Colors.blueGrey
                          : Colors.black,
                    ),
                  ),
                ),
              ],
              onChanged: (ThemeMode? newValue) {
                if (newValue != null) {
                  themeNotifier.changeTheme(newValue);
                }
              },
              decoration: const InputDecoration(
                labelText: "Choose Theme",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: DropdownButtonFormField<Locale>(
              value: EasyLocalization.of(context)!.locale,
              items: [
                DropdownMenuItem(
                  value: const Locale('en', ''),
                  child: Text(
                    'English',
                    style: TextStyle(
                      color: themeMode == ThemeMode.light
                          ? Colors.amber
                          : Colors.grey,
                    ),
                  ),
                ),
                DropdownMenuItem(
                  value: const Locale('ar', ''),
                  child: Text(
                    'عربي',
                    style: TextStyle(
                      color: themeMode == ThemeMode.dark
                          ? Colors.blueGrey
                          : Colors.grey,
                    ),
                  ),
                ),
              ],
              onChanged: (Locale? newLocale) {
                if (newLocale != null) {
                  themeNotifier.changeLanguage(newLocale);
                  EasyLocalization.of(context)!.setLocale(newLocale);
                }
              },
              decoration: const InputDecoration(
                labelText: "Choose Lang",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(
            height: 40.0,
          ),
          Consumer<MainProvider>(
            builder: (context, provider, child) {
              return ElevatedButton(
                onPressed: () {
                  provider.logout(context);
                },
                child: const Text(
                  "LOGOUT",
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
