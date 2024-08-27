import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/todo/provider/mains_provider.dart';
import 'package:todo/todo/provider/theme_provider.dart';
import 'package:todo/widgets/add_task.dart';

class LayoutScreen extends StatelessWidget {
  static const String routeName = "layoutScreen";
  const LayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return ChangeNotifierProvider(
      create: (context) => MainProvider()..getUser(),
      child: Selector<MainProvider, int>(
        selector: (p0, p1) => p1.selectedIndex,
        builder: (context, selectedIndex, child) {
          var provider = Provider.of<MainProvider>(context, listen: false);
          return Container(
            child: Scaffold(
              extendBody: true,
              floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    showModalBottomSheet(
                      showDragHandle: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      context: context,
                      builder: (context) {
                        return ChangeNotifierProvider.value(
                            value: provider, child: const AddTaskWidget());
                      },
                    );
                  },
                  shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.white, width: 3),
                      borderRadius: BorderRadius.circular(360)),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  )),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              bottomNavigationBar: BottomAppBar(
                height: 100,
                shape: const CircularNotchedRectangle(),
                color:
                    themeNotifier.isDarkMode ? Color(0xff141A2E) : Colors.white,
                notchMargin: 10,
                child: SizedBox(
                  height: 60,
                  child: BottomNavigationBar(
                    unselectedItemColor: themeNotifier.isDarkMode
                        ? Colors.white
                        : Colors.black26,
                    selectedItemColor: Colors.blue,
                    onTap: provider.setIndex,
                    currentIndex: selectedIndex,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    items: [
                      BottomNavigationBarItem(
                          icon: Icon(
                            Icons.menu,
                          ),
                          label: "Tasks".tr()),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.settings), label: "settings".tr())
                    ],
                  ),
                ),
              ),
              body: provider.screens[selectedIndex],
            ),
          );
        },
      ),
    );
  }
}
