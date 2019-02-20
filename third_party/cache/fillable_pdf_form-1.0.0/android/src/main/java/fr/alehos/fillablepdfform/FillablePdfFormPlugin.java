package fr.alehos.fillablepdfform;

import android.app.Activity;
import android.app.Application;
import android.content.res.AssetManager;
import android.os.Bundle;

import java.io.File;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.reactivex.Single;
import io.reactivex.disposables.CompositeDisposable;
import io.reactivex.functions.Consumer;
import io.reactivex.schedulers.Schedulers;

/**
 * FillablePdfFormPlugin
 */
public class FillablePdfFormPlugin implements MethodCallHandler, Application.ActivityLifecycleCallbacks {

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "alehos/fillable_pdf_form");
        FillablePdfFormPlugin plugin = new FillablePdfFormPlugin(registrar);
        channel.setMethodCallHandler(plugin);
    }

    // A PDF may have a password
    private static final String EXTRA_PDF_PASSWORD = "pdf_password";

    // PDF Source (used both to fill and extract fields)
    private static final String EXTRA_PDF_STORAGE_FILE_PATH = "pdf_file_path";
    private static final String EXTRA_PDF_FLUTTER_ASSETS_FILE_PATH = "pdf_flutter_file_path";
    private static final String EXTRA_PDF_APPLICATION_ASSETS_FILE_PATH = "pdf_app_file_path";
    private static final String EXTRA_PDF_CONTENT = "pdf_content";

    // When filling a PDF, a new File will be created
    private static final String EXTRA_PDF_DESTINATION = "pdf_destination";
    // Content to be filled
    private static final String EXTRA_PDF_FIELDS_CONTENT = "pdf_fields_content";

    private static final String RESULT_ERROR_CODE = "ERROR";

    private final Registrar registrar;
    private final CompositeDisposable disposable;

    private FillablePdfFormPlugin(Registrar registrar) {
        this.registrar = registrar;
        this.disposable = new CompositeDisposable();
        start();
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        if (call.method.equals("extract_pdf_fields")) {
            extractPdfFields(call, result);
        } else if (call.method.equals("fill_pdf_fields")) {
            fillPdfFields(call, result);
        } else {
            result.notImplemented();
        }
    }

    private void extractPdfFields(MethodCall call, final Result result) {
        byte[] password = null;
        if (call.hasArgument(EXTRA_PDF_PASSWORD)) {
            password = call.argument(EXTRA_PDF_PASSWORD);
        }

        Object pdfFile = getPDFFrom(call, result);
        Single<HashMap<String, String>> request = null;

        if (pdfFile != null) {
            if (pdfFile instanceof InputStream) {
                request = PdfExtractor.extractParams((InputStream) pdfFile, password);
            } else if (pdfFile instanceof File) {
                request = PdfExtractor.extractParams((File) pdfFile, password);
            } else if (pdfFile instanceof byte[]) {
                request = PdfExtractor.extractParams((byte[]) pdfFile, password);
            } else if (pdfFile instanceof String) {
                request = PdfExtractor.extractParams((String) pdfFile, password);
            }
        }

        if (request == null) {
            result.error("ERROR", "Unknown PDF file!", null);
            return;
        }

        disposable.add(request.subscribeOn(Schedulers.computation())
                .observeOn(Schedulers.computation())
                .subscribe(new Consumer<HashMap<String, String>>() {
                    @Override
                    public void accept(HashMap<String, String> fields) {
                        result.success(fields);
                    }
                }, new Consumer<Throwable>() {
                    @Override
                    public void accept(Throwable throwable) {
                        result.error(RESULT_ERROR_CODE, throwable.getMessage(), null);
                    }
                }));
    }

    private void fillPdfFields(MethodCall call, final Result result) {
        byte[] password = null;
        if (call.hasArgument(EXTRA_PDF_PASSWORD)) {
            password = call.argument(EXTRA_PDF_PASSWORD);
        }

        File destination = null;
        if (call.hasArgument(EXTRA_PDF_DESTINATION)) {
            destination = new File((String) call.argument(EXTRA_PDF_DESTINATION));
        }

        if (destination == null) {
            result.error(RESULT_ERROR_CODE, "Unknown destination!", null);
            return;
        }

        Map<String, String> fields = null;
        if (call.hasArgument(EXTRA_PDF_FIELDS_CONTENT)) {
            Map content = call.argument(EXTRA_PDF_FIELDS_CONTENT);
            fields = new HashMap<>(content.size());

            for (Object key : content.keySet()) {
                fields.put(key.toString(), content.get(key).toString());
            }
        }

        if (fields == null) {
            result.error(RESULT_ERROR_CODE, "Fields must not be null!", null);
            return;
        }

        Object pdfFile = getPDFFrom(call, result);
        Single<Integer> request = null;

        if (pdfFile != null) {
            if (pdfFile instanceof InputStream) {
                request = PdfGenerator.fillFields((InputStream) pdfFile, destination, fields, password);
            } else if (pdfFile instanceof File) {
                request = PdfGenerator.fillFields((File) pdfFile, destination, fields, password);
            } else if (pdfFile instanceof byte[]) {
                request = PdfGenerator.fillFields((byte[]) pdfFile, destination, fields, password);
            } else if (pdfFile instanceof String) {
                request = PdfGenerator.fillFields((String) pdfFile, destination, fields, password);
            }
        }

        if (request == null) {
            result.error(RESULT_ERROR_CODE, "Unknown PDF file!", null);
            return;
        }

        disposable.add(request.subscribeOn(Schedulers.computation())
                .observeOn(Schedulers.computation())
                .subscribe(new Consumer<Integer>() {
                    @Override
                    public void accept(Integer fieldsFilled) {
                        result.success(fieldsFilled);
                    }
                }, new Consumer<Throwable>() {
                    @Override
                    public void accept(Throwable throwable) {
                        result.error(RESULT_ERROR_CODE, throwable.getMessage(), null);
                    }
                }));
    }

    private Object getPDFFrom(MethodCall call, final Result result) {
        if (call.hasArgument(EXTRA_PDF_FLUTTER_ASSETS_FILE_PATH)) {
            AssetManager assetManager = registrar.context().getAssets();
            try {
                String key = registrar.lookupKeyForAsset((String) call.argument(EXTRA_PDF_FLUTTER_ASSETS_FILE_PATH));
                return assetManager.open(key);
            } catch (Exception e) {
                e.printStackTrace();
                result.error(RESULT_ERROR_CODE, e.getMessage(), null);
            }
        } else if (call.hasArgument(EXTRA_PDF_APPLICATION_ASSETS_FILE_PATH)) {
            try {
                return registrar.context().getAssets().open((String) call.argument(EXTRA_PDF_APPLICATION_ASSETS_FILE_PATH));
            } catch (Exception e) {
                e.printStackTrace();
                result.error(RESULT_ERROR_CODE, e.getMessage(), null);
            }
        } else if (call.hasArgument(EXTRA_PDF_STORAGE_FILE_PATH)) {
            String filePath = call.argument(EXTRA_PDF_STORAGE_FILE_PATH);
            File file = new File(filePath);

            if (!file.exists()) {
                result.error(RESULT_ERROR_CODE, "The file " + filePath + " does not exist!", null);
            } else if (!file.canRead()) {
                result.error(RESULT_ERROR_CODE, "The file " + filePath + " is not readable!", null);
            } else {
                return file;
            }
        } else if (call.hasArgument(EXTRA_PDF_CONTENT)) {
            Object pdfContent = call.argument(EXTRA_PDF_CONTENT);
            if (pdfContent instanceof byte[] || pdfContent instanceof String) {
                return pdfContent;
            } else {
                result.error(RESULT_ERROR_CODE, "Unknown PDF content type!", null);
            }
        }

        return null;
    }

    private void start() {
        this.registrar.activity().getApplication().registerActivityLifecycleCallbacks(this);
    }

    private void stop() {
        this.registrar.activity().getApplication().unregisterActivityLifecycleCallbacks(this);
        this.disposable.dispose();
        this.disposable.clear();
    }

    @Override
    public void onActivityCreated(Activity activity, Bundle savedInstanceState) {
        start();
    }

    @Override
    public void onActivityStarted(Activity activity) {

    }

    @Override
    public void onActivityResumed(Activity activity) {

    }

    @Override
    public void onActivityPaused(Activity activity) {

    }

    @Override
    public void onActivityStopped(Activity activity) {
        stop();
    }

    @Override
    public void onActivitySaveInstanceState(Activity activity, Bundle outState) {

    }

    @Override
    public void onActivityDestroyed(Activity activity) {

    }
}
