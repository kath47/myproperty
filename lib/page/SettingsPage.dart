import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = false;
  bool syncEnabled = false;

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  Future<void> loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      notificationsEnabled = prefs.getBool('notificationsEnabled') ?? false;
      syncEnabled = prefs.getBool('syncEnabled') ?? false;
    });
  }

  Future<void> updateNotificationSetting(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', value);
    setState(() {
      notificationsEnabled = value;
    });
  }

  Future<void> updateSyncSetting(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('syncEnabled', value);
    setState(() {
      syncEnabled = value;
    });
  }

  void logOut() {
  
    // For example, clearing user session data and navigating to the login screen
    Navigator.popUntil(context, ModalRoute.withName('/login')); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      //appBar: AppBar(title: const Text('Paramètres')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: const Text('Activer les notifications'),
              value: notificationsEnabled,
              onChanged: (value) {
                updateNotificationSetting(value);
              },
            ),
            SwitchListTile(
              title: const Text('Activer la synchronisation des données'),
              value: syncEnabled,
              onChanged: (value) {
                updateSyncSetting(value);
              },
            ),
            const SizedBox(height: 20),
            const Divider(),
            ListTile(
              title: const Text('Déconnexion'),
              leading: const Icon(Icons.logout),
              onTap: logOut,
            ),
          ],
        ),
      ),
    );
  }
}
