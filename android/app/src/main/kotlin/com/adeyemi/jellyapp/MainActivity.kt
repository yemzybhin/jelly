package com.adeyemi.jellyapp

import android.app.Activity.RESULT_OK
import android.content.Intent
import android.media.projection.MediaProjectionManager
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        flutterEngine
            .platformViewsController
            .registry
            .registerViewFactory(
                "split-camera-view",
                SplitCameraViewFactory()
            )

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "split_camera_channel")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "startRecording" -> {
                        Log.d("SplitCamera", "Recording auto-starts via init()")
                        result.success(null)
                    }

                    "stopRecording" -> {
                        SplitCameraController.stopRecording()
                        result.success(null)
                    }

                    else -> result.notImplemented()
                }
            }
    }
}

