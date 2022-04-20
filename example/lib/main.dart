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
    Unflow.instance.initialize(apiKey: 'UNFLOW_API_KEY', enableLogging: false);
    Unflow.instance.sync();

    // TODO: make example using analytics
    // Unflow.instance.unflowAnalyticsStream.listen((UnflowEvent event) {});

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
          child: TextButton(onPressed: open, child: Text('Abrir screen')),
        ),
      ),
    );
  }
}

void open() {
  Unflow.instance.openScreen(screenId: "SCREEN_ID");
}
