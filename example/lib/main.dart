import 'dart:async';

import 'package:flutter/material.dart';
import 'package:unflow_flutter/unflow.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    Unflow.instance.initialize(apiKey: 'YOUR_UNFLOW_KEY', enableLogging: true);
    Unflow.instance.sync();

    // TODO: make example open screen with button
    // Unflow.instance.openScreen(screenId: "SCREEN_ID");

    // TODO: make example displaying openers
    // var openers = Unflow.instance.getOpeners();

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Unflow example app'),
        ),
        body: const Center(
          child: Text('Hello'),
        ),
      ),
    );
  }
}
