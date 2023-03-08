import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:reflective_ui_flutter/page_content.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        fontFamily: 'Poppins',
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background_1.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 4,
              sigmaY: 4,
            ),
            child: Container(
              color: Colors.transparent,
            ),
          ),
          ColorFiltered(
            colorFilter: const ColorFilter.mode(
              Colors.black,
              BlendMode.srcOut,
            ), // This one will create the magic
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    backgroundBlendMode: BlendMode.dstOut,
                  ), // This one will handle background + difference out
                ),
                const PageContent(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.black,
  //     body: Stack(
  //       children: [
  //         Container(
  //           height: double.infinity,
  //           width: double.infinity,
  //           decoration: const BoxDecoration(
  //             image: DecorationImage(
  //               image: AssetImage('assets/background.jpg'),
  //               fit: BoxFit.cover,
  //             ),
  //           ),
  //         ),
  //         Center(
  //           child: SizedBox(
  //             height: 120,
  //             width: 277,
  //             child: ShaderMask(
  //               shaderCallback: (bounds) =>
  //                   const LinearGradient(colors: [Colors.white, Colors.white])
  //                       .createShader(bounds),
  //               blendMode: BlendMode.srcOut,
  //               child: const Text(
  //                 'Reflective\nFlutter',
  //                 style: TextStyle(
  //                   color: Colors.white,
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: 55.0,
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //         Container(
  //           height: double.infinity,
  //           width: double.infinity,
  //           color: Colors.white,
  //         )
  //       ],
  //     ),
  //   );
  // }
}
