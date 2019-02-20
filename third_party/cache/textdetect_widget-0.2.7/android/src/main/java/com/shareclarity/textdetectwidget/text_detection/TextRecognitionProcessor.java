// Copyright 2018 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
package com.shareclarity.textdetectwidget.text_detection;

import android.app.Activity;
import android.content.Context;
import android.content.res.Resources;
import android.graphics.Camera;
import android.graphics.Point;
import android.graphics.RectF;
import android.media.MediaPlayer;
import android.os.Handler;
import android.os.Looper;
import android.support.annotation.NonNull;
import android.util.Log;
import android.view.Display;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.ml.common.FirebaseMLException;
import com.google.firebase.ml.vision.FirebaseVision;
import com.google.firebase.ml.vision.common.FirebaseVisionImage;
import com.google.firebase.ml.vision.common.FirebaseVisionImageMetadata;
import com.google.firebase.ml.vision.text.FirebaseVisionText;
import com.google.firebase.ml.vision.text.FirebaseVisionTextRecognizer;
import com.shareclarity.textdetectwidget.FlutterCameraView;
import com.shareclarity.textdetectwidget.R;
import com.shareclarity.textdetectwidget.TextdetectWidgetPlugin;
import com.shareclarity.textdetectwidget.others.FrameMetadata;
import com.shareclarity.textdetectwidget.others.GraphicOverlay;

import java.io.IOException;
import java.lang.reflect.AccessibleObject;
import java.nio.ByteBuffer;
import java.util.HashMap;
import java.util.List;
import java.util.concurrent.atomic.AtomicBoolean;

import io.flutter.plugin.common.MethodChannel;

import static com.shareclarity.textdetectwidget.TextdetectWidgetPlugin.channel;
import static com.shareclarity.textdetectwidget.TextdetectWidgetPlugin.mActivity;
import static com.shareclarity.textdetectwidget.TextdetectWidgetPlugin.mResult;

//import com.ajeetkumar.textdetectionusingmlkit.others.VisionProcessorBase;

/**
 * Processor for the text recognition demo.
 */
public class TextRecognitionProcessor {

	private static final String TAG = "TextRecProc";

	private HashMap<String,String> companies;

	private FlutterCameraView flutterView;

	private final FirebaseVisionTextRecognizer detector;

	private boolean isFocused = false;
	private boolean isPaused = false;
	private int focusedId = 0;
	private String lastCompany = "";
	// Whether we should ignore process(). This is usually caused by feeding input data faster than
	// the model can handle.
	private final AtomicBoolean shouldThrottle = new AtomicBoolean(false);

	public TextRecognitionProcessor(HashMap<String,String> _companies, FlutterCameraView _view) {
		detector = FirebaseVision.getInstance().getOnDeviceTextRecognizer();
		companies = _companies;
		flutterView = _view;
	}

	//region ----- Exposed Methods -----
	public void stop() {
		try {
			detector.close();
		} catch (IOException e) {
			Log.e(TAG, "Exception thrown while trying to close Text Detector: " + e);
		}
	}

	public void setPaused(boolean paused) {

		isPaused = paused;
	}
	public void process(ByteBuffer data, FrameMetadata frameMetadata, GraphicOverlay graphicOverlay) throws FirebaseMLException {

		if (shouldThrottle.get()) {
			return;
		}
		FirebaseVisionImageMetadata metadata =
				new FirebaseVisionImageMetadata.Builder()
						.setFormat(FirebaseVisionImageMetadata.IMAGE_FORMAT_NV21)
						.setWidth(frameMetadata.getWidth())
						.setHeight(frameMetadata.getHeight())
						.setRotation(frameMetadata.getRotation())
						.build();
		if (!isPaused) {
			detectInVisionImage(FirebaseVisionImage.fromByteBuffer(data, metadata), frameMetadata, graphicOverlay);
		}

	}

	//endregion

	//region ----- Helper Methods -----

	protected Task<FirebaseVisionText> detectInImage(FirebaseVisionImage image) {
		return detector.processImage(image);
	}

	protected void handleDetection(@NonNull FirebaseVisionText results, @NonNull GraphicOverlay graphicOverlay) {
		graphicOverlay.clear();
		for (int i =0;i<companies.keySet().size();i++) {
			String company = (String) companies.keySet().toArray()[i];
			if (!results.getText().toUpperCase().contains(company.toUpperCase())) {
				continue;
			}
			List<FirebaseVisionText.TextBlock> blocks = results.getTextBlocks();
			for (int j = 0;j < blocks.size(); j++) {
				FirebaseVisionText.TextBlock block = blocks.get(j);
				if (!block.getText().toUpperCase().contains(company.toUpperCase())) {
					continue;
				}
				List<FirebaseVisionText.Line> lines = block.getLines();
				for (int p = 0; p < lines.size(); p++) {
					FirebaseVisionText.Line line = lines.get(p);
					if (!line.getText().toUpperCase().contains(company.toUpperCase())) {
						continue;
					}
					int min = line.getBoundingBox().left;
					int max = line.getBoundingBox().right;
					List<FirebaseVisionText.Element> elements = line.getElements();
					boolean elementFlag = false;
					//Finding location of detected text
					for (int k = 0; k < elements.size(); k++) {
						FirebaseVisionText.Element element = elements.get(k);
						if (company.contains(element.getText())) {
							if (!elementFlag) {
								elementFlag = true;
								min = element.getBoundingBox().left;
								max = element.getBoundingBox().right;
							} else {
								if (min > element.getBoundingBox().left) {
									min = element.getBoundingBox().left;
								}
								if (max < element.getBoundingBox().right) {
									max = element.getBoundingBox().right;
								}
							}
						}
					}
					//Add Rect to overlay
					RectF rectF = new RectF(min, line.getBoundingBox().top, max, line.getBoundingBox().bottom);

					final String nickname = (String)companies.values().toArray()[i];
					GraphicOverlay.Graphic textGraphic = new TextGraphic(TextdetectWidgetPlugin.mActivity, rectF, nickname, graphicOverlay);
					graphicOverlay.add(textGraphic);

					Display display = TextdetectWidgetPlugin.mActivity.getWindowManager().getDefaultDisplay();
					Point size = new Point();
					display.getSize(size);

					//Focus
					RectF focusRect = new RectF();
					focusRect.left = (pxToDp(size.x) - 300) / 2;
					focusRect.top = 150;
					focusRect.right = focusRect.left + 300;
					focusRect.bottom = 210;

					//Tag rect
					RectF newRect = new RectF();
					newRect.left = pxToDp((int)(rectF.width() / 2 + rectF.left - 100));

					newRect.top = pxToDp((int)rectF.top);
					newRect.right = pxToDp((int)(rectF.width() / 2 + rectF.left + 100));
					newRect.bottom = pxToDp((int)(rectF.bottom));

					RectF testRect = newRect;
//
					if (newRect.left + 80 > focusRect.left && newRect.right + 80 < focusRect.right) {
						if (newRect.top + 30 > focusRect.top && newRect.bottom + 30 < focusRect.bottom) {
							if (!lastCompany.equals(company)) {
								graphicOverlay.clear();
								graphicOverlay.add(textGraphic);
								//Blink animation
								if (!isFocused) {
									Animation animation = AnimationUtils.loadAnimation(TextdetectWidgetPlugin.mActivity.getApplicationContext(), R.anim.blink);
									flutterView.focusLayout.startAnimation(animation);
									Animation animation1 = AnimationUtils.loadAnimation(TextdetectWidgetPlugin.mActivity.getApplicationContext(), R.anim.blink_resume);
									flutterView.focusLayout.startAnimation(animation1);
									isFocused = true;
									focusedId = i;
									Handler mainHandler = new Handler(Looper.getMainLooper());
									Runnable myRunnable = new Runnable() {
										@Override
										public void run() {
											flutterView.hidePlusImage();
										} // This is your code
									};
									mainHandler.post(myRunnable);
									MediaPlayer mp = MediaPlayer.create(TextdetectWidgetPlugin.mActivity.getApplicationContext(), R.raw.detect_sound);
									try {
										if (mp.isPlaying()) {
											mp.stop();
											mp.release();

											mp = MediaPlayer.create(TextdetectWidgetPlugin.mActivity.getApplicationContext(), R.raw.detect_sound);
										}
										mp.start();
									} catch (Exception e) {
										e.printStackTrace();
									}
									lastCompany = company;
									flutterView.methodChannel.invokeMethod("detect",nickname);

								}
							}

							return;
						}
					}
					if (isFocused && focusedId == i) {
						isFocused = false;
					}
				}
				break;
			}
		}

	}

	protected void onSuccess(@NonNull final FirebaseVisionText results, @NonNull FrameMetadata frameMetadata, @NonNull final GraphicOverlay graphicOverlay) {
		mActivity.runOnUiThread(new Runnable() {
			@Override
			public void run() {
				handleDetection(results,graphicOverlay);
			}
		});

		shouldThrottle.set(false);
	}
	public static int pxToDp(int px) {
		return (int) (px / Resources.getSystem().getDisplayMetrics().density);
	}

	public static int dpToPx(int dp) {
		return (int) (dp * Resources.getSystem().getDisplayMetrics().density);
	}

	protected void onFailure(@NonNull Exception e) {
		Log.w(TAG, "Text detection failed." + e);
	}

	private void detectInVisionImage( FirebaseVisionImage image, final FrameMetadata metadata, final GraphicOverlay graphicOverlay) {

		detectInImage(image)
				.addOnSuccessListener(
						new OnSuccessListener<FirebaseVisionText>() {
							@Override
							public void onSuccess(FirebaseVisionText results) {

								TextRecognitionProcessor.this.onSuccess(results, metadata, graphicOverlay);
							}
						})
				.addOnFailureListener(
						new OnFailureListener() {
							@Override
							public void onFailure(@NonNull Exception e) {
								shouldThrottle.set(false);
								isFocused = false;
								TextRecognitionProcessor.this.onFailure(e);
							}
						});
		// Begin throttling until this frame of input has been processed, either in onSuccess or
		// onFailure.
		shouldThrottle.set(true);
	}

	//endregion


}
