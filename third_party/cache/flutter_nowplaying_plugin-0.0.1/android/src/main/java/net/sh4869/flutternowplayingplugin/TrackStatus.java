package net.sh4869.flutternowplayingplugin;
import net.sh4869.flutternowplayingplugin.types.Track;

/**
 * Created by sh4869 on 18/03/21.
 */

public class TrackStatus {
    private static Track currentTrack;

    static {
        currentTrack = new Track();
    }

    public static synchronized void updateTrack(Track track){
        currentTrack = track;
    }

    public synchronized static Track getTrack(){
        return currentTrack;
    }
}
