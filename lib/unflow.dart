import 'dart:async';

import 'package:flutter/services.dart';
import 'package:unflow_flutter/opener.dart';

class Unflow {
  static final Unflow instance = Unflow();

  static const MethodChannel _channel = MethodChannel('unflow');

  //TODO rename to initialize, and support enableLogging
  Future<void> setApiKey({required String apiKey}) async {
    final params = <String, dynamic>{'apiKey': apiKey};
    await _channel.invokeMethod('unflow#setApiKey', params);
  }

  Future<void> sync() async {
    await _channel.invokeMethod('unflow#sync');
  }

  Future<void> setUserId({required String userId}) async {
    final params = <String, dynamic>{'userId': userId};
    await _channel.invokeMethod('unflow#setUserId', params);
  }

  // TODO: missing implementation on native side
  Future<void> setAttributes({required Map<String, dynamic> attributes}) async {
    await _channel.invokeMethod('unflow#setAttributes', attributes);
  }

  Future<void> openScreen({required String screenId}) async {
    final params = <String, dynamic>{'screenId': screenId};
    await _channel.invokeMethod('unflow#openScreen', params);
  }

  Future<List<Opener>> getOpeners() async {
    final openers = await _channel.invokeMethod('unflow#getOpeners');
    if (openers != null) {
      openers.map((opener) => Opener.fromJson(Map<String, dynamic>.from(opener)));
    }
    return [];
  }

  //TODO missing implementations
  // analyticsListener
  // setCustomFonts
  // trackEvent
}