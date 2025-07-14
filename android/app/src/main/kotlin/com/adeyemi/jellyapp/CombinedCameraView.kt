package com.adeyemi.jellyapp

import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import android.graphics.*
import android.hardware.camera2.*
import android.view.*
import android.widget.FrameLayout
import androidx.core.app.ActivityCompat
import io.flutter.plugin.platform.PlatformView

class CombinedCameraView(private val context: Context) : PlatformView {

    private val layout = FrameLayout(context)
    private val frontTextureView = TextureView(context)
    private val backTextureView = TextureView(context)
    private var frontCamera: CameraDevice? = null
    private var backCamera: CameraDevice? = null
    private var frontSession: CameraCaptureSession? = null
    private var backSession: CameraCaptureSession? = null

    init {
        layout.layoutParams = FrameLayout.LayoutParams(
            FrameLayout.LayoutParams.MATCH_PARENT,
            FrameLayout.LayoutParams.MATCH_PARENT
        )

        frontTextureView.layoutParams = FrameLayout.LayoutParams(
            FrameLayout.LayoutParams.MATCH_PARENT,
            FrameLayout.LayoutParams.MATCH_PARENT
        )

        backTextureView.layoutParams = FrameLayout.LayoutParams(
            FrameLayout.LayoutParams.MATCH_PARENT,
            FrameLayout.LayoutParams.MATCH_PARENT
        )

        layout.addView(backTextureView)   // bottom half on top
        layout.addView(frontTextureView)  // top half on top

        frontTextureView.surfaceTextureListener = createSurfaceListener(CameraCharacteristics.LENS_FACING_FRONT)
        backTextureView.surfaceTextureListener = createSurfaceListener(CameraCharacteristics.LENS_FACING_BACK)

        layout.post {
            applyClipping()
        }
    }

    private fun applyClipping() {
        val height = layout.height
        val width = layout.width

        // Show top half of front camera
        frontTextureView.clipBounds = Rect(0, 0, width, height / 2)

        // Show bottom half of back camera
        backTextureView.clipBounds = Rect(0, height / 2, width, height)
    }

    private fun createSurfaceListener(facing: Int): TextureView.SurfaceTextureListener {
        return object : TextureView.SurfaceTextureListener {
            override fun onSurfaceTextureAvailable(surface: SurfaceTexture, width: Int, height: Int) {
                openCamera(facing)
            }

            override fun onSurfaceTextureSizeChanged(surface: SurfaceTexture, width: Int, height: Int) {}
            override fun onSurfaceTextureDestroyed(surface: SurfaceTexture): Boolean = true
            override fun onSurfaceTextureUpdated(surface: SurfaceTexture) {}
        }
    }

    private fun openCamera(facing: Int) {
        val manager = context.getSystemService(Context.CAMERA_SERVICE) as CameraManager

        for (id in manager.cameraIdList) {
            val characteristics = manager.getCameraCharacteristics(id)
            if (characteristics.get(CameraCharacteristics.LENS_FACING) == facing) {
                if (ActivityCompat.checkSelfPermission(context, Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED) {
                    return
                }

                manager.openCamera(id, object : CameraDevice.StateCallback() {
                    override fun onOpened(camera: CameraDevice) {
                        if (facing == CameraCharacteristics.LENS_FACING_FRONT) {
                            frontCamera = camera
                            startPreview(camera, frontTextureView) { frontSession = it }
                        } else {
                            backCamera = camera
                            startPreview(camera, backTextureView) { backSession = it }
                        }
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

    private fun startPreview(camera: CameraDevice, textureView: TextureView, onReady: (CameraCaptureSession) -> Unit) {
        val surfaceTexture = textureView.surfaceTexture ?: return
        surfaceTexture.setDefaultBufferSize(1280, 720)
        val surface = Surface(surfaceTexture)

        try {
            val requestBuilder = camera.createCaptureRequest(CameraDevice.TEMPLATE_PREVIEW)
            requestBuilder.addTarget(surface)

            camera.createCaptureSession(listOf(surface), object : CameraCaptureSession.StateCallback() {
                override fun onConfigured(session: CameraCaptureSession) {
                    requestBuilder.set(CaptureRequest.CONTROL_MODE, CameraMetadata.CONTROL_MODE_AUTO)
                    session.setRepeatingRequest(requestBuilder.build(), null, null)
                    onReady(session)
                }

                override fun onConfigureFailed(session: CameraCaptureSession) {}
            }, null)
        } catch (e: CameraAccessException) {
            e.printStackTrace()
        }
    }

    override fun getView(): View = layout

    override fun dispose() {
        frontSession?.close()
        frontCamera?.close()
        backSession?.close()
        backCamera?.close()
    }
}
