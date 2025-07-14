package com.adeyemi.jellyapp

import android.content.Context
import android.hardware.camera2.*
import android.media.MediaRecorder
import android.util.Log
import android.view.Surface

class Camera2Recorder(
    private val context: Context,
    private val lensFacing: Int
) {
    private var cameraDevice: CameraDevice? = null
    private var captureSession: CameraCaptureSession? = null
    private var mediaRecorder: MediaRecorder? = null
    private var isRecording = false

    private val cameraManager = context.getSystemService(Context.CAMERA_SERVICE) as CameraManager

    fun startRecording(filePath: String) {
        if (isRecording) return
        isRecording = true

        for (id in cameraManager.cameraIdList) {
            val characteristics = cameraManager.getCameraCharacteristics(id)
            val facing = characteristics.get(CameraCharacteristics.LENS_FACING)
            if (facing == lensFacing) {
                cameraManager.openCamera(id, object : CameraDevice.StateCallback() {
                    override fun onOpened(camera: CameraDevice) {
                        cameraDevice = camera
                        startCaptureSession(filePath)
                    }

                    override fun onDisconnected(camera: CameraDevice) {
                        camera.close()
                    }

                    override fun onError(camera: CameraDevice, error: Int) {
                        camera.close()
                    }
                }, null)
                break
            }
        }
    }

    private fun startCaptureSession(filePath: String) {
        mediaRecorder = MediaRecorder().apply {
            setVideoSource(MediaRecorder.VideoSource.SURFACE)
            setOutputFormat(MediaRecorder.OutputFormat.MPEG_4)
            setOutputFile(filePath)
            setVideoEncoder(MediaRecorder.VideoEncoder.H264)
            setVideoEncodingBitRate(5_000_000)
            setVideoFrameRate(30)
            setVideoSize(1280, 720)
            prepare()
        }

        val surface = mediaRecorder!!.surface
        val requestBuilder = cameraDevice!!.createCaptureRequest(CameraDevice.TEMPLATE_RECORD)
        requestBuilder.addTarget(surface)

        cameraDevice!!.createCaptureSession(listOf(surface), object : CameraCaptureSession.StateCallback() {
            override fun onConfigured(session: CameraCaptureSession) {
                captureSession = session
                session.setRepeatingRequest(requestBuilder.build(), null, null)
                mediaRecorder?.start()
            }

            override fun onConfigureFailed(session: CameraCaptureSession) {}
        }, null)
    }

    fun stopRecording() {
        if (!isRecording) return
        isRecording = false

        try {
            mediaRecorder?.stop()
        } catch (e: Exception) {
            Log.e("Recorder", "Stop error: ${e.message}")
        }
        mediaRecorder?.release()
        captureSession?.close()
        cameraDevice?.close()
    }
}
