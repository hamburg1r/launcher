import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:launcher/widgets/applist.dart';
import 'package:sheet/sheet.dart';

void main() {
  runApp(
    ProviderScope(
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme lightColorScheme;
        ColorScheme darkColorScheme;

        if (lightDynamic != null && darkDynamic != null) {
          // On Android S+ devices, use the provided dynamic color scheme.
          // (Recommended) Harmonize the dynamic color scheme' built-in semantic colors.
          lightColorScheme = lightDynamic.harmonized();
          // (Optional) Customize the scheme as desired. For example, one might
          // want to use a brand color to override the dynamic [ColorScheme.secondary].
          // lightColorScheme = lightColorScheme.copyWith(secondary: _brandBlue);
          // (Optional) If applicable, harmonize custom colors.
          // lightCustomColors = lightCustomColors.harmonized(lightColorScheme);

          // Repeat for the dark color scheme.
          darkColorScheme = darkDynamic.harmonized();
          // darkColorScheme = darkColorScheme.copyWith(secondary: _brandBlue);
          // darkCustomColors = darkCustomColors.harmonized(darkColorScheme);

          // _isDemoUsingDynamicColors = true; // ignore, only for demo purposes
        } else {
          // Otherwise, use fallback schemes.
          lightColorScheme = ColorScheme.fromSeed(
            seedColor: Colors.blueAccent,
          );
          darkColorScheme = ColorScheme.fromSeed(
            seedColor: Colors.blueAccent,
            brightness: Brightness.dark,
          );
        }
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "NoteQuest",
          theme: ThemeData(
            // primaryColor: MaterialAccentColor(accentColor),
            colorScheme: lightColorScheme,
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: darkColorScheme,
            useMaterial3: true,
          ),
          themeMode: ThemeMode.system,
          home: Home(
            title: 'demo',
          ),
        );
      },
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  SheetController controller = SheetController();

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    print('Dragged!! ${details.primaryDelta}');
    if (details.delta.dy < -10) {
      // Significant upward drag
      setState(() {
        controller.relativeAnimateTo(
          1,
          duration: Duration(milliseconds: 800),
          curve: Curves.bounceOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          GestureDetector(
            onVerticalDragUpdate: _onVerticalDragUpdate,
          ),
          Sheet(
            initialExtent: 0,
            fit: SheetFit.expand,
            controller: controller,
            physics: SnapSheetPhysics(stops: [0, 1], relative: true),
            child: Container(
              // TODO: light theme
              color: Colors.grey[840],
              child: AppList(),
              // child: ListView.builder(
              //   itemBuilder: (ctx, index) => ListTile(
              //     title: Text(index.toString()),
              //   ),
              // ),
            ),
          ),
        ],
      ),
    );
  }
}

// class AppList extends StatelessWidget {
//   const AppList({
//     super.key,
//     // required this.apps,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     List<Application> apps = [];
//     return GridView.builder(
//       itemCount: apps.length,
//       gridDelegate:
//           SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
//       itemBuilder: (context, index) {
//         final app = apps[index];
//         return GestureDetector(
//           onTap: () => DeviceApps.openApp(app.packageName),
//           child: Column(
//             children: [
//               Image.memory(
//                   app is ApplicationWithIcon ? app.icon : Uint8List(0)),
//               Text(app.appName),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
