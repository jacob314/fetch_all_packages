package com.nbbse.mobiprint3;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import java.util.*;

import com.nbbse.mobiprint3.Printer;


/** Mobiprint3Plugin */
public class Mobiprint3Plugin implements MethodCallHandler {

  Printer printObj = Printer.getInstance();

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "mobiprint3");
    channel.setMethodCallHandler(new Mobiprint3Plugin());
  }

  @Override
  public void onMethodCall(MethodCall action, Result result) {


    if (action.method.equals("print"))
    {
      String message = action.argument("data");
      this.printMessage(message, result);
    }
    else if(action.method.equals("test"))
    {
      this.tsr(result);
    }
    else if(action.method.equals("space"))
    {
      this.printSpace(result);
    }
    else if(action.method.equals("image"))
    {
      String message = action.argument("data");
      this.printImage(message, result);
    }
    else if(action.method.equals("custom"))
    {
      String message = action.argument("data");
      int sz = action.argument("size");
      this.printHeader(message,sz,result);
    }
    else if(action.method.equals("paper"))
    {
      this.checkPaper(result);
    }
    else if(action.method.equals("end"))
    {
      this.printEndLine(result);
    }
    else
    {
      result.notImplemented();
    }



//    if (call.method.equals("getPlatformVersion")) {
//      printObj.printText("Running Flutter on Android" + android.os.Build.VERSION.RELEASE);
//      printObj.printEndLine();
//      result.success("Android " + android.os.Build.VERSION.RELEASE);
//    } else {
//      result.notImplemented();
//    }
  }



  private void checkPaper(Result res )
  {
    try
    {
        String rsp = ( printObj.getPaperStatus() == 1  ) ?  "1" : "2";
        res.success(rsp);
    }
    catch(Exception e)
    {
        res.error("ERROR", e.getMessage(),null);
    }

  }

  

  private void printMessage(String message, Result res)
  {          

    if (message != null && message.length() > 0) 
    {

        if (printObj.getPaperStatus() == 1) 
        {

            try 
            {                 
                printObj.printText(message); 
                
                res.success("1");
                
            } catch (Exception e) {

            res.error("ERROR",e.getMessage(),null);

            }
            
        }
        else
        {
        res.error("ERROR","Please load more paper to continue",null);
        }

    } 
    else 
    { 
    res.error("ERROR","Please define content to print",null);
    }

  }

  
  private void printEndLine ( Result res )
  {

    try {
        printObj.printEndLine();
        res.success("1");
    } catch (Exception e) {
        res.error( "EROOR",e.getMessage(),null);
    }
      

  }

  private void printHeader( String txt, int size, Result res  )
  {

    try
    {
        
        printObj.printText(txt, size);
        res.success("1");
    }
    catch( Exception e)
    {
        res.error("ERROR", e.getMessage(), null);
    }

  }

  private void tsr(Result res)
  {
    res.success("1");
  }

  private void printImage( String src , Result res )
  {

    try
    {
        printObj.printBitmap(src);
        res.success("1");
    }
    catch (Exception e)
    {
        res.error("ERROR", e.getMessage(),null);
    }

  }

  private void printSpace( Result res)
  {
    try
    {        
        printObj.printText("\n\n");
        res.success("1");
    }
    catch(Exception e)
    {
        res.error("ERROR", e.getMessage(),null);
    }

  }


}
