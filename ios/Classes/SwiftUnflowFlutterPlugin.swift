import Flutter
import UIKit
import UnflowUI

public class SwiftUnflowFlutterPlugin: NSObject, FlutterPlugin, FlutterStreamHandler, AnalyticsListener {
  var unflowStarted = false
  var eventSink: FlutterEventSink?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let instance = SwiftUnflowFlutterPlugin()
    let channel = FlutterMethodChannel(name: "unflow", binaryMessenger: registrar.messenger())
    registrar.addMethodCallDelegate(instance, channel: channel)
    let eventChannel = FlutterEventChannel(name: "unflow_events", binaryMessenger: registrar.messenger())
    eventChannel.setStreamHandler(instance)
  }

  public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
      eventSink = events
    return nil
  }
  
  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
      eventSink = nil
    return nil
  }
    
  public func onEvent(event: UnflowEvent) {
      let unflowEvent = [
          "id": event.id,
          "name": event.name,
          "occurred_at": event.occuredAt,
      ] as [String : Any?]      
      eventSink?(unflowEvent)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
        case "unflow#initialize":
            if #available(iOS 13.0, *) {
                let arguments = call.arguments as? NSDictionary
                guard let apiKey = arguments?["apiKey"] as? String else {
                    result(FlutterError(code: "apiKey is missing", message: nil, details: nil))
                    return
                }
                let enableLogging = arguments?["enableLogging"] as? Bool ?? false
                _ = UnflowSDK.initialize(
                    config: UnflowSDK.Config(apiKey: apiKey, enableLogging: enableLogging),
                    analyticsListener: self
                )
                unflowStarted = true
            }
            result(nil)
        case "unflow#sync":
            if (unflowStarted) {
                if #available(iOS 13.0, *) {
                    UnflowSDK.client.sync()
                }
                result(nil)
            }
            else {
                result(FlutterError(code: "Unflow not started", message: nil, details: nil))
            }
        case "unflow#setUserId":
            let arguments = call.arguments as? NSDictionary
            guard let userId = arguments?["userId"] as? String else {
                result(FlutterError(code: "userId is missing", message: nil, details: nil))
                return
            }
            if (unflowStarted) {
                if #available(iOS 13.0, *) {
                    UnflowSDK.client.setUserId(userId: userId)
                }
                result(nil)
            }
            else {
                result(FlutterError(code: "Unflow not started", message: nil, details: nil))
            }
            result(nil)
        case "unflow#openScreen":
            let arguments = call.arguments as? NSDictionary
            guard let screenId = arguments?["screenId"] as? String else {
                result(FlutterError(code: "screenId missing", message: nil, details: nil))
                return
            }
            if (unflowStarted) {
                if #available(iOS 13.0, *) {
                    do {
                        try UnflowSDK.client.openScreen(withID: (screenId as NSString).integerValue)
                    } catch {}
                }
                result(nil)
            }
            else {
                result(FlutterError(code: "Unflow not started", message: nil, details: nil))
            }
        case "unflow#getOpeners":
            if (unflowStarted) {
                if #available(iOS 13.0, *) {                    
                    let _ = UnflowSDK.client.openers(id: "default")
                        .sink { openers in
                            let mappedOpeners = openers.map {
                                [
                                    "id": $0.id,
                                    "title": $0.title,
                                    "priority": $0.priority,
                                    "subtitle": $0.subtitle,
                                    "imageURL": $0.imageURL
                                ] as [String : Any?]
                            }
                            result(mappedOpeners)
                        }
                }
            }
            else {
                result(FlutterError(code: "Unflow not started", message: nil, details: nil))
            }
        default:
            result(FlutterMethodNotImplemented)
    }
  }
}
