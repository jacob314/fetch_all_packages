package com.latitech.whiteboardflutter

import android.graphics.Bitmap
import android.graphics.Color
import android.util.LongSparseArray
import com.latitech.sdk.whiteboard.WhiteBoardAPI
import com.latitech.sdk.whiteboard.listener.OnChatMessageListener
import com.latitech.sdk.whiteboard.listener.OnNetworkStateListener
import com.latitech.sdk.whiteboard.listener.OnWhiteBoardChangeListener
import com.latitech.sdk.whiteboard.model.TextContent
import com.latitech.sdk.whiteboard.model.WhiteBoardPageInfo
import com.latitech.sdk.whiteboard.model.WhiteBoardUser
import com.latitech.sdk.whiteboard.model.WidgetInfo
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import io.flutter.view.TextureRegistry
import java.io.File


class WhiteBoardFlutterPlugin(private val textures: TextureRegistry) : MethodCallHandler {

    /**
     * 渲染器缓存
     */
    private val renders = LongSparseArray<WhiteBoardFlutterRenderer>()

    companion object {

        private const val TAG = "WhiteBoardFlutterPlugin"

        /**
         * 文件缓存目录
         */
        private var cacheDir: File? = null

        /**
         * 文本数据集合
         */
        private val textContentRegistry = hashMapOf<String, TextContent>()

        @JvmStatic
        fun registerWith(registrar: Registrar) {
            cacheDir = registrar.context().externalCacheDir ?: registrar.context().cacheDir
            WhiteBoardAPI.init(registrar.activeContext(), true)
            val channel = MethodChannel(registrar.messenger(), "white_board_flutter")
            channel.setMethodCallHandler(WhiteBoardFlutterPlugin(registrar.textures()))
            onWhiteBoardChangeListener(channel)
            onNetworkChangeListener(channel)
            onChatMessageListener(channel)
        }

        /**
         * 注册白板改变事件
         */
        private fun onWhiteBoardChangeListener(channel: MethodChannel) {
            WhiteBoardAPI.addOnWhiteBoardChangeListener(TAG, object : OnWhiteBoardChangeListener {
                override fun onUserLeave(p0: String, p1: String) {
                    channel.invokeMethod("onUserLeave", mapOf("accountId" to p0, "sessionId" to p1))
                }

                override fun onTextContent(p0: TextContent) {
                    textContentRegistry[p0.id] = p0

                    channel.invokeMethod("onTextEdit",
                            mapOf("id" to p0.id,
                                    "targetId" to p0.targetId,
                                    "text" to p0.text,
                                    "color" to "#%08x".format(p0.color),
                                    "backgroundColor" to "#%08x"
                                            .format(p0.backgroundColor),
                                    "size" to p0.size))
                }

                override fun onLeaveSingleViewMode() {
                    channel.invokeMethod("onLeaveSingleViewMode", null)
                }

                override fun onPageNumberChanged(p0: Int, p1: Int) {
                    channel.invokeMethod("onPageNumberChanged",
                            mapOf("currentPageNumber" to p0, "totalPageNumber" to p1))
                }

                override fun onUserList(p0: Array<out WhiteBoardUser>) {
                    channel.invokeMethod("onUserList", p0.map {
                        mapOf("accountId" to it.accountId,
                                "sessionId" to it.sessionId,
                                "name" to it.name,
                                "avatar" to it.avatar,
                                "isOnline" to it.isOnline)
                    })
                }

                override fun onUserJoin(p0: String, p1: String) {
                    channel.invokeMethod("onUserJoin", mapOf("accountId" to p0, "sessionId" to p1))
                }

                override fun onEnterSingleViewMode(p0: WidgetInfo) {
                    channel.invokeMethod("onEnterSingleViewMode",
                            mapOf("widgetType" to p0.widgetType,
                                    "id" to p0.id,
                                    "name" to p0.name,
                                    "currentPageNumber" to p0.currentPageNumber,
                                    "pageCount" to p0.pageCount,
                                    "isFlip" to p0.isFlip,
                                    "actions" to p0.actions))
                }

                override fun onSaveFile(p0: String?, p1: String?, p2: String?) {
                    channel.invokeMethod("onSaveFile",
                            mapOf("path" to p0,
                                    "resourceId" to p1,
                                    "name" to p2))
                }

                override fun onWidgetNumberChange(p0: Int, p1: Int, p2: Boolean) {
                    channel.invokeMethod("onWidgetNumberChange",
                            mapOf("currentPageNumber" to p0,
                                    "totalPageNumber" to p1,
                                    "flipable" to p2))
                }

                override fun onPageList(p0: Array<out WhiteBoardPageInfo>) {
                    channel.invokeMethod("onPageList",
                            p0.map {
                                mapOf("pageNumber" to it.pageNumber,
                                        "pageId" to it.pageId,
                                        "documentId" to it.documentId,
                                        "title" to it.title)
                            })
                }
            })
        }

        /**
         * 注册网络改变事件
         */
        private fun onNetworkChangeListener(channel: MethodChannel) {
            WhiteBoardAPI.addOnNetworkStateListener(TAG, object : OnNetworkStateListener {
                override fun onLoginSuccess() {
                    channel.invokeMethod("onLoginSuccess", null)
                }

                override fun onDisconnect(p0: Int, p1: String?) {
                    channel.invokeMethod("onDisconnect",
                            mapOf("code" to p0,
                                    "error" to p1))
                }
            })
        }

        /**
         * 注册聊天消息事件
         */
        private fun onChatMessageListener(channel: MethodChannel) {
            WhiteBoardAPI.addOnChatMessageListener(TAG, object : OnChatMessageListener {
                override fun onReceiveNewMessage(p0: String) {
                    channel.invokeMethod("onReceiveChatMessage", mapOf("message" to p0))
                }

                override fun onReceiveAck(p0: String) {
                    channel.invokeMethod("onReceiveChatAck", mapOf("ack" to p0))
                }
            })
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "addServerConfig" -> {
                WhiteBoardAPI.addServerConfig(call.argument("name"), call.argument("protocol"),
                        call.argument("host"), call.argument("port"))
                result.success(null)
            }
            "login" -> {
                WhiteBoardAPI.login(call.argument("accountId"), call.argument("sessionId"))
                result.success(null)
            }
            "logout" -> {
                WhiteBoardAPI.logout()
                result.success(null)
            }
            "joinRoom" -> {
                WhiteBoardAPI.joinRoom(call.argument("roomId"))
                result.success(null)
            }
            "leaveRoom" -> {
                WhiteBoardAPI.leaveRoom(call.argument("roomId"))
                result.success(null)
            }
            "create" -> {
                val entry = textures.createSurfaceTexture()
                val surfaceTexture = entry.surfaceTexture()

                val width = call.argument<Int>("width")!!
                val height = call.argument<Int>("height")!!

                surfaceTexture.setDefaultBufferSize(width, height)

                renders.put(entry.id(), WhiteBoardFlutterRenderer(surfaceTexture, width, height,
                        call.argument("type")!!) { result.success(entry.id()) })
            }
            "update" -> {

                renders.get(call.argument<Number>("textureId")!!.toLong())?.updateSize(call.argument("width")!!, call.argument("height")!!)
                result.success(null)
            }
            "changeBoardType" -> {
                renders.get(call.argument<Number>("textureId")!!.toLong())?.boardType = call.argument("type")!!
                result.success(null)
            }
            "close" -> {
                val textureId = call.argument<Number>("textureId")!!.toLong()
                renders.get(textureId)?.release()
                renders.delete(textureId)
                result.success(null)
            }
            "touch" -> {
                renders.get(call.argument<Number>("textureId")!!.toLong())?.onTouch(call)
                result.success(null)
            }
            "setMagnifyScale" -> {
                WhiteBoardAPI.setMagnifyScale(call.argument("scale")!!)
                result.success(null)
            }
            "getMagnifyScale" -> {
                result.success(WhiteBoardAPI.getMagnifyScale())
            }
            "insertFile" -> {
                WhiteBoardAPI.insertFile(call.argument("path"))
                result.success(null)
            }
            "insertCloudFile" -> {
                WhiteBoardAPI.insertCloudFile(call.argument("resId"), call.argument("name"), call
                        .argument("md5"), call.argument("width")!!, call.argument("height")!!)
                result.success(null)
            }
            "updatePenStyle" -> {
                WhiteBoardAPI.updatePenStyle(call.argument("type")!!, call.argument("color"), call
                        .argument("size")!!)
                result.success(null)
            }
            "updateInputMode" -> {
                WhiteBoardAPI.updateInputMode(call.argument("mode")!!)
                result.success(null)
            }
            "boardCommand" -> {
                WhiteBoardAPI.boardCommand(call.argument("command")!!, call.argument("param"))
                result.success(null)
            }
            "openMagnifier" -> {
                WhiteBoardAPI.openMagnifier(call.argument("mainOffset")!!)
                result.success(null)
            }
            "closeMagnifier" -> {
                WhiteBoardAPI.closeMagnifier()
                result.success(null)
            }
            "zoomMoveNext" -> {
                WhiteBoardAPI.zoomMoveNext()
                result.success(null)
            }
            "zoomMoveLast" -> {
                WhiteBoardAPI.zoomMoveLast()
                result.success(null)
            }
            "zoomMoveNewLine" -> {
                WhiteBoardAPI.zoomMoveNewLine()
                result.success(null)
            }
            "sendChatMessage" -> {
                WhiteBoardAPI.sendChatMessage(call.argument("message"))
                result.success(null)
            }
            "getChatMessages" -> {
                WhiteBoardAPI.getChatMessages(call.argument<Number>("roomId")!!.toLong(), call.argument("messageId")) {
                    result.success(it)
                }
            }
            "sendPing" -> {
                WhiteBoardAPI.sendPing()
                result.success(null)
            }
            "joinChatRoom" -> {
                WhiteBoardAPI.joinChatRoom(call.argument<Number>("roomId")!!.toLong())
                result.success(null)
            }
            "leaveChatRoom" -> {
                WhiteBoardAPI.leaveChatRoom(call.argument<Number>("roomId")!!.toLong())
                result.success(null)
            }
            "leaveFullScreen" -> {
                WhiteBoardAPI.leaveFullScreen()
                result.success(null)
            }
            "insertText" -> {
                val id = call.argument<String>("id")
                val textContent = textContentRegistry[id] ?: TextContent()
                textContentRegistry.remove(id)
                textContent.text = call.argument("text")!!
                textContent.color = call.argument<String>("color")?.let { Color.parseColor(it) } ?: textContent.color
                textContent.backgroundColor = call.argument<String>("backgroundColor")?.let { Color.parseColor(it) } ?: textContent.backgroundColor
                textContent.size = call.argument("size") ?: textContent.size

                WhiteBoardAPI.insertText(textContent)
                result.success(null)
            }
            "deleteText" -> {
                WhiteBoardAPI.deleteText(call.argument("id"), call.argument("targetId"))
                result.success(null)
            }
            "screenshots" -> {
                WhiteBoardAPI.screenshots { bitmap ->
                    if (bitmap == null) {
                        result.success(null)
                    } else {
                        val file = File(cacheDir, "${System.currentTimeMillis()}.jpg")

                        file.outputStream().use {
                            bitmap.compress(Bitmap.CompressFormat.JPEG, 100, it)
                        }

                        result.success(file.path)
                    }
                }
            }
            "removeLiveVideo" -> {
                WhiteBoardAPI.removeLiveVideo(call.argument("videoId"))
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }
}
