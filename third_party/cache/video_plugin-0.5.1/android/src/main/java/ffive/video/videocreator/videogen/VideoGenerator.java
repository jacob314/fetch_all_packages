package ffive.video.videocreator.videogen;

public class VideoGenerator {




    public static void generate(VideoParams params) {

        double result = historyToVideoJNI(
                params.original,
                params.history,
                params.videoPath,
                params.palette,
                params.originalWidth,
                params.originalHeight,
                params.secondsPaint,
                params.secondsShow
        );

    }




    public static native double historyToVideoJNI(int[] argb, String jpath, String vPath, int[] palette, int width, int originalHeight, int timeP, int timeS);


}
