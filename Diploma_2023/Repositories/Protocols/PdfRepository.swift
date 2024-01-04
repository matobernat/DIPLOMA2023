//
//  PdfRepository.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 29/04/2023.
//

import Foundation


protocol PdfRepository {
    func uploadPdf(_ data: Data, completion: @escaping (Result<String, Error>) -> ())
    func fetchPdf(with url: String?, completion: @escaping (Result<Data, Error>) -> ())
    func deletePdf(url: String?, completion: @escaping (Result<Void, Error>) -> ())
    func updatePdf(oldUrl: String?, newData: Data, completion: @escaping (Result<String, Error>) -> ())
}
