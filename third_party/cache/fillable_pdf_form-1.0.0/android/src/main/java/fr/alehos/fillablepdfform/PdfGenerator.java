package fr.alehos.fillablepdfform;

import com.itextpdf.text.pdf.AcroFields;
import com.itextpdf.text.pdf.PdfReader;
import com.itextpdf.text.pdf.PdfStamper;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.RandomAccessFile;
import java.util.Map;

import io.reactivex.Single;
import io.reactivex.functions.Function;

final class PdfGenerator {

    public static Single<Integer> fillFields(InputStream stream, File outputPath, Map<String, String> fields, final byte[] password) {
        return fillFields(Single.just(stream)
                .map(
                        new Function<InputStream, PdfReader>() {
                            @Override
                            public PdfReader apply(InputStream inputStream) throws Exception {
                                return new PdfReader(inputStream, password);
                            }
                        }
                ), outputPath, fields);
    }

    public static Single<Integer> fillFields(File template, File outputPath, Map<String, String> fields, final byte[] password) {
        return fillFields(Single.just(template)
                .map(
                        new Function<File, PdfReader>() {
                            @Override
                            public PdfReader apply(File file) throws Exception {
                                return new PdfReader(file.toString(), password);
                            }
                        }
                ), outputPath, fields);
    }

    public static Single<Integer> fillFields(String templateContent, File outputPath, Map<String, String> fields, final byte[] password) {
        return fillFields(Single.just(templateContent)
                .map(new Function<String, byte[]>() {
                    @Override
                    public byte[] apply(String content) {
                        return content.getBytes();
                    }
                })
                .map(new Function<byte[], PdfReader>() {
                         @Override
                         public PdfReader apply(byte[] content) throws Exception {
                             return new PdfReader(content, password);
                         }
                     }
                ), outputPath, fields);
    }

    public static Single<Integer> fillFields(byte[] content, File outputPath, Map<String, String> fields, final byte[] password) {
        return fillFields(Single.just(content)
                .map(new Function<byte[], PdfReader>() {
                         @Override
                         public PdfReader apply(byte[] content) throws Exception {
                             return new PdfReader(content, password);
                         }
                     }
                ), outputPath, fields);
    }

    private static Single<Integer> fillFields(Single<PdfReader> reader, final File destination, final Map<String, String> values) {
        return reader
                .map(new Function<PdfReader, Integer>() {
                         @Override
                         public Integer apply(PdfReader pdfReader) throws Exception {
                             OutputStream stream = new FileOutputStream(destination);

                             try {
                                 PdfStamper pdfStamper = new PdfStamper(pdfReader, stream);
                                 AcroFields fields = pdfStamper.getAcroFields();
                                 int modifiedFields = 0;

                                 for (String key : values.keySet()) {
                                     if (fields.setField(key, values.get(key))) {
                                         modifiedFields++;
                                     }
                                 }

                                 pdfStamper.close();

                                 RandomAccessFile f = new RandomAccessFile(destination, "r");
                                 byte[] b = new byte[(int) f.length()];
                                 f.readFully(b);

                                 return modifiedFields;
                             } finally {
                                 stream.close();
                             }
                         }
                     }
                );
    }

}
