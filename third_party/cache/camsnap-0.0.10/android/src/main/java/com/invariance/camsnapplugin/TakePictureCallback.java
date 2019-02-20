package com.invariance.camsnapplugin;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Matrix;
import android.hardware.Camera;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

import io.flutter.plugin.common.MethodChannel;

public class TakePictureCallback implements Camera.PictureCallback {
    private String fileName;
    private MethodChannel.Result result;

    TakePictureCallback(String fileName, MethodChannel.Result result) {
        super();
        this.fileName = fileName;
        this.result = result;
    }

    @Override
    public void onPictureTaken(byte[] data, Camera camera) {
        camera.startPreview();
        if (fileName == null){
            result.error("Error creating media file, check storage permissions", null, null);
            return;
        }
        try {
            FileOutputStream fos = new FileOutputStream(fileName);
            Bitmap realImage = BitmapFactory.decodeByteArray(data, 0, data.length);
            realImage.compress(Bitmap.CompressFormat.JPEG, 100, fos);
            fos.close();
        } catch (FileNotFoundException e) {
            result.error("File not found: " + e.getMessage(), null, null);
        } catch (IOException e) {
            result.error("Error accessing file: " + e.getMessage(), null, null);
        } finally {
            result.success(fileName);
        }
    }

    private Bitmap rotateBitmap(Bitmap bitmap, int degree) {
        int w = bitmap.getWidth();
        int h = bitmap.getHeight();

        Matrix mtx = new Matrix();
        mtx.setRotate(degree);

        return Bitmap.createBitmap(bitmap, 0, 0, w, h, mtx, true);
    }
}
