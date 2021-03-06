import 'dart:async';

import 'package:flutter/services.dart';
import 'package:unflow_flutter/opener.dart';
import 'package:unflow_flutter/unflow_event.dart';

class Unflow {
  static final Unflow instance = Unflow();

  static const MethodChannel _channel = MethodChannel('unflow');
  static const EventChannel _eventChannel = EventChannel('unflow_events');

  Stream<UnflowEvent> get unflowAnalyticsStream async* {
    await for (dynamic event in _eventChannel.receiveBroadcastStream().map((event) => event)) {
      yield UnflowEvent.fromJson(event);
    }
  }

  Future<void> initialize({required String apiKey, required bool enableLogging}) async {
    final params = <String, dynamic>{'apiKey': apiKey, 'enableLogging': enableLogging};
    await _channel.invokeMethod('unflow#initialize', params);
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
    List<Opener> list = [];
    for (var opener in openers) {
      list.add(Opener.fromJson(Map<String, dynamic>.from(opener)));
    }
    return list;
  }

  //TODO missing implementations
  // setCustomFonts
  // trackEvent
}
