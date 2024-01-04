//
//  PDFContentView.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 31/10/2023.
//

import SwiftUI
import PDFKit



// MARK: PDF LOADER CLASS

// ViewModel for Data Loading
class PDFLoader: ObservableObject {
    @Published var pdfData: Data? = nil
    @Binding var status: PDFmonkeyStatus?
    @Binding var firebaseURL: String?
    @Published var meesage: String? = nil

    init(status: Binding<PDFmonkeyStatus?>, firebaseURL: Binding<String?>) {
        _status = status
        _firebaseURL = firebaseURL
        self.load()
    }


    func load(from urlString: String? = nil) {
        
        let finalURLString = urlString ?? firebaseURL
        guard let urlString = finalURLString, let url = URL(string: urlString) else {
            print("Invalid URL string: \(String(describing: finalURLString))")
            return
        }
        print("LOADING DATA from url: \(urlString)")

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("Error during URLSession data task: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            DispatchQueue.main.async {
                self.pdfData = data
            }
        }.resume()
    }




}





// MARK: PDFVIEW

// UIViewRepresentable View: This view is what allows uasge of PDFView (from PDFKit) within SwiftUI.
struct PDFViewer: UIViewRepresentable {
    let pdfData: Data

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: Context) {
        uiView.document = PDFDocument(data: pdfData)
    }
}


// Main SwiftUI View: This view is what is used within your main content.
// It fetches the data using the above view model and then displays it using the UIViewRepresentable view.
struct PDFContentView: View {
    @ObservedObject private var pdfLoader: PDFLoader

    init(status: Binding<PDFmonkeyStatus?>, firebaseURL: Binding<String?>) {
        _pdfLoader = ObservedObject(wrappedValue: PDFLoader(status: status, firebaseURL: firebaseURL))
    }

    var body: some View {
        
        Group {
            if let currentStatus = pdfLoader.status {
                switch currentStatus {
                case .Draft, .Pending, .Generating:
                    VStack {
                        ProgressView()
                        Text("Generating your Food Plan...")
                    }
                case .Success:
                    if let pdfData = pdfLoader.pdfData {
                         PDFViewer(pdfData: pdfData)

                    } else {
                        VStack {
                            ProgressView()
                            Text("Loading PDF...")
                        }
                    }
                    
                case .Failrue:
                    Text("Failed to generate the Food Plan.")
                }
            } else {
                VStack {
                    ProgressView()
                    Text("Awaiting Food Plan generation...")
                }
            }
        }
        .onChange(of: pdfLoader.firebaseURL) { newURL in
            pdfLoader.load(from: newURL)
        }
        .onAppear {
            if pdfLoader.status == .Success {
                pdfLoader.load()
            }
        }
    }
}




