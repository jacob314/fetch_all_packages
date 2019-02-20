/*
 * Decompiled with CFR 0_132.
 *
 * Could not load the following classes:
 *  android.graphics.Bitmap
 */
package com.nbbse.mobiprint3;

import android.graphics.Bitmap;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.RandomAccessFile;

public class Printer {
  static Printer printer = null;
  public static final int BMP_PRINT_FAST = 2;
  public static final int BMP_PRINT_SLOW = 3;
  public static final int PRINTER_NO_PAPER = 0;
  public static final int PRINTER_EXIST_PAPER = 1;
  public static final int PRINTER_PAPER_ERROR = 2;
  public static final int PRINTER_STATUS_OK = 1;
  public static final int PRINTER_STATUS_NO_PAPER = 0;
  public static final int PRINTER_STATUS_OVER_HEAT = -1;
  public static final int PRINTER_STATUS_GET_FAILED = -2;
  public static final int PRINTER_INITING = 0;
  public static final int PRINTER_PRINTING = 1;
  public static final int PRINTER_READY = 2;
  public static final int PRINTER_ERROR = 3;
  private String data_file_pre = "/data/media/printer";
  private String data_file_ext = ".bin";
  private String notify_file = "/proc/printer";
  private int nTargetIndex = 0;

  public static Printer getInstance() {
    if (printer == null) {
      printer = new Printer();
    }
    return printer;
  }

  public void printText(String data) {
    this.printText(data, 1, false);
  }

  public void printText(String data, int size) {
    this.printText(data, size, false);
  }

  public void printText(String data, boolean r2lFlag) {
    this.printText(data, 1, r2lFlag);
  }

  public void printText(String data, int size, boolean r2lFlag) {
    if (size < 1) {
      size = 1;
    } else if (size > 4) {
      size = 4;
    }
    byte[] header = this.prepareTextHeader(size, r2lFlag);
    String data_file = this.checkAvailablePath();
    if (data_file != null) {
      try {
        byte[] string_data = data.getBytes("UNICODE");
        this.writeFile(data_file, header, string_data, 1);
      }
      catch (Exception e) {
        e.printStackTrace();
      }
      this.notifyToPrint(data_file);
    }
  }

  public void printBitmap(String filePath) {
    this.printBitmap(filePath, 2);
  }

  public void printBitmap(String filePath, int speed) {
    try {
      FileInputStream is = new FileInputStream(filePath);
      this.printBitmap(is, speed);
      is.close();
    }
    catch (Exception e) {
      e.printStackTrace();
    }
  }

  public void printBitmap(InputStream is) {
    this.printBitmap(is, 2);
  }

  public void printBitmap(InputStream is, int speed) {
    DataInputStream dis = new DataInputStream(is);
    int bflen = 14;
    byte[] bf = new byte[bflen];
    int bilen = 40;
    byte[] bi = new byte[bilen];
    try {
      dis.read(bf, 0, bflen);
      dis.read(bi, 0, bilen);
    }
    catch (Exception e) {
      e.printStackTrace();
    }
    int BMPDataOffset = this.ChangeInt(bf, 13);
    int width = this.ChangeInt(bi, 7);
    int height = this.ChangeInt(bi, 11);
    byte[] image_bytes = new byte[width * height / 8];
    int nbitcount = (bi[15] & 255) << 8 | bi[14] & 255;
    int nsizeimage = this.ChangeInt(bi, 23);
    int[] image = new int[width * height];
    int nArray = 0;
    switch (nbitcount) {
      case 1: {
        int dataArrayLen = width * height / 8;
        if (dataArrayLen > nsizeimage) {
          return;
        }
        byte[] color_index = new byte[BMPDataOffset - 54];
        try {
          dis.read(color_index, 0, BMPDataOffset - 54);
          dis.read(image_bytes, 0, dataArrayLen);
        }
        catch (Exception e) {
          e.printStackTrace();
        }
        return;
      }
      case 8: {
        int i;
        int dataArrayLen = width * height;
        if (dataArrayLen > nsizeimage) {
          return;
        }
        int plate = 0;
        int[] RGBQUAD = null;
        plate = (BMPDataOffset - 54) / 4;
        if (plate < 0) {
          return;
        }
        RGBQUAD = new int[plate];
        byte[] imageData = new byte[dataArrayLen];
        try {
          i = 0;
          while (i < plate) {
            RGBQUAD[i] = dis.readByte() & 255 | (dis.readByte() & 255) << 8 | (dis.readByte() & 255) << 16 | (dis.readByte() & 255) << 24;
            ++i;
          }
          dis.read(imageData, 0, dataArrayLen);
        }
        catch (Exception e) {
          e.printStackTrace();
        }
        i = height - 1;
        while (i >= 0) {
          int j = 0;
          while (j < width) {
            int index;
            int r;
            int b;
            int g;
            image[i * width + j] = ((r = RGBQUAD[index = this.unsignedByteToInt(imageData[nArray++])] & 255) + (g = RGBQUAD[index] >> 8 & 255) + (b = RGBQUAD[index] >> 16 & 255)) / 3 < 127 ? 1 : 0;
            ++j;
          }
          --i;
        }
        int n = 0;
        while (n < width * height / 8) {
          image_bytes[n] = (byte)((byte)(image[8 * n + 0] & 1) << 7 | (byte)(image[8 * n + 1] & 1) << 6 | (byte)(image[8 * n + 2] & 1) << 5 | (byte)(image[8 * n + 3] & 1) << 4 | (byte)(image[8 * n + 4] & 1) << 3 | (byte)(image[8 * n + 5] & 1) << 2 | (byte)(image[8 * n + 6] & 1) << 1 | (byte)(image[8 * n + 7] & 1) << 0);
          ++n;
        }
        break;
      }
      case 24: {
        int dataArrayLen = width * height * 3;
        if (dataArrayLen > nsizeimage) {
          return;
        }
        byte[] imageData = new byte[dataArrayLen];
        try {
          dis.read(imageData, 0, dataArrayLen);
        }
        catch (Exception e) {
          e.printStackTrace();
        }
        int i = height - 1;
        while (i >= 0) {
          int j = 0;
          while (j < width) {
            image[i * width + j] = (this.unsignedByteToInt(imageData[nArray++]) + this.unsignedByteToInt(imageData[nArray++]) + this.unsignedByteToInt(imageData[nArray++])) / 3 < 127 ? 1 : 0;
            ++j;
          }
          --i;
        }
        int n = 0;
        while (n < width * height / 8) {
          image_bytes[n] = (byte)((byte)(image[8 * n] & 1) << 7 | (byte)(image[8 * n + 1] & 1) << 6 | (byte)(image[8 * n + 2] & 1) << 5 | (byte)(image[8 * n + 3] & 1) << 4 | (byte)(image[8 * n + 4] & 1) << 3 | (byte)(image[8 * n + 5] & 1) << 2 | (byte)(image[8 * n + 6] & 1) << 1 | (byte)(image[8 * n + 7] & 1) << 0);
          ++n;
        }
        break;
      }
      default: {
        return;
      }
    }
    byte[] header = this.prepareBitmapHeader(width, height, speed);
    String data_file = this.checkAvailablePath();
    if (data_file != null) {
      this.writeFile(data_file, header, image_bytes, 2);
      this.notifyToPrint(data_file);
    }
  }

  public void printBitmap(Bitmap bitmap) {
    this.printBitmap(bitmap, 2);
  }

  public void printBitmap(Bitmap bitmap, int speed) {
    if (bitmap == null) {
      return;
    }
    int nBmpWidth = bitmap.getWidth();
    int nBmpHeight = bitmap.getHeight();
    int bufferSize = nBmpHeight * (nBmpWidth * 3 + nBmpWidth % 4);
    ByteArrayOutputStream bout = new ByteArrayOutputStream();
    int bfType = 19778;
    long bfSize = 54 + bufferSize;
    int bfReserved1 = 0;
    int bfReserved2 = 0;
    long bfOffBits = 54L;
    long biSize = 40L;
    long biWidth = nBmpWidth;
    long biHeight = nBmpHeight;
    int biPlanes = 1;
    int biBitCount = 24;
    long biCompression = 0L;
    long biSizeImage = nBmpHeight * nBmpWidth * 3;
    long biXpelsPerMeter = 0L;
    long biYPelsPerMeter = 0L;
    long biClrUsed = 0L;
    long biClrImportant = 0L;
    try {
      this.writeWord(bout, bfType);
      this.writeDword(bout, bfSize);
      this.writeWord(bout, bfReserved1);
      this.writeWord(bout, bfReserved2);
      this.writeDword(bout, bfOffBits);
      this.writeDword(bout, biSize);
      this.writeLong(bout, biWidth);
      this.writeLong(bout, biHeight);
      this.writeWord(bout, biPlanes);
      this.writeWord(bout, biBitCount);
      this.writeDword(bout, biCompression);
      this.writeDword(bout, biSizeImage);
      this.writeLong(bout, biXpelsPerMeter);
      this.writeLong(bout, biYPelsPerMeter);
      this.writeDword(bout, biClrUsed);
      this.writeDword(bout, biClrImportant);
      byte[] bmpData = new byte[bufferSize];
      int wWidth = nBmpWidth * 3 + nBmpWidth % 4;
      int nCol = 0;
      int nRealCol = nBmpHeight - 1;
      while (nCol < nBmpHeight) {
        int wRow = 0;
        int wByteIdex = 0;
        while (wRow < nBmpWidth) {
          int clr = bitmap.getPixel(wRow, nCol);
          if (clr == 0) {
            bmpData[nRealCol * wWidth + wByteIdex] = -1;
            bmpData[nRealCol * wWidth + wByteIdex + 1] = -1;
            bmpData[nRealCol * wWidth + wByteIdex + 2] = -1;
          } else {
            bmpData[nRealCol * wWidth + wByteIdex] = 0;
            bmpData[nRealCol * wWidth + wByteIdex + 1] = 0;
            bmpData[nRealCol * wWidth + wByteIdex + 2] = 0;
          }
          ++wRow;
          wByteIdex += 3;
        }
        ++nCol;
        --nRealCol;
      }
      bout.write(bmpData, 0, bufferSize);
      ByteArrayInputStream is = new ByteArrayInputStream(bout.toByteArray());
      this.printBitmap(is, speed);
      bout.close();
      is.close();
    }
    catch (IOException e) {
      e.printStackTrace();
    }
  }

  public void printEndLine() {
    this.printText("\n\n\n");
  }

  public boolean voltageCheck() {
    return true;
  }

  public int getPaperStatus() {
    String path = "/proc/printer";
    RandomAccessFile raf = null;
    byte[] arr = new byte[4];
    int i = 0;
    try {
      raf = new RandomAccessFile(path, "r");
      i = raf.read(arr);
      raf.close();
    }
    catch (Exception e) {
      e.printStackTrace();
    }
    if (i == 2) {
      if (arr[1] == 48) {
        return 0;
      }
      return 1;
    }
    if (i == 1) {
      if (arr[0] == 48) {
        return 0;
      }
      return 1;
    }
    return 2;
  }

  public int getPrinterStatus() {
    String path = "/proc/printer";
    RandomAccessFile raf = null;
    byte[] arr = new byte[4];
    int i = 0;
    try {
      raf = new RandomAccessFile(path, "r");
      i = raf.read(arr);
      raf.close();
    }
    catch (Exception e) {
      e.printStackTrace();
    }
    if (i == 2) {
      if (arr[1] == 48) {
        return 0;
      }
      if (arr[0] == 49) {
        return -1;
      }
      return 1;
    }
    if (i == 1) {
      if (arr[0] == 48) {
        return 0;
      }
      return 1;
    }
    return -2;
  }

  private void notifyToPrint(String data_file) {
    try {
      FileOutputStream fos = new FileOutputStream(this.notify_file);
      byte[] notify_data = data_file.getBytes();
      fos.write(notify_data);
      fos.close();
    }
    catch (Exception e) {
      e.printStackTrace();
    }
  }

  private byte[] prepareTextHeader(int size, boolean r2lFlag) {
    byte[] text_header = new byte[10];
    text_header[0] = 29;
    text_header[1] = 96;
    text_header[2] = 80;
    text_header[3] = 82;
    text_header[4] = 73;
    text_header[5] = 78;
    text_header[6] = 84;
    text_header[7] = 1;
    text_header[8] = (byte)size;
    text_header[9] = (byte)(r2lFlag ? 1 : 0);
    return text_header;
  }

  private byte[] prepareBitmapHeader(int width, int height, int speed) {
    if (speed != 2 && speed != 3) {
      speed = 2;
    }
    byte[] bitmap_header = new byte[]{29, 96, 80, 82, 73, 78, 84, 2, (byte)speed, (byte)(width / 8), 0, (byte)(height & 255), (byte)((height & 65280) >> 8)};
    return bitmap_header;
  }

  private void writeFile(String filename, byte[] header, byte[] data, int type) {
    try {
      FileOutputStream fos = new FileOutputStream(filename);
      fos.write(header);
      if (data != null) {
        if (type == 1) {
          fos.write(data, 2, data.length - 2);
        } else if (type == 2) {
          fos.write(data);
        }
      }
      fos.close();
    }
    catch (Exception e) {
      e.printStackTrace();
    }
  }

  private String checkAvailablePath() {
    File file;
    String str = String.valueOf(this.data_file_pre) + this.nTargetIndex + this.data_file_ext;
    ++this.nTargetIndex;
    if (this.nTargetIndex > 50) {
      this.nTargetIndex = 0;
    }
    if ((file = new File(str)).exists()) {
      file.delete();
    }
    return str;
  }

  private int ChangeInt(byte[] bi, int start) {
    return (bi[start] & 255) << 24 | (bi[start - 1] & 255) << 16 | (bi[start - 2] & 255) << 8 | bi[start - 3] & 255;
  }

  private int unsignedByteToInt(byte b) {
    return b & 255;
  }

  private void writeWord(ByteArrayOutputStream stream, int value) throws IOException {
    byte[] b = new byte[]{(byte)(value & 255), (byte)(value >> 8 & 255)};
    stream.write(b, 0, 2);
  }

  private void writeDword(ByteArrayOutputStream stream, long value) throws IOException {
    byte[] b = new byte[]{(byte)(value & 255L), (byte)(value >> 8 & 255L), (byte)(value >> 16 & 255L), (byte)(value >> 24 & 255L)};
    stream.write(b, 0, 4);
  }

  private void writeLong(ByteArrayOutputStream stream, long value) throws IOException {
    byte[] b = new byte[]{(byte)(value & 255L), (byte)(value >> 8 & 255L), (byte)(value >> 16 & 255L), (byte)(value >> 24 & 255L)};
    stream.write(b, 0, 4);
  }
}