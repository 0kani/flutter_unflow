package com.unflow.unflow_flutter

import android.app.Activity
import android.util.Log
import androidx.annotation.NonNull
import com.unflow.analytics.AnalyticsListener
import com.unflow.analytics.domain.model.UnflowEvent
import com.unflow.androidsdk.UnflowSdk

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class UnflowFlutterPlugin: FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler, ActivityAware {
  private val mainScope = CoroutineScope(Dispatchers.Main)
  private lateinit var channel : MethodChannel
  private lateinit var eventChannel : EventChannel
  private lateinit var activity: Activity
  private var eventSink: EventChannel.EventSink? = null
  private var unflowStarted = false

  override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
    eventSink = events
  }

  override fun onCancel(arguments: Any?) {
    eventSink = null
  }

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "unflow")
    channel.setMethodCallHandler(this)
    eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "unflow_events")
    eventChannel.setStreamHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when(call.method) {
      "unflow#initialize" -> {
        val apiKey = call.argument<String>("apiKey")
        val enableLogging = call.argument<Boolean>("enableLogging") ?: false
        if(apiKey != null) {
          try {
            val unflowAnalyticsListener = object : AnalyticsListener {
              override fun onEvent(event: UnflowEvent) {
                val map = mutableMapOf<String, Any?>()
                map["id"] = event.id
                map["name"] = event.name
                map["occurred_at"] = event.occurredAt
                map["screen_id"] = event.metadata["screen_id"]
                map["rating"] = event.metadata["rating"]
                eventSink?.success(map)
              }
            }

            UnflowSdk.initialize(
              application = activity.application,
              config = UnflowSdk.Config(apiKey, enableLogging = enableLogging),
              activityProvider = CurrentActivityProvider { activity },
              analyticsListener = unflowAnalyticsListener
            )

            unflowStarted = true
            result.success(null)

          } catch (e: Exception) {
            // Must be safe
          }
        }
        else {
          result.error("apiKey is missing", null, null)
        }
      }
      "unflow#sync" -> {
        if(unflowStarted) {
          try {
            UnflowSdk.client().sync()
          } catch (e: Exception) {
            // Must be safe
          }
          result.success(null)
        } else {
          result.error("Unflow not started", null, null)
        }
      }
      "unflow#setUserId" -> {
        if(unflowStarted) {
          val userId = call.argument<String>("userId")
          if(userId != null) {
            UnflowSdk.client().setUserId(userId)
            result.success(null)
          }
          else {
            result.error("userId is missing", null, null)
          }
        } else {
          result.error("Unflow not started", null, null)
        }
      }
      "unflow#setAttributes" -> {
        if(unflowStarted) {
          if(call.arguments != null) {
            // TODO: implements and test the way to collect the attributes from dart
            // UnflowSdk.client().setAttributes(call.arguments)
            result.error("not implemented", null, null)
          }
          else {
            result.error("attributes are missing", null, null)
          }
        } else {
          result.error("Unflow not started", null, null)
        }
      }
      "unflow#openScreen" -> {
        if(unflowStarted) {
          val screenId = call.argument<String>("screenId")
          if(screenId != null) {
            UnflowSdk.client().openScreen(screenId.toLong())
            result.success(null)
          }
          else {
            result.error("screenId is missing", null, null)
          }
        } else {
          result.error("Unflow not started", null, null)
        }
      }
      "unflow#getOpeners" -> {
        if(unflowStarted) {
          mainScope.launch {
            withContext(Dispatchers.IO) {
              UnflowSdk.client().openers().collect { openers ->
                val items = mutableListOf<Map<String, Any?>>()
                openers.forEach {
                  val map = mutableMapOf<String, Any?>()
                  map["id"] = it.screenId.toInt()
                  map["title"] = it.title
                  map["priority"] = it.priority
                  map["subtitle"] = it.subtitle
                  map["imageURL"] = it.imageUrl
                  items.add(map)
                }
                try {
                  result.success(items)
                } catch (e: java.lang.Exception) {
                  // it's to avoid error on a second call, the SDK is calling to collect two times the openers
                }
              }
            }
          }
        } else {
          result.error("Unflow not started", null, null)
        }
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    onAttachedToActivity(binding)
  }

  override fun onDetachedFromActivityForConfigChanges() {}

  override fun onDetachedFromActivity() {}
}
