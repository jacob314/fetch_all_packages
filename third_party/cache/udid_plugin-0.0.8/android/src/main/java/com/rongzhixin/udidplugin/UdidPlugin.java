package com.rongzhixin.udidplugin;

import android.util.Log;
import android.app.Activity;

import com.authreal.api.AuthBuilder;
import com.authreal.api.FormatException;
import com.authreal.api.OnResultListener;
import com.authreal.component.AuthComponentFactory;
import com.authreal.component.CompareItemFactory;
import com.authreal.component.CompareItemSession;

import org.json.JSONException;
import org.json.JSONObject;

import java.text.SimpleDateFormat;
import java.util.Date;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** UdidPlugin */
public class UdidPlugin implements MethodCallHandler {
  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "udid_plugin");
    channel.setMethodCallHandler(new UdidPlugin(registrar.activity()));
  }

  private UdidPlugin(Activity activity) {
        this.activity = activity;
  }

  private Activity activity;
  private Result pendingResult;

  private  String  authKey = "pubKey";
  private String  urlNotify = "";

  @Override
  public void onMethodCall(MethodCall call, Result result) {

    pendingResult = result;

    if (call.method.equals("getPlatformVersion")) {
      pendingResult.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if (call.method.equals("startOCRFlow")) {
      startOCRFlow();
      pendingResult.success(null);
    } else if (call.method.equals("startLivenessFlow")) {
      startLivenessFlow();
      pendingResult.success(null);
    } else if (call.method.equals("startIDAuthFlow")) {
      startIDAuthFlow();
      pendingResult.success(null);
    } else if (call.method.equals("startCompareFlow")) {
      startCompareFlow();
      pendingResult.success(null);
    } else if (call.method.equals("startVideoFlow")) {
      startIDAuthFlow();
      pendingResult.success(null);
    } else if (call.method.equals("startCustomFlow")) {
      startIDAuthFlow();
      pendingResult.success(null);
    } else {
      pendingResult.notImplemented();
    }
  }

  public void startOCRFlow() {
      /** 获取AuthBuilder对象 请每次开始流程获取最新对象 */
      getAuthBuilder()
              /** 添加 身份证ocr识别 模块
                *
                *  非必须添加
                *  是否需要添加该模块，根据自己业务需要来判断
                *  执行顺序和添加顺序一致。如有疑问，请联系有盾对接人员
                *
                * */
              .addFollow(AuthComponentFactory.getOcrComponent()
                              /**设置展示确认页面 ： 非必需 */
                              .showConfirm(true)
                              /**设置展示确认页面 ： 非必需 */
                              .mosaicIdName(false)
                              /**设置展示确认页面 ： 非必需 */
                              .mosaicIdNumber(false)
                              /**设置异步通知地址 ： 非必需 */
                              .setNotifyUrl("http:......")
                      //更多设置项目参见文档：http://static.udcredit.com/doc/idsafe/android/V43/index.html
              )
              /** 开始流程
                * 请传入 Activity 对象
                * */
              .start(activity);
  }

  public void startLivenessFlow() {
      /** 获取AuthBuilder对象 请每次开始流程获取最新对象 */
      getAuthBuilder()
              /** 添加 活体检测 模块
                *
                *  非必须添加
                *  是否需要添加该模块，根据自己业务需要来判断
                *  执行顺序和添加顺序一致。如有疑问，请联系有盾对接人员
                *
                * */
              .addFollow(AuthComponentFactory.getLivingComponent()
                              /** 声音开关 该方法已废弃*/
                              //                                .setVoiceEnable(false)
                              /**设置异步通知地址 ： 非必需 */
                              .setNotifyUrl("http:......")
                      //更多设置项目参见文档：http://static.udcredit.com/doc/idsafe/android/V43/index.html
              )
              /** 开始流程
                * 请传入 Activity 对象
                * */
              .start(activity);
  }

  public void startIDAuthFlow() {
      /** 获取AuthBuilder对象 请每次开始流程获取最新对象 */
      getAuthBuilder()
              /**
                * 人脸比对模块
                *
                */
              .addFollow(AuthComponentFactory.getCompareFaceComponent()
                      // 此示例对比项A为OCR人像图片
                      .setCompareItemA(CompareItemFactory.getCompareItemBySessionId(CompareItemSession.SessionType.PHOTO_IDENTIFICATION))
                      //此示例对比项B为活体过程中截图
                      .setCompareItemB(CompareItemFactory.getCompareItemBySessionId(CompareItemSession.SessionType.PHOTO_LIVING))
                      //设置异步通知地址 ： 非必需
                      .setNotifyUrl("http:......"))
              /** 开始流程
                * 请传入 Activity 对象
                * */
              .start(activity);
  }

  public void startCompareFlow() {
      /** 获取AuthBuilder对象 请每次开始流程获取最新对象 */
      try {
          getAuthBuilder()
                  /**
                    * 实名人像比对模块
                    *
                    */
                  .addFollow(AuthComponentFactory.getVerifyCompareComponent()
                          //此示例对比项B为活体过程中截图,
                          .setCompareItem(CompareItemFactory.getCompareItemBySessionId(CompareItemSession.SessionType.PHOTO_LIVING))
                          //如果认证比对图片为OCR获取，此项为非必填项，人证比对图片不是OCR获取，此项必填
                          .setNameAndNumber("张珊珊", "110000198409148054")
                          .setNotifyUrl("http:......")
                  )
                  /** 开始流程
                    * 请传入 Activity 对象
                    * */
                  .start(activity);
      } catch (FormatException e) {
          e.printStackTrace();
      }
  }

  /**
    * 获取AuthBuilder。
    * 请在每次调用前获取新的AuthBuilder
    * 一个AuthBuilder 不要调用两次start()方法
    *
    * @return
    */
  private AuthBuilder getAuthBuilder() {

      // 订单号商户自己生成：不超过36位，非空，不能重复
      String partner_order_id = "orider_123123";
      //商户pub_key ： 开户时通过邮件发送给商户
      String pubKey = "商户 pub_key";
      SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
      //签名时间：有效期5分钟，请每次重新生成 :签名时间格式：yyyyMMddHHmmss
      String sign_time = simpleDateFormat.format(new Date());
      // 商户 security_key  ：  开户时通过邮件发送给商户
      String security_key = "商户 security_key";
      // 签名规则
      String singStr = "pub_key=" + pubKey + "|partner_order_id=" + partner_order_id + "|sign_time=" + sign_time + "|security_key=" + security_key;
      //生成 签名
      String sign = Md5.encrypt(singStr);
      /** 以上签名 请在服务端生成，防止key泄露 */

      AuthBuilder authBuilder = new AuthBuilder(partner_order_id, pubKey, sign_time, sign, new OnResultListener() {
          @Override
          public void onResult(int op_type, String result) {
              Log.e("MainActivity:result", op_type + "//" + result);
              try {
                  JSONObject jsonObject = new JSONObject(result);

                  pendingResult.success(jsonObject);
                  /***
                    * 业务处理成功（不是认证成功）
                    */
                  if (jsonObject.has("success") && jsonObject.getString("success").equals("true")) {
                      /** 业务处理成功 ，可以根据不同的模块 处理数据 */
                      switch (op_type) {
                          case AuthBuilder.OPTION_ERROR:
                              //// TODO:  error
                              break;
                          case AuthBuilder.OPTION_OCR:
                              //// TODO:  OCR扫描 回调
                              break;
                          case AuthBuilder.OPTION_VERIFY:
                              //// TODO:  实名验证简项 回调
                              break;
                          case AuthBuilder.OPTION_LIVENESS:
                              //// TODO:  活体 回调
                              break;
                          case AuthBuilder.OPTION_VIDEO:
                              //// TODO:  视频存证 回调
                              break;
                          case AuthBuilder.OPTION_COMPARE_FACE:
                              //// TODO:  人脸比对 回调
                              break;
                          case AuthBuilder.OPTION_VERIFY_COMPARE:
                              //// TODO:  人像比对 回调
                              break;
                      }
                  } else {
                      /***
                        * 业务处理失败
                        */
                      String message = jsonObject.getString("message");
                      String errorcode = jsonObject.getString("errorcode");
                      /** 打印错误日志，可根据文档定位问题 */
                      Log.d("MainActivity", errorcode + ":" + message);
                  }
              } catch (JSONException e) {
                  e.printStackTrace();
              }

          }

      });

      return authBuilder;
  }
}
