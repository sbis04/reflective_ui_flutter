import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reflective_ui_flutter/page_content.dart';

late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.dark;
  void changeTheme(ThemeMode themeMode) {
    setState(() => _themeMode = themeMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        fontFamily: 'Poppins',
        primaryColor: Colors.white,
        colorScheme: const ColorScheme.light(
          brightness: Brightness.light,
          secondary: Colors.black12,
        ),
      ),
      darkTheme: ThemeData(
        fontFamily: 'Poppins',
        primaryColor: Colors.black,
        colorScheme: const ColorScheme.light(
          brightness: Brightness.dark,
          secondary: Colors.white12,
        ),
      ),
      themeMode: _themeMode,
      debugShowCheckedModeBanner: false,
      home: HomePage(
        updateTheme: () => changeTheme(
          _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.updateTheme});

  final Function updateTheme;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  CameraController? controller;

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller?.dispose();
    }
    controller = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      enableAudio: false,
    );

    // If the controller is updated then update the UI.
    controller!.addListener(() {
      if (mounted) setState(() {});
      if (controller!.value.hasError) {
        // print('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller!.initialize();
    } on CameraException {
      // _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void startCamera() {
    controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // Observe the app states
    WidgetsBinding.instance.addObserver(this);

    var cameraIndex = 0;
    if (_cameras.length > 1) {
      cameraIndex = kIsWeb ? 1 : 0;
    }
    controller = CameraController(
      _cameras[cameraIndex],
      ResolutionPreset.high,
      enableAudio: false,
    );
    startCamera();
  }

  @override
  void dispose() {
    // Remove the app states observer
    WidgetsBinding.instance.removeObserver(this);

    controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      onNewCameraSelected(cameraController.description);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Theme.of(context).primaryColor,
      statusBarColor: Colors.transparent,
      statusBarBrightness: Theme.of(context).brightness,
      statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark
          ? Brightness.light
          : Brightness.dark,
    ));
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: controller != null && controller!.value.isInitialized
          ? Stack(
              fit: StackFit.expand,
              children: [
                CameraPreview(controller!),
                BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 4,
                    sigmaY: 4,
                  ),
                  child: Container(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).primaryColor,
                    BlendMode.srcOut,
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          backgroundBlendMode: BlendMode.dstOut,
                        ),
                      ),
                      PageContent(onThemeToggle: widget.updateTheme),
                    ],
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
