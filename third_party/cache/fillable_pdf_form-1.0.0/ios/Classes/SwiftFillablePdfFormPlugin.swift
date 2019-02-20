import Flutter
import UIKit
import PDFKit

public class SwiftFillablePdfFormPlugin: NSObject, FlutterPlugin {
    
    var pdfDocument: PDFDocument!
    
    // Functionnalities
    private var extractPDF = "extract_pdf_fields"
    private var fillPDF = "fill_pdf_fields"

    // In case the PDF got a password
    private var EXTRA_PDF_PASSWORD = "pdf_password";
    
    // PDF Source (used both to fill and extract fields)
    private var EXTRA_PDF_STORAGE_FILE_PATH = "pdf_file_path";
    private var EXTRA_PDF_FLUTTER_ASSETS_FILE_PATH = "pdf_flutter_file_path";
    private var EXTRA_PDF_APPLICATION_ASSETS_FILE_PATH = "pdf_app_file_path";
    private var EXTRA_PDF_CONTENT = "pdf_content";
    
    // When filling a PDF, a new File will be created
    private var EXTRA_PDF_DESTINATION = "pdf_destination";
    // Content to be filled
    private var EXTRA_PDF_FIELDS_CONTENT = "pdf_fields_content";

    private var registrar: FlutterPluginRegistrar?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "alehos/fillable_pdf_form", binaryMessenger: registrar.messenger())
        let instance = SwiftFillablePdfFormPlugin(registrar)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    init(_ registrar: FlutterPluginRegistrar) {
        self.registrar = registrar
        super.init()
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == extractPDF {
            getPDFValuesAsync(call, result: result)
        } else if call.method == fillPDF {
            fillPDFValuesAsync(call, result: result)
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
    
    func getPDFValuesAsync(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        DispatchQueue.global(qos: .background).async {
            self.loadPdf(call)
            DispatchQueue.main.async {
                self.getPDFValues(call, result: result)
            }
        }
    }
    
    func fillPDFValuesAsync(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        DispatchQueue.global(qos: .background).async {
            self.loadPdf(call)
            DispatchQueue.main.async {
                self.fillPDFValues(call, result: result)
            }
        }
    }
    
    func getPDFValues(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        var dictionary = [String : String]()
        if let doc = self.pdfDocument {
            for index in 0..<doc.pageCount {
                if let page = doc.page(at: index) {
                    let annotations = page.annotations
                    for annotation in annotations {
                        if let key = annotation.fieldName {
                            dictionary[key] = annotation.widgetStringValue
                        }
                    }
                }
            }
        }
        result(dictionary)
    }
    
    func fillPDFValues(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let arguments = call.arguments as? NSDictionary else { return }

        guard let destination = arguments[EXTRA_PDF_DESTINATION] as? String else { return }
        guard let pdfFieldsContent = arguments[EXTRA_PDF_FIELDS_CONTENT] as? [String : String] else { return }

        var fieldFilled: Int = 0
        
        if let doc = self.pdfDocument {
            for index in 0..<doc.pageCount {
                if let page = doc.page(at: index) {
                    let annotations = page.annotations
                    for annotation in annotations {
                        if let pdfField = pdfFieldsContent[annotation.fieldName!] {
                            annotation.widgetStringValue = pdfField
                            fieldFilled+=1
                        }
                    }
                }
            }
        }
        
        let pdfURL = URL(string: destination)
        
        let docPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last?.path)! + "/" + (pdfURL?.lastPathComponent)!
        let docURL = URL(fileURLWithPath: docPath)
        
        guard let data = self.pdfDocument.dataRepresentation() else { return }
        
        do {
            try data.write(to: docURL)
            result(fieldFilled)
        } catch {
            result(error)
        }
    }
    
    func removePDF(url: URL) {
        let fileManager = FileManager.default
        
        do {
            try fileManager.removeItem(at: url)
        } catch {
            print(error)
        }
    }
    
    func loadPdf(_ call: FlutterMethodCall) {
        guard let arguments = call.arguments as? NSDictionary else { return }

        if let pdfPath = arguments[EXTRA_PDF_STORAGE_FILE_PATH] as? String {
            let docPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last?.path)! + "/" + pdfPath
            loadPathFromiOS(docPath)
        } else if let pdfPath = arguments[EXTRA_PDF_FLUTTER_ASSETS_FILE_PATH] as? String {
            loadPathFromFlutterAssets(pdfPath)
        } else if let pdfPath = arguments[EXTRA_PDF_APPLICATION_ASSETS_FILE_PATH] as? String {
            guard let docPath = Bundle.main.path(forResource: pdfPath, ofType: nil) else { return }
            loadPathFromiOS(docPath)
        } else {
            return
        }
    }
    
    func loadPathFromFlutterAssets(_ pdfPath: String) {
        if let path = registrar?.lookupKey(forAsset: pdfPath) {
            if let pathResource = Bundle.main.path(forResource: path, ofType: nil) {
                let url = URL(fileURLWithPath: pathResource)
                if let pdfDocument = PDFDocument(url: url) {
                    self.pdfDocument = pdfDocument
                }
            }
        }
    }
    
    func loadPathFromiOS(_ pdfPath: String) {
        let url = URL(fileURLWithPath: pdfPath)
        if let pdfDocument = PDFDocument(url: url) {
            self.pdfDocument = pdfDocument
        } else {
            guard let docPath = Bundle.main.path(forResource: url.lastPathComponent, ofType: nil) else { return }
            loadPathFromiOS(docPath)
        }
    }
 }
