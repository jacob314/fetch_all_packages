package com.latitech.whiteboardflutter

import android.graphics.SurfaceTexture
import android.opengl.EGL14
import android.opengl.EGLConfig
import android.opengl.EGLDisplay
import android.opengl.EGLSurface
import com.latitech.sdk.whiteboard.core.WhiteBoardRenderer
import io.flutter.plugin.common.MethodCall

/**
 * flutter专用白板渲染器
 *
 * @author 超悟空
 * @version 1.0 2018/10/18
 * @since 1.0 2018/10/18
 *
 * @property texture 渲染表面
 * @param width 初始宽度
 * @param height 初始高度
 * @param type 白板类型
 * @property createSuccess Surface创建完成回调
 **/
class WhiteBoardFlutterRenderer(private val texture: SurfaceTexture, width: Int, height: Int,
                                type: Int = BOARD_TYPE_MAIN, private var createSuccess: (() -> Unit)? = null) : WhiteBoardRenderer() {

    init {
        boardWidth = width
        boardHeight = height
        boardType = type
        init()
    }

    /**
     * 更新白板大小
     */
    fun updateSize(width: Int, height: Int) {
        texture.setDefaultBufferSize(width, height)
        boardWidth = width
        boardHeight = height
        updateSurface()
    }

    /**
     * 处理手势事件
     */
    fun onTouch(call: MethodCall) {
        val action = when (call.argument<Int>("action")) {
            0 -> NATIVE_ACTION_DOWN
            1 -> NATIVE_ACTION_UP
            2 -> NATIVE_ACTION_MOVE
            3 -> NATIVE_ACTION_CANCEL
            else -> -1
        }

        val toolType = when (call.argument<Int>("tool")) {
            0 -> NATIVE_TOOL_TYPE_STYLUS
            1 -> NATIVE_TOOL_TYPE_FINGER
            else -> -1
        }

        if (action < 0 || toolType < 0) {
            return
        }

        nativeTouchEventInput(TAG, toolType, action, call.argument("pointerId")!!, call.argument("x")
        !!, call.argument("y")!!, call.argument("pressure")!!, call.argument("eventTime")!!)
    }

    override fun onCreateSurface(p0: EGLDisplay, p1: EGLConfig): EGLSurface =
            EGL14.eglCreateWindowSurface(p0, p1, texture, intArrayOf(EGL14.EGL_NONE), 0)

    override fun onRelease() {
        super.onRelease()
        texture.release()
    }

    override fun onSurfaceCreated() {
        super.onSurfaceCreated()
        createSuccess?.let {
            it()
            createSuccess = null
        }
    }
}