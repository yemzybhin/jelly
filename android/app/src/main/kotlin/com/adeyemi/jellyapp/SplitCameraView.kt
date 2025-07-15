package com.adeyemi.jellyapp
import android.content.Context
import android.view.TextureView
import android.view.View
import android.widget.FrameLayout
import android.widget.LinearLayout
import io.flutter.plugin.platform.PlatformView

class SplitCameraView(context: Context) : PlatformView {

    private val layout: FrameLayout = FrameLayout(context)
    private val frontView = TextureView(context)
    private val backView = TextureView(context)

    init {
        layout.layoutParams = FrameLayout.LayoutParams(
            FrameLayout.LayoutParams.MATCH_PARENT,
            FrameLayout.LayoutParams.MATCH_PARENT
        )

        val linearLayout = LinearLayout(context).apply {
            orientation = LinearLayout.VERTICAL
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.MATCH_PARENT
            )
            weightSum = 2f
        }

        frontView.layoutParams = LinearLayout.LayoutParams(
            LinearLayout.LayoutParams.MATCH_PARENT,
            0,
            1f
        )

        backView.layoutParams = LinearLayout.LayoutParams(
            LinearLayout.LayoutParams.MATCH_PARENT,
            0,
            1f
        )

        linearLayout.addView(frontView)
        linearLayout.addView(backView)
        layout.addView(linearLayout)

        SplitCameraController.init(context, frontView, backView)
    }

    override fun getView(): View = layout
    override fun dispose() {}
}
