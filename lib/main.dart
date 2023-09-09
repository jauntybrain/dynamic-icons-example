import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dynamic_icon/flutter_dynamic_icon.dart';

enum AppIcon {
  black,
  gradient,
  galaxy,
}

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  AppIcon? currentIcon;

  @override
  void initState() {
    // Get initial app icon and set the currentIcon value
    FlutterDynamicIcon.getAlternateIconName().then((iconName) {
      setState(() {
        currentIcon = AppIcon.values.byName(iconName ?? 'black');
      });
    });
    super.initState();
  }

  void changeAppIcon(AppIcon icon) async {
    try {
      // Check if the device supports alternate icons
      if (await FlutterDynamicIcon.supportsAlternateIcons) {
        // Change the icon
        await FlutterDynamicIcon.setAlternateIconName(icon.name);
        setState(() {
          currentIcon = icon; // Update the currentIcon value
        });
      }
    } on PlatformException catch (_) {
      print('Failed to change app icon');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (AppIcon appIcon in AppIcon.values) ...[
                TextButton(
                  onPressed: () => changeAppIcon(appIcon),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (currentIcon == appIcon)
                        const Icon(
                          Icons.check,
                          color: Colors.green,
                        ),
                      Text('Change to ${appIcon.name} icon'),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
