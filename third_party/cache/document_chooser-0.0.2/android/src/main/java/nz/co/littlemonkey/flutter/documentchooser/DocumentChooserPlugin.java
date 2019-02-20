package nz.co.littlemonkey.flutter.documentchooser;

import android.content.Context;
import android.content.Intent;
import android.os.Environment;

import java.io.File;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** DocumentChooserPlugin */
public class DocumentChooserPlugin implements MethodCallHandler {

  private final PluginRegistry.Registrar registrar;
  private final DocumentPickerDelegate delegate;

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "document_chooser");

    final File externalFilesDirectory =
            registrar.activity().getExternalFilesDir(Environment.DIRECTORY_DOCUMENTS);

    final DocumentPickerDelegate delegate =
            new DocumentPickerDelegate(registrar.activity(), externalFilesDirectory);
    registrar.addActivityResultListener(delegate);
    registrar.addRequestPermissionsResultListener(delegate);

    final DocumentChooserPlugin instance = new DocumentChooserPlugin(registrar, delegate);
    channel.setMethodCallHandler(instance);
  }

  public DocumentChooserPlugin(PluginRegistry.Registrar registrar, DocumentPickerDelegate delegate) {
    this.registrar = registrar;
    this.delegate = delegate;
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("chooseDocument")) {
      delegate.chooseDocument(call, result);
    }else if(call.method.equals("chooseDocuments")) {
      delegate.chooseDocuments(call, result);
    }else {
      result.notImplemented();
    }
  }
/*
  private void chooseDocument(){
    Context context = getActiveContext();

    Intent intent = new Intent(Intent.ACTION_OPEN_DOCUMENT);
    intent.addCategory(Intent.CATEGORY_OPENABLE);
    intent.setType("image/*");
    context.startActivityForResult(intent, PICK_SINGLE);

  }

  @Override
  public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
    return true;
  }

  private Context getActiveContext() {
    return (mRegistrar.activity() != null) ? mRegistrar.activity() : mRegistrar.context();
  }*/
}
