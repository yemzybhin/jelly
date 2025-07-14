package com.adeyemi.jellyapp

import android.app.Activity
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.content.Intent
import android.hardware.display.DisplayManager
import android.hardware.display.VirtualDisplay
import android.media.MediaRecorder
import android.media.projection.MediaProjection
import android.media.projection.MediaProjectionManager
import android.os.Build
import android.os.Environment
import android.util.DisplayMetrics
import android.view.Surface

object ScreenRecorder {
    private var mediaProjection: MediaProjection? = null
    private var mediaRecorder: MediaRecorder? = null
    private var virtualDisplay: VirtualDisplay? = null
    private var lastFilePath: String? = null

    fun start(
        activity: Activity,
        projectionManager: MediaProjectionManager,
        resultCode: Int,
        data: Intent,
        outputPath: String
    ) {
        val metrics = DisplayMetrics().also {
            activity.windowManager.defaultDisplay.getRealMetrics(it)
        }

        val width = metrics.widthPixels
        val height = metrics.heightPixels
        val dpi = metrics.densityDpi

        mediaRecorder = MediaRecorder().apply {
            setVideoSource(MediaRecorder.VideoSource.SURFACE)
            setOutputFormat(MediaRecorder.OutputFormat.MPEG_4)
            setVideoEncoder(MediaRecorder.VideoEncoder.H264)
            setVideoSize(width, height)
            setVideoFrameRate(30)
            setVideoEncodingBitRate(5 * 1024 * 1024)
            setOutputFile(outputPath)
            prepare()
        }

        mediaProjection = projectionManager.getMediaProjection(resultCode, data)
        mediaProjection?.registerCallback(object : MediaProjection.Callback() {
            override fun onStop() {
                stop()
            }
        }, null)

        val surface: Surface = mediaRecorder!!.surface

        virtualDisplay = mediaProjection!!.createVirtualDisplay(
            "CombinedCameraCapture",
            width, height, dpi,
            DisplayManager.VIRTUAL_DISPLAY_FLAG_AUTO_MIRROR,
            surface, null, null
        )

        mediaRecorder!!.start()
    }


    fun stop(): String? {
        try {
            mediaRecorder?.stop()
        } catch (_: Exception) {}
        mediaRecorder?.release()
        virtualDisplay?.release()
        mediaProjection?.stop()

        val output = lastFilePath
        mediaRecorder = null
        virtualDisplay = null
        mediaProjection = null
        lastFilePath = null

        return output
    }
}
