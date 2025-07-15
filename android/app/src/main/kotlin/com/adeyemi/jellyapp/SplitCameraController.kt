package com.adeyemi.jellyapp

import android.content.Context
import android.hardware.camera2.*
import android.media.MediaRecorder
import android.os.Environment
import android.util.Log
import android.view.Surface
import android.view.TextureView
import java.io.File
import java.text.SimpleDateFormat
import java.util.*

object SplitCameraController {

    private const val TAG = "SplitCamera"

    private var cameraManager: CameraManager? = null

    private var frontCameraId: String? = null
    private var backCameraId: String? = null

    private var frontRecorder: MediaRecorder? = null
    private var backRecorder: MediaRecorder? = null

    private var frontSession: CameraCaptureSession? = null
    private var backSession: CameraCaptureSession? = null

    private var frontDevice: CameraDevice? = null
    private var backDevice: CameraDevice? = null

    private var frontView: TextureView? = null
    private var backView: TextureView? = null

    private lateinit var frontFile: File
    private lateinit var backFile: File

    fun init(context: Context, front: TextureView, back: TextureView) {
        frontView = front
        backView = back
        cameraManager = context.getSystemService(Context.CAMERA_SERVICE) as CameraManager

        for (id in cameraManager!!.cameraIdList) {
            val characteristics = cameraManager!!.getCameraCharacteristics(id)
            val facing = characteristics.get(CameraCharacteristics.LENS_FACING)
            if (facing == CameraCharacteristics.LENS_FACING_FRONT) {
                frontCameraId = id
            } else if (facing == CameraCharacteristics.LENS_FACING_BACK) {
                backCameraId = id
            }
        }

        frontView?.post {
            openCamera(context, frontCameraId!!, frontView!!, isFront = true)
        }

        backView?.post {
            openCamera(context, backCameraId!!, backView!!, isFront = false)
        }
    }

    private fun openCamera(context: Context, cameraId: String, view: TextureView, isFront: Boolean) {
        cameraManager?.openCamera(cameraId, object : CameraDevice.StateCallback() {
            override fun onOpened(camera: CameraDevice) {
                if (isFront) {
                    frontDevice = camera
                } else {
                    backDevice = camera
                }
                setupRecorderAndPreview(context, camera, view, isFront)
            }

            override fun onDisconnected(camera: CameraDevice) {
                camera.close()
            }

            override fun onError(camera: CameraDevice, error: Int) {
                camera.close()
            }
        }, null)
    }

    private fun setupRecorderAndPreview(context: Context, camera: CameraDevice, view: TextureView, isFront: Boolean) {
        val timestamp = SimpleDateFormat("yyyyMMdd_HHmmss", Locale.getDefault()).format(Date())
        val baseName = "SplitCam_$timestamp"
        val dir = context.getExternalFilesDir(Environment.DIRECTORY_MOVIES) ?: context.filesDir
        dir.mkdirs()

        val outputFile = File(dir, "${baseName}_${if (isFront) "Front" else "Back"}.mp4")

        if (isFront) frontFile = outputFile else backFile = outputFile

        Log.d(TAG, "Output path: ${outputFile.absolutePath}")

        val recorder = MediaRecorder()
        recorder.setAudioSource(MediaRecorder.AudioSource.MIC)
        recorder.setVideoSource(MediaRecorder.VideoSource.SURFACE)
        recorder.setOutputFormat(MediaRecorder.OutputFormat.MPEG_4)
        recorder.setOutputFile(outputFile.absolutePath)
        recorder.setVideoEncodingBitRate(10000000)
        recorder.setVideoFrameRate(30)
        recorder.setVideoSize(1280, 720)
        recorder.setVideoEncoder(MediaRecorder.VideoEncoder.H264)
        recorder.setAudioEncoder(MediaRecorder.AudioEncoder.AAC)

        try {
            recorder.prepare()
        } catch (e: Exception) {
            Log.e(TAG, "Recorder prepare failed (${if (isFront) "Front" else "Back"}): ${e.message}")
            return
        }

        val surfaceTexture = view.surfaceTexture!!
        surfaceTexture.setDefaultBufferSize(1280, 720)
        val previewSurface = Surface(surfaceTexture)
        val recorderSurface = recorder.surface

        val surfaces = listOf(previewSurface, recorderSurface)

        camera.createCaptureSession(surfaces, object : CameraCaptureSession.StateCallback() {
            override fun onConfigured(session: CameraCaptureSession) {
                val builder = camera.createCaptureRequest(CameraDevice.TEMPLATE_RECORD)
                builder.addTarget(previewSurface)
                builder.addTarget(recorderSurface)

                session.setRepeatingRequest(builder.build(), null, null)

                recorder.start()
                Log.d(TAG, "${if (isFront) "Front" else "Back"} recording started")

                if (isFront) {
                    frontSession = session
                    frontRecorder = recorder
                } else {
                    backSession = session
                    backRecorder = recorder
                }
            }

            override fun onConfigureFailed(session: CameraCaptureSession) {
                Log.e(TAG, "Capture session configuration failed (${if (isFront) "Front" else "Back"})")
            }
        }, null)
    }

    fun stopRecording() {
        try {
            frontRecorder?.stop()
            frontRecorder?.release()
            Log.d(TAG, "Front recording stopped: ${frontFile.absolutePath}")
        } catch (e: Exception) {
            Log.e(TAG, "Front stop failed: ${e.message}")
        }
        frontRecorder = null

        try {
            backRecorder?.stop()
            backRecorder?.release()
            Log.d(TAG, "Back recording stopped: ${backFile.absolutePath}")
        } catch (e: Exception) {
            Log.e(TAG, "Back stop failed: ${e.message}")
        }
        backRecorder = null
    }
}
