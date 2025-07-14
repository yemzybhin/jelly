package com.adeyemi.jellyapp
import android.app.Service
import android.content.Intent
import android.os.IBinder
import androidx.core.app.NotificationCompat

class ScreenCaptureService : Service() {
    override fun onBind(intent: Intent?): IBinder? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val notification = NotificationCompat.Builder(this, "screen_record_channel")
            .setContentTitle("Screen Recording")
            .setContentText("Recording your screen...")
            .setSmallIcon(android.R.drawable.ic_btn_speak_now)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .build()

        startForeground(1001, notification)

        // Notify MainActivity that service is ready
        sendBroadcast(Intent("screen_capture_service_ready"))

        return START_NOT_STICKY
    }
}
