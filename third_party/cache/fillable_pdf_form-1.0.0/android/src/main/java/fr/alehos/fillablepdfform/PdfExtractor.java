package fr.alehos.fillablepdfform;

import com.itextpdf.text.pdf.AcroFields;
import com.itextpdf.text.pdf.PdfReader;

import java.io.File;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;

import io.reactivex.Single;
import io.reactivex.SingleSource;
import io.reactivex.functions.Function;
import io.reactivex.schedulers.Schedulers;

final class PdfExtractor {

    public static Single<HashMap<String, String>> extractParams(InputStream inputStream, final byte[] password) {
        return extractParams(Single.just(inputStream)
                .map(new Function<InputStream, PdfReader>() {
                    @Override
                    public PdfReader apply(InputStream inputStream) throws Exception {
                        return new PdfReader(inputStream, password);
                    }
                }));
    }

    public static Single<HashMap<String, String>> extractParams(File file, final byte[] password) {
        return extractParams(Single.just(file)
                .map(new Function<File, PdfReader>() {
                    @Override
                    public PdfReader apply(File file) throws Exception {
                        return new PdfReader(file.toString(), password);
                    }
                }));
    }

    public static Single<HashMap<String, String>> extractParams(String content, final byte[] password) {
        return Single.just(content)
                .map(new Function<String, byte[]>() {
                    @Override
                    public byte[] apply(String content) {
                        return content.getBytes();
                    }
                }).flatMap(new Function<byte[], SingleSource<? extends HashMap<String, String>>>() {
                    @Override
                    public SingleSource<? extends HashMap<String, String>> apply(byte[] bytes) {
                        return extractParams(bytes, password);
                    }
                });
    }

    public static Single<HashMap<String, String>> extractParams(byte[] content, final byte[] password) {
        return extractParams(Single.just(content)
                .map(new Function<byte[], PdfReader>() {
                    @Override
                    public PdfReader apply(byte[] bytes) throws Exception {
                        return new PdfReader(bytes, password);
                    }
                }));
    }

    private static Single<HashMap<String, String>> extractParams(Single<PdfReader> reader) {
        return reader
                .map(new Function<PdfReader, AcroFields>() {
                    @Override
                    public AcroFields apply(PdfReader pdfReader) {
                        return pdfReader.getAcroFields();
                    }
                })
                .map(extractFields())
                .onErrorReturn(new Function<Throwable, HashMap<String, String>>() {
                    @Override
                    public HashMap<String, String> apply(Throwable throwable) {
                        return new HashMap<>(0);
                    }
                })
                .subscribeOn(Schedulers.computation());
    }

    private static Function<AcroFields, HashMap<String, String>> extractFields() {
        return new Function<AcroFields, HashMap<String, String>>() {
            @Override
            public HashMap<String, String> apply(AcroFields acroFields) {
                Map<String, AcroFields.Item> fields = acroFields.getFields();
                HashMap<String, String> params = new HashMap<>(fields.size());

                for (String key : fields.keySet()) {
                    params.put(key, acroFields.getField(key));
                }

                return params;
            }
        };
    }

}
