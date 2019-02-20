package net.sh4869.flutternowplayingplugin;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import net.sh4869.flutternowplayingplugin.types.Track;

/**
 * Created by sh4869 on 18/03/21.
 */

public class GooglePlayMusicReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(Context context,Intent intent){
        Bundle bundle = intent.getExtras();
        Track _track = new Track();
        _track.setAlbum(bundle.getString("album"));
        _track.setArtist(bundle.getString("artist"));
        _track.setTitle(bundle.getString("track"));
        TrackStatus.updateTrack(_track);
    }
}
