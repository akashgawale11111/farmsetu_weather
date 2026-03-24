import 'package:farmsetu_weather/screens/home_screen/save_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class CustomDrawer extends ConsumerWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {


    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [

             ListTile(
            leading: const Icon(Icons.payment),
            title: Text('Save Data'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SaveData()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit_calendar),
            title: Text('Save Data'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SaveData()),
              );
            },
          ),
        ],
      ),
    );
  }
}


void showLogoutPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text("Logout"),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const SaveData()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      );
    },
  );
}