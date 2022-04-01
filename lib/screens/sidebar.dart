import 'package:flutter/material.dart';
import 'package:cephalopod/components/settingsItem.dart';

class SideBar extends StatefulWidget {
  const SideBar({Key? key}) : super(key: key);
  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Container(
        // neuphormatic design
        decoration: const BoxDecoration(
          //#ECF0F3
          color: Color(0xFFECF0F3),
          boxShadow: [
            BoxShadow(
              color: Color(0x00d1d9e6),
              blurRadius: 30,
              spreadRadius: 5,
              offset: Offset(100, 0),
            ),
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
          ),
        ),
        width: 70,
        child: Drawer(
          elevation: 0,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
          )),
          child: Column(
            children: [
              IconButton(icon: const Icon(Icons.folder), onPressed: () => null),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.85,
              ),
              IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () => {
                        //context menu
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text(
                                  "Settings",
                                  textAlign: TextAlign.center,
                                ),
                                content: Column(children: const [
                                  // dark theme on or off
                                  SettingsSwitch(title: "DarkTheme"),
                                ]),
                              );
                            })
                      }),
            ],
          ),
        ),
      ),
    );
  }
}
