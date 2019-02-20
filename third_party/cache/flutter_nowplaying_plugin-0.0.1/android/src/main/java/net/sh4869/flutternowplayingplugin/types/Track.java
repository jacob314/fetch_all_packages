package net.sh4869.flutternowplayingplugin.types;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by sh4869 on 18/03/21.
 */

public class Track {
    String title, artist, album;

    public Track() {
        title = "";
        artist = "";
        album = "";
    }

    public Map<String, Object> toMap() {
        Map<String, Object> map = new HashMap<>();
        map.put("title", this.title);
        map.put("artist", this.artist);
        map.put("album", this.album);
        return map;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public void setArtist(String artist) {
        this.artist = artist;
    }

    public void setAlbum(String album) {
        this.album = album;
    }

}
