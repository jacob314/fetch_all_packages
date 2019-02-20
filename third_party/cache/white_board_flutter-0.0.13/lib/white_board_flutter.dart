library white_board_flutter;

import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

/// 白板类型
enum BoardType {
  /// 主白板类型
  main,

  /// 迷你白板类型
  mini,

  /// 辅助白板类型（放大镜）
  assist
}

/// 笔类型
enum PenType {
  /// 常规画笔
  normal,

  /// 常规马克笔
  mark,

  /// 激光笔
  laser
}

/// 输入模式
enum InputMode {
  /// 笔输入模式
  pen,

  /// 橡皮输入模式
  erase,

  /// 选择输入模式
  select,
}

/// 白板指令
enum BoardCommand {
  /// 绘制命令
  draw,

  /// 擦除命令
  erase,

  @deprecated
  enterZoom,

  @deprecated
  leaveZoom,

  /// 旋转命令
  rotate,

  /// 保存文档命令
  save,

  /// 白板下一页命令
  pageDown,

  /// 白板上一页命令
  pageUp,

  /// 白板跳转页到指定页号命令
  gotoPage,

  /// 文档下一页命令
  widgetPageDown,

  /// 文档上一页命令
  widgetPageUp,

  /// 删除文档命令
  delete,

  /// 新建白板页命令
  newPage,

  @deprecated
  OnTopicChange,

  @deprecated
  EnableVideo,

  @deprecated
  DisableVideo,

  @deprecated
  backPassServer,

  @deprecated
  actionStatusMove,

  /// 白板插入第一页命令
  insertFirstPage,

  /// 白板在指定id页后插入新页命令
  insertPage,

  /// 白板移除指定id的页的命令
  removePage,
}

/// 白板插件通道
class WhiteBoardFlutter {
  static const MethodChannel _channel =
      const MethodChannel('white_board_flutter');

  static final _WhiteBoardMethodCallHandler handler =
      _WhiteBoardMethodCallHandler();

  /// 添加白板事件监听器
  ///
  /// [listener]监听器对象
  static addWhiteBoardListener(WhiteBoardListener listener) {
    handler._listeners.add(listener);
  }

  /// 移除白板事件监听器
  ///
  /// [listener]监听器对象
  static removeWhiteBoardListener(WhiteBoardListener listener) {
    handler._listeners.remove(listener);
  }

  /// 创建渲染器
  static Future<int> _createRenderer(
      BoardType type, int width, int height) async {
    final int textureId = await _channel.invokeMethod(
        "create", {"type": type.index, "width": width, "height": height});

    return textureId;
  }

  /// 改变白板类型
  static _changeBoardType(int textureId, BoardType type) =>
      _channel.invokeMethod(
          "changeBoardType", {"textureId": textureId, "type": type.index});

  /// 更新渲染器大小
  static _updateRenderer(int textureId, int width, int height) =>
      _channel.invokeMethod(
          "update", {"textureId": textureId, "width": width, "height": height});

  /// 关闭渲染器
  static _closeRenderer(int textureId) =>
      _channel.invokeMethod("close", {"textureId": textureId});

  /// 传递手势事件
  static _onTouch(Map<String, dynamic> event) =>
      _channel.invokeMethod("touch", event);

  /// 设置服务器地址配置
  ///
  /// [name]服务名，[protocol]协议，[host]主机地址，[port]端口号
  static setServerConfig(
          String name, String protocol, String host, String port) =>
      _channel.invokeMethod("addServerConfig",
          {"name": name, "protocol": protocol, "host": host, "port": port});

  /// 登录
  ///
  /// [accountId]用户账户id，[sessionId]用户会话id
  static login(String accountId, String sessionId) => _channel
      .invokeMethod("login", {"accountId": accountId, "sessionId": sessionId});

  /// 退出登录
  static logout() => _channel.invokeMethod("logout");

  /// 加入房间
  ///
  /// [roomId]房间id
  static joinRoom(String roomId) =>
      _channel.invokeMethod("joinRoom", {"roomId": roomId});

  /// 离开房间
  ///
  /// [roomId]房间id
  static leaveRoom(String roomId) =>
      _channel.invokeMethod("leaveRoom", {"roomId": roomId});

  /// 设置放大镜缩放率
  ///
  /// [scale]新的缩放比例
  static setMagnifyScale(double scale) =>
      _channel.invokeMethod("setMagnifyScale", {"scale": scale});

  /// 获取当前放大镜缩放比例
  static Future<double> getMagnifyScale() async {
    final double scale = await _channel.invokeMethod("getMagnifyScale");
    return scale;
  }

  /// 向白板插入文件
  ///
  /// [path]文件地址
  static insertFile(String path) =>
      _channel.invokeMethod("insertFile", {"path": path});

  /// 向白板插入云盘文件
  ///
  /// [resId]资源id，[name]文件名，[md5]MD5值，[width]、[height]文件宽高
  static insertCloudFile(
          String resId, String name, String md5, int width, int height) =>
      _channel.invokeMethod("insertCloudFile", {
        "resId": resId,
        "name": name,
        "md5": md5,
        "width": width,
        "height": height
      });

  /// 更改画笔样式
  ///
  /// [type]画笔类型
  /// [color]画笔颜色
  /// [size]画笔粗细
  static updatePenStyle(PenType type, Color color, int size) =>
      _channel.invokeMethod("updatePenStyle",
          {"type": type.index, "color": _colorToString(color), "size": size});

  /// 改变输入模式
  ///
  /// [mode]模式
  static updateInputMode(InputMode mode) =>
      _channel.invokeMethod("updateInputMode", {"mode": mode.index});

  /// 向白板发送指令
  ///
  /// [command]指令，[param]参数
  static boardCommand(BoardCommand command, [String param]) => _channel
      .invokeMethod("boardCommand", {"command": command.index, "param": param});

  /// 打开放大镜
  ///
  /// [mainOffset]放大镜遮挡主白板的高度
  static openMagnifier(double mainOffset) =>
      _channel.invokeMethod("openMagnifier", {"mainOffset": mainOffset});

  /// 关闭放大镜
  static closeMagnifier() => _channel.invokeMethod("closeMagnifier");

  /// 放大镜移动到下一个位置
  static zoomMoveNext() => _channel.invokeMethod("zoomMoveNext");

  /// 放大镜移动到上一个位置
  static zoomMoveLast() => _channel.invokeMethod("zoomMoveLast");

  /// 放大镜移动到下一行
  static zoomMoveNewLine() => _channel.invokeMethod("zoomMoveNewLine");

  /// 发送聊天消息
  ///
  /// [message]消息完整结构
  static sendChatMessage(String message) =>
      _channel.invokeMethod("sendChatMessage", {"message": message});

  /// 获取聊天消息
  ///
  /// [roomId]聊天房间id，[messageId]起始消息id（用于分片加载）
  static Future<String> getChatMessages(int roomId, [String messageId]) async {
    final message = await _channel.invokeMethod(
        "getChatMessages", {"roomId": roomId, "messageId": messageId});

    return message;
  }

  /// 发送一个ping帧
  static sendPing() => _channel.invokeMethod("sendPing");

  /// 加入聊天房间
  ///
  /// [roomId]房间id
  static joinChatRoom(int roomId) =>
      _channel.invokeMethod("joinChatRoom", {"roomId": roomId});

  /// 离开聊天房间
  ///
  /// [roomId]房间id
  static leaveChatRoom(int roomId) =>
      _channel.invokeMethod("leaveChatRoom", {"roomId": roomId});

  /// 离开全屏模式
  static leaveFullScreen() => _channel.invokeMethod("leaveFullScreen");

  /// 向白板插入文字
  ///
  /// [textContent]文字内容描述，[textContent.id]为空表示新插入，[textContent.id]非空表示更新旧内容
  /// (旧内容由[onTextEdit]回调返回)
  static insertText(TextContent textContent) =>
      _channel.invokeMethod("insertText", {
        "id": textContent.id,
        "targetId": textContent.targetId,
        "text": textContent.text,
        "color": _colorToString(textContent.color),
        "backgroundColor": _colorToString(textContent.backgroundColor),
        "size": textContent.size
      });

  /// 删除文字
  ///
  /// [id]文字id，[targetId]宿主id
  static deleteText(String id, String targetId) =>
      _channel.invokeMethod("deleteText", {"id": id, "targetId": targetId});

  /// 白板截图
  ///
  /// 截图成功返回图片路径，截图失败返回null
  static Future<String> screenshots() async {
    final String path = await _channel.invokeMethod("screenshots");

    return path;
  }

  /// 移除直播流
  ///
  /// [videoId]直播流id，当前是sessionId
  /// 目前添加直播流由音视频插件实现
  static removeLiveVideo(String videoId) {
    return _channel.invokeMethod("removeLiveVideo", {"videoId": videoId});
  }
}

/// 白板插件通道消息处理器
class _WhiteBoardMethodCallHandler {
  /// 监听器集合
  final _listeners = List<WhiteBoardListener>();

  _WhiteBoardMethodCallHandler() {
    WhiteBoardFlutter._channel.setMethodCallHandler(_handler);
  }

  /// 处理器
  Future<dynamic> _handler(MethodCall call) async {
    _listeners.forEach((listener) {
      switch (call.method) {
        case "onLoginSuccess":
          if (listener.onLoginSuccess != null) {
            listener.onLoginSuccess();
          }
          break;
        case "onDisconnect":
          if (listener.onDisconnect != null) {
            listener.onDisconnect(
                call.arguments["code"], call.arguments["error"]);
          }
          break;
        case "onReceiveChatMessage":
          if (listener.onReceiveChatMessage != null) {
            listener.onReceiveChatMessage(call.arguments["message"]);
          }
          break;
        case "onReceiveChatAck":
          if (listener.onReceiveChatAck != null) {
            listener.onReceiveChatAck(call.arguments["ack"]);
          }
          break;
        case "onUserList":
          if (listener.onUserList != null) {
            listener.onUserList(call.arguments
                .map<WhiteBoardUser>((user) => WhiteBoardUser(
                    user["accountId"],
                    user["name"],
                    user["avatar"],
                    user["sessionId"],
                    user["isOnline"]))
                .toList());
          }
          break;
        case "onUserJoin":
          if (listener.onUserJoin != null) {
            listener.onUserJoin(
                call.arguments["accountId"], call.arguments["sessionId"]);
          }
          break;
        case "onUserLeave":
          if (listener.onUserLeave != null) {
            listener.onUserLeave(
                call.arguments["accountId"], call.arguments["sessionId"]);
          }
          break;
        case "onPageList":
          if (listener.onPageList != null) {
            listener.onPageList(call.arguments
                .map<WhiteBoardPageInfo>((page) => WhiteBoardPageInfo(
                    page["pageNumber"],
                    page["pageId"],
                    page["documentId"],
                    page["title"]))
                .toList());
          }
          break;
        case "onPageNumberChanged":
          if (listener.onPageNumberChanged != null) {
            listener.onPageNumberChanged(call.arguments["currentPageNumber"],
                call.arguments["totalPageNumber"]);
          }
          break;
        case "onWidgetNumberChange":
          if (listener.onWidgetNumberChange != null) {
            listener.onWidgetNumberChange(call.arguments["currentPageNumber"],
                call.arguments["totalPageNumber"], call.arguments["flipable"]);
          }
          break;
        case "onEnterSingleViewMode":
          if (listener.onEnterSingleViewMode != null) {
            listener.onEnterSingleViewMode(WidgetInfo(
                WidgetType.values[call.arguments["widgetType"]],
                call.arguments["id"],
                call.arguments["name"],
                call.arguments["actions"]
                    .map<BoardCommand>((action) => BoardCommand.values[action])
                    .toList(),
                call.arguments["currentPageNumber"],
                call.arguments["pageCount"],
                call.arguments["isFlip"]));
          }
          break;
        case "onLeaveSingleViewMode":
          if (listener.onLeaveSingleViewMode != null) {
            listener.onLeaveSingleViewMode();
          }
          break;
        case "onTextEdit":
          if (listener.onTextEdit != null) {
            listener.onTextEdit(TextContent._fromChannel(
                call.arguments["id"],
                call.arguments["targetId"],
                call.arguments["text"],
                _stringToColor(call.arguments["color"]),
                _stringToColor(call.arguments["backgroundColor"]),
                call.arguments["size"]));
          }
          break;
        case "onSaveFile":
          if (listener.onSaveFile != null) {
            listener.onSaveFile(call.arguments["name"], call.arguments["path"],
                call.arguments["resourceId"]);
          }
          break;
      }
    });
  }
}

/// 白板消息监听器
class WhiteBoardListener {
  /// 白板登录成功
  final VoidCallback onLoginSuccess;

  /// 白板断开连接（包括主动退出登录）
  ///
  /// [code]错误码，[error]错误信息
  final void Function(int code, String error) onDisconnect;

  /// 收到新聊天消息
  ///
  /// [message]完整消息结构
  final void Function(String message) onReceiveChatMessage;

  /// 收到消息回执
  ///
  /// [ack]完整回执结构
  final void Function(String ack) onReceiveChatAck;

  /// 白板中的用户列表
  ///
  /// [userList]白板成员列表
  final void Function(List<WhiteBoardUser> userList) onUserList;

  /// 有用户加入
  ///
  /// [accountId]用户id，[sessionId]用户会话id
  final void Function(String accountId, String sessionId) onUserJoin;

  /// 有用户离开
  ///
  /// [accountId]用户id，[sessionId]用户会话id
  final void Function(String accountId, String sessionId) onUserLeave;

  /// 白板页信息
  ///
  /// [pageList]页信息集合
  final void Function(List<WhiteBoardPageInfo> pageList) onPageList;

  /// 白板页改变
  ///
  /// [currentPageNumber]当前页号，[totalPageNumber]总页数
  final void Function(int currentPageNumber, int totalPageNumber)
      onPageNumberChanged;

  /// 白板文档页改变
  ///
  /// [currentPageNumber]当前页号，[totalPageNumber]总页数,[flipable]表示是否可以翻页
  final void Function(int currentPageNumber, int totalPageNumber, bool flipable)
      onWidgetNumberChange;

  /// 进入文档全屏模式
  ///
  /// [widgetInfo]文档信息
  final void Function(WidgetInfo widgetInfo) onEnterSingleViewMode;

  /// 离开文档全屏模式
  final VoidCallback onLeaveSingleViewMode;

  /// 收到文字编辑请求
  ///
  /// [textContent]旧文字描述
  final void Function(TextContent textContent) onTextEdit;

  /// 收到保存请求的文件信息回调
  ///
  /// 由[BoardCommand.save]指令触发，[name]文档名称，[path]文件路径，[resourceId]文件资源id
  final void Function(String name, String path, String resourceId) onSaveFile;

  WhiteBoardListener(
      {this.onLoginSuccess,
      this.onDisconnect,
      this.onReceiveChatMessage,
      this.onReceiveChatAck,
      this.onUserList,
      this.onUserJoin,
      this.onUserLeave,
      this.onPageList,
      this.onPageNumberChanged,
      this.onWidgetNumberChange,
      this.onEnterSingleViewMode,
      this.onLeaveSingleViewMode,
      this.onTextEdit,
      this.onSaveFile});
}

/// 白板用户数据结构
class WhiteBoardUser {
  /// 用户id
  final String accountId;

  /// 用户昵称
  final String name;

  /// 用户头像
  final String avatar;

  /// 用户会话id
  String sessionId;

  /// 是否在线
  bool isOnline;

  WhiteBoardUser(
      this.accountId, this.name, this.avatar, this.sessionId, this.isOnline);
}

/// 白板页信息
class WhiteBoardPageInfo {
  /// 页号
  final int pageNumber;

  /// 页id
  final String pageId;

  /// 所属文档id
  final String documentId;

  /// 页标题
  final String title;

  WhiteBoardPageInfo(this.pageNumber, this.pageId, this.documentId, this.title);
}

/// 文档类型
enum WidgetType {
  /// 文档（pdf）
  office,

  /// 图片
  image,

  /// 便签
  memo,
}

/// 文档信息
class WidgetInfo {
  /// 文档类型
  final WidgetType widgetType;

  /// 文件id
  final String id;

  /// 文件名称
  final String name;

  /// 当前支持的功能
  final List<BoardCommand> actions;

  /// 当前页码
  final int currentPageNumber;

  /// 总页数
  final int pageCount;

  /// 是否可以翻页
  final bool isFlip;

  WidgetInfo(this.widgetType, this.id, this.name, this.actions,
      this.currentPageNumber, this.pageCount, this.isFlip);
}

/// 颜色对象转换为'#00000000' 8位格式的字符串表示
String _colorToString(Color color) =>
    "#${color.value.toRadixString(16).padLeft(8, '0')}";

/// '#00000000' 8位格式的字符串表示转换为颜色对象
Color _stringToColor(String color) =>
    Color(int.tryParse(color.substring(1), radix: 16));

/// 文字内容
class TextContent {
  /// 文本id
  final String id;

  /// 宿主id
  final String targetId;

  /// 文本内容
  String text;

  /// 文本颜色
  Color color;

  /// 背景色
  Color backgroundColor;

  /// 文字大小
  int size;

  /// 构造函数
  TextContent(
      {this.text,
      this.color = Colors.black,
      this.backgroundColor = Colors.transparent,
      this.size = 40})
      : id = null,
        targetId = null;

  /// 由通道返回
  TextContent._fromChannel(
    this.id,
    this.targetId,
    this.text,
    this.color,
    this.backgroundColor,
    this.size,
  );
}

/// 白板创建完成回调
typedef WhiteBoardCreated = void Function(int width, int height);

/// 白板控件
class WhiteBoardWidget extends StatefulWidget {
  /// 白板类型
  ///
  /// 参考[boardTypeMain],[boardTypeMini],[boardTypeAssist]，
  /// 默认为[boardTypeMain]
  final BoardType boardType;

  /// 白板创建完成回调
  final WhiteBoardCreated whiteBoardCreated;

  /// 构建白板控件
  const WhiteBoardWidget(
      {Key key, this.boardType = BoardType.main, this.whiteBoardCreated})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => WhiteBoardState();
}

/// 白板控件状态
class WhiteBoardState extends State<WhiteBoardWidget> {
  /// 纹理表面id
  int _textureId;

  /// 白板类型
  BoardType _type;

  /// 白板类型
  BoardType get type => _type;

  /// 宽度
  int _width = 0;

  /// 宽度
  int get width => _width;

  /// 高度
  int _height = 0;

  /// 高度
  int get height => _height;

  /// 手势坐标系缩放X
  double _scaleX = 0.0;

  /// 手势坐标系缩放Y
  double _scaleY = 0.0;

  @override
  void initState() {
    super.initState();
    _type = widget.boardType;
  }

  @override
  void dispose() {
    super.dispose();
    if (_textureId != null) {
      WhiteBoardFlutter._closeRenderer(_textureId);
    }
  }

  /// 初始化白板
  _initBoard(Size size) async {
    final width = (size.width * ui.window.devicePixelRatio).toInt();
    final height = (size.height * ui.window.devicePixelRatio).toInt();

    if (_textureId == null) {
      _width = width;
      _height = height;

      _textureId =
          await WhiteBoardFlutter._createRenderer(_type, _width, _height);
      if (widget.whiteBoardCreated != null) {
        widget.whiteBoardCreated(_width, _height);
      }

      _scaleX = 1 / size.width;
      _scaleY = 1 / size.height;
      setState(() {});

      return;
    }

    var needRefresh = false;

    if (_type != widget.boardType) {
      _type = widget.boardType;
      WhiteBoardFlutter._changeBoardType(_textureId, _type);
      needRefresh = true;
    }

    if (_width != width || _height != height) {
      _width = width;
      _height = height;

      await WhiteBoardFlutter._updateRenderer(_textureId, _width, _height);

      _scaleX = 1 / size.width;
      _scaleY = 1 / size.height;
      needRefresh = true;
    }

    if (needRefresh) {
      setState(() {});
    }
  }

  /// 处理手势输入
  _onTouch(BuildContext context, PointerEvent event) {
    if (_scaleX * _scaleY <= 0 || _textureId == null) {
      return;
    }

    var action = -1;

    if (event is PointerDownEvent) {
      action = 0;
    } else if (event is PointerUpEvent) {
      action = 1;
    } else if (event is PointerMoveEvent) {
      action = 2;
    } else if (event is PointerCancelEvent) {
      action = 3;
    }

    var tool = -1;

    switch (event.kind) {
      case PointerDeviceKind.stylus:
        tool = 0;
        break;
      case PointerDeviceKind.touch:
        tool = 1;
        break;
      default:
        tool = -1;
        break;
    }

    final RenderBox renderBox = context.findRenderObject();

    final localOffset = renderBox.globalToLocal(event.position);

    final x = localOffset.dx * _scaleX;
    final y = localOffset.dy * _scaleY;

    WhiteBoardFlutter._onTouch({
      "textureId": _textureId,
      "action": action,
      "tool": tool,
      "pointerId": event.device,
      "x": x,
      "y": y,
      "pressure": event.pressure,
      "eventTime": event.timeStamp.inMilliseconds
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _initBoard(constraints.biggest);
        return Listener(
          onPointerDown: (event) => _onTouch(context, event),
          onPointerMove: (event) => _onTouch(context, event),
          onPointerUp: (event) => _onTouch(context, event),
          onPointerCancel: (event) => _onTouch(context, event),
          child: _textureId != null ? Texture(textureId: _textureId) : null,
        );
      },
    );
  }
}
