package ffive.video.videocreator;

public class MessageObject {

    public int id;
    public String history;
    public int[] original;
    public int[] palette;
    public int originalWidth;
    public int originalHeight;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }
}
