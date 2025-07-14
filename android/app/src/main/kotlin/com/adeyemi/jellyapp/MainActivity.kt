package com.adeyemi.jellyapp

import android.app.Activity.RESULT_OK
import android.content.Intent
import android.media.projection.MediaProjectionManager
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val REQUEST_CODE_SCREEN_CAPTURE = 1001
    private lateinit var projectionManager: MediaProjectionManager
    private var pendingResult: MethodChannel.Result? = null
    private var lastRecordedPath: String? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        flutterEngine
            .platformViewsController
            .registry
            .registerViewFactory("combined_camera_view", CombinedCameraViewFactory())

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "dual_camera_channel")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "startRecording" -> {
                        println("##################### starting recorder")
                        pendingResult = result
                        startScreenCaptureIntent()
                    }
                    "stopRecording" -> {
                        println("##################### stopping recorder")
                        ScreenRecorder.stop()
                        result.success(lastRecordedPath ?: "No file recorded")
                    }
                }
            }
    }

    private fun startScreenCaptureIntent() {
        projectionManager = getSystemService(MEDIA_PROJECTION_SERVICE) as MediaProjectionManager
        val captureIntent = projectionManager.createScreenCaptureIntent()
        startActivityForResult(captureIntent, REQUEST_CODE_SCREEN_CAPTURE)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        if (requestCode == REQUEST_CODE_SCREEN_CAPTURE && resultCode == RESULT_OK && data != null) {
            val filePath = filesDir.absolutePath + "/combined_preview.mp4"
            lastRecordedPath = filePath

            // Start the foreground service first
            val serviceIntent = Intent(this, ScreenCaptureService::class.java)
            ContextCompat.startForegroundService(this, serviceIntent)

            // Delay screen recording to give service time to start
            Handler(Looper.getMainLooper()).postDelayed({
                ScreenRecorder.start(this, projectionManager, resultCode, data, filePath)
                pendingResult?.success("Recording started")
            }, 500) // Wait 500ms for foreground service to stabilize
        }
    }
}
