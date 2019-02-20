package com.mediaMetadata.mediametadataplugin;

public class ImageColor {
    int backgroundColor = 0;
    int primaryColor = 0;
    int secondaryColor = 0;
    Boolean isLight = false;

    public int getBackgroundColor() {
        return backgroundColor;
    }

    public void setBackgroundColor(int backgroundColor) {
        this.backgroundColor = backgroundColor;
    }

    public int getPrimaryColor() {
        return primaryColor;
    }

    public void setPrimaryColor(int primaryColor) {
        this.primaryColor = primaryColor;
    }

    public int getSecondaryColor() {
        return secondaryColor;
    }

    public void setSecondaryColor(int secondaryColor) {
        this.secondaryColor = secondaryColor;
    }

    public Boolean getLight() {
        return isLight;
    }

    public void setLight(Boolean light) {
        isLight = light;
    }
}
