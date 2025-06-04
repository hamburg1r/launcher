import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';

class AppList extends StatefulWidget {
  const AppList({super.key});

  @override
  State<AppList> createState() => _AppListState();
}

class _AppListState extends State<AppList> {
  late Future<List<Application>> _appsFuture;
  Stream<ApplicationEvent>? _appEvents;

  @override
  void initState() {
    super.initState();
    _loadApps();

    // Start listening to app changes
    DeviceApps.listenToAppsChanges().listen((event) {
      debugPrint("App change detected: ${event.event} - ${event.packageName}");
      _loadApps(); // Reload app list on any change
      setState(() {}); // Trigger UI refresh
    });
  }

  void _loadApps() {
    _appsFuture = DeviceApps.getInstalledApplications(
      includeAppIcons: true,
      includeSystemApps: false,
      onlyAppsWithLaunchIntent: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Application>>(
      future: _appsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final apps = snapshot.data ?? [];

        return GridView.builder(
          itemCount: apps.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
          ),
          itemBuilder: (context, index) {
            final app = apps[index];
            return GestureDetector(
              onTap: () => DeviceApps.openApp(app.packageName),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (app is ApplicationWithIcon)
                    Image.memory(app.icon, width: 48, height: 48)
                  else
                    const SizedBox(width: 48, height: 48),
                  Text(app.appName, overflow: TextOverflow.ellipsis),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
