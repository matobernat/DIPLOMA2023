//
//  MockPdfStorageRepository.swift
//  Diploma_2023
//
<<<<<<< HEAD
//  Created by Martin Bernát on 19/09/2023.
//

import Foundation



class MockPdfRepository: PdfRepository {
    private var mockPdfs: [String: Data] = [:]  // Dictionary to store PDF data by URL

    func uploadPdf(_ data: Data, completion: @escaping (Result<String, Error>) -> ()) {
        let fakeURL = UUID().uuidString + ".pdf"  // Generate a fake URL
        mockPdfs[fakeURL] = data
        completion(.success(fakeURL))
    }

    func fetchPdf(with url: String?, completion: @escaping (Result<Data, Error>) -> ()) {
        guard let url = url, let data = mockPdfs[url] else {
            completion(.failure(NSError(domain: "MockPdfRepository",
                                        code: -1,
                                        userInfo: [NSLocalizedDescriptionKey: "PDF not found"])))
            return
        }
        completion(.success(data))
    }

    func deletePdf(url: String?, completion: @escaping (Result<Void, Error>) -> ()) {
        guard let url = url else {
            completion(.success(()))
            return
        }
        mockPdfs.removeValue(forKey: url)
        completion(.success(()))
    }

    func updatePdf(oldUrl: String?, newData: Data, completion: @escaping (Result<String, Error>) -> ()) {
        deletePdf(url: oldUrl) { _ in }
        uploadPdf(newData) { result in
            completion(result)
        }
    }
}


=======
//  Created by Martin Bernát on 03/01/2024.
//

import Foundation
>>>>>>> main
