//
<<<<<<< HEAD
//  FoodPlansDataStore.swift
=======
//  FoodPlanDataStore.swift
>>>>>>> main
//  Diploma_2023
//
//  Created by Martin Bernát on 19/10/2023.
//

import Foundation
import Combine


class FoodPlansDataStore: ObservableObject {
    @Published private(set) var allFoodPlans: [FoodPlan] = []
    private let foodPlansRepository: FoodPlansRepository
    private let pdfRepository: PdfRepository
    private let authenticationService: AnyAuthenticationService
    
    private var cancellable: AnyCancellable?
    
    init(foodPlansRepository: FoodPlansRepository, pdfRepository: PdfRepository, authenticationService: AnyAuthenticationService) {
        self.foodPlansRepository = foodPlansRepository
        self.pdfRepository = pdfRepository
        self.authenticationService = authenticationService
        
        cancellable = authenticationService.$userId.sink { [weak self] userId in
            if let userId = userId {
                print("FETCHING FOOD PLAN USER IN ")
                self?.fetchFoodPlans(forUserId: userId)
            } else {
                self?.allFoodPlans = [] // Clear the mezos when the user logs out
            }
        }
    }
    
    deinit {
        cancellable?.cancel()
    }
    

    func getFoodPlan(foodPlanID: String?) -> FoodPlan?{
        return allFoodPlans.first(where: { $0.id == foodPlanID})
    }
    
    
    func fetchFoodPlans(forUserId userId: String) {
<<<<<<< HEAD
        foodPlansRepository.fetchFoodPlans(forUserId: userId) { [weak self] result in
=======
        foodPlanRepository.fetchFoodPlans(forUserId: userId) { [weak self] result in
>>>>>>> main
            switch result {
            case .success(let foodPlans):
                DispatchQueue.main.async {
                    self?.allFoodPlans = foodPlans
                }
            case .failure(let error):
                print("Error fetching foodPlans: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self?.allFoodPlans = []
                }
            }
        }
    }
    
<<<<<<< HEAD
    func createFoodPlan(_ foodPlan: FoodPlan, completion: @escaping (Result<Void, Error>) -> Void) {
=======
    func createMezo(_ foodPlan: FoodPlan, completion: @escaping (Result<Void, Error>) -> Void) {
>>>>>>> main
        guard let userId = authenticationService.userId else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID is not available"])))
            return
        }
        
<<<<<<< HEAD
        foodPlansRepository.createFoodPlan(foodPlan, for: userId) { [weak self] result in
=======
        mezoRepository.createFoodplan(foodPlan, for: userId) { [weak self] result in
>>>>>>> main
            switch result {
            case .success:
                // Fetch the updated mezos
                self?.fetchFoodPlans(forUserId: userId)
                completion(.success(()))
            case .failure(let error):
                print("Error adding foodPlan: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
<<<<<<< HEAD
    func updateFoodPlan(_ foodPlan: FoodPlan, completion: @escaping (Result<Void, Error>) -> Void) {
=======
    func updateMezo(_ foodPlan: FoodPlan, completion: @escaping (Result<Void, Error>) -> Void) {
>>>>>>> main
        guard let userId = authenticationService.userId else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID is not available"])))
            return
        }
        
<<<<<<< HEAD
        foodPlansRepository.updateFoodPlan(foodPlan, for: userId) { [weak self] result in
=======
        mezoRepository.updateFoodPlan(foodPlan, for: userId) { [weak self] result in
>>>>>>> main
            switch result {
            case .success:
                print("FoodPlan updated successfully")
                // Fetch the updated mezos
<<<<<<< HEAD
                self?.fetchFoodPlans(forUserId: userId)
=======
                self?.fetchFoodplans(forUserId: userId)
>>>>>>> main
                completion(.success(()))
            case .failure(let error):
                print("Error updating foodPlan: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    func deleteFoodPlan(_ foodPlan: FoodPlan, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let userId = authenticationService.userId else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID is not available"])))
            return
        }
        
<<<<<<< HEAD
        foodPlansRepository.deleteFoodPlan(foodPlan, for: userId) { [weak self] result in
=======
        mezoRepository.deleteFoodPlan(foodPlan, for: userId) { [weak self] result in
>>>>>>> main
            switch result {
            case .success:
                print("FoodPlan deleted successfully")
                // Fetch the updated mezos
                self?.fetchFoodPlans(forUserId: userId)
                completion(.success(()))
            case .failure(let error):
                print("Error deleting foodPlan: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
}




// MARK: - FoodPLan - PDFmonkey extension
<<<<<<< HEAD
extension FoodPlansDataStore {
=======
extension FoodPlansDatastore {

    func createPDF(for foodPlan: FoodPlan, completion: @escaping (Result<String, Error>) -> Void) {
        // Set up the URL and request
        let url = URL(string: "https://api.pdfmonkey.io/api/v1/documents")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // Use your API key here, but remember to shift this to Cloud Functions later
        request.setValue("vzAExYeQ7_Q_fxmYT9zdzdB8VcARhYi_", forHTTPHeaderField: "Authorization")

        // Get the JSON body
        let jsonBody = foodPlan.getDocumentJSON(templateId: "YOUR_TEMPLATE_ID")
        request.httpBody = try? JSONSerialization.data(withJSONObject: jsonBody)

        // Send the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle the response
            if let error = error {
                completion(.failure(error))
                return
            }

            if let data = data, let jsonResponse = try? JSONSerialization.jsonObject(with: data) as? [String: Any], let documentId = jsonResponse["id"] as? String {
                completion(.success(documentId))
            } else {
                // Handle any error scenario
                completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
            }
        }

        task.resume()
    }

>>>>>>> main

}



<<<<<<< HEAD
extension FoodPlansDataStore {
    
    func sendInputToPDFMonkey(requestBody: Data, apiKey:String, completion: @escaping (Result<Data, Error>) -> ()) {
        let apiUrl = "https://api.pdfmonkey.io/api/v1/documents"
        
=======
extension FoodPlansDatastore {

    func sendInputToPDFMonkey(jsonData: Data, completion: @escaping (Result<Data, Error>) -> ()) {
        
        let apiUrl = "https://api.pdfmonkey.io/api/v1/documents" // Replace this with the appropriate PDFMonkey endpoint if it's different
        
        // Create a URL object
>>>>>>> main
        guard let url = URL(string: apiUrl) else {
            completion(.failure(NSError(domain: "FoodPlanDatastore",
                                        code: -1,
                                        userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
<<<<<<< HEAD
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
//        request.addValue("Bearer vzAExYeQ7_Q_fxmYT9zdzdB8VcARhYi_", forHTTPHeaderField: "Authorization")
        request.httpBody = requestBody
        
=======
        // Set up the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("vzAExYeQ7_Q_fxmYT9zdzdB8VcARhYi_", forHTTPHeaderField: "Authorization") // Replace with your actual API key
        request.httpBody = jsonData
        
        // Start the data task
>>>>>>> main
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
<<<<<<< HEAD
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "FoodPlanDatastore",
                                            code: -1,
                                            userInfo: [NSLocalizedDescriptionKey: "Failed to get HTTP response"])))
                return
            }
            
            if !(200...299).contains(httpResponse.statusCode) {
                if let data = data, let bodyString = String(data: data, encoding: .utf8) {
                    completion(.failure(NSError(domain: "FoodPlanDatastore",
                                                code: httpResponse.statusCode,
                                                userInfo: [NSLocalizedDescriptionKey: "Server error. Code: \(httpResponse.statusCode). Response: \(bodyString)"])))
                } else {
                    completion(.failure(NSError(domain: "FoodPlanDatastore",
                                                code: httpResponse.statusCode,
                                                userInfo: [NSLocalizedDescriptionKey: "Server error. Code: \(httpResponse.statusCode)."])))
                }
=======
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "FoodPlanDatastore",
                                            code: -1,
                                            userInfo: [NSLocalizedDescriptionKey: "Server error"])))
>>>>>>> main
                return
            }
            
            if let data = data {
                completion(.success(data))
            } else {
                completion(.failure(NSError(domain: "FoodPlanDatastore",
                                            code: -1,
                                            userInfo: [NSLocalizedDescriptionKey: "No data received"])))
            }
        }
        
<<<<<<< HEAD
//        print("URL: \(request.url?.absoluteString ?? "None")")
//        print("HTTP Method: \(request.httpMethod ?? "None")")
//        print("Headers: \(request.allHTTPHeaderFields ?? [:])")
//        if let httpBody = request.httpBody, let bodyString = String(data: httpBody, encoding: .utf8) {
//            print("Body: \(bodyString)")
//        } else {
//            print("Body: None")
//        }

=======
>>>>>>> main
        task.resume()
    }
    
    
<<<<<<< HEAD
    
    func sendGetRequest(url: URL, apiKey:String, completion: @escaping (Result<Data, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Add headers if necessary, like authentication.
        // Add authentication header
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        print("SENDIND GET request")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(PDFMonkeyError.noData))
                return
            }
            
            print("data: \(data)")
            completion(.success(data))
        }.resume()
    }
    
    
    
    // Define the structure for parsing the response from PDFMonkey
    struct PDFMonkeyDocumentResponse: Decodable {
        struct Document: Decodable {
            let id: String
            let status: String
            let download_url: String?
            let failure_cause: String?
            // Add other keys here if needed
        }
        
        let document: Document
    }

    func receiveResponseFromPDFMonkeyOLD(responseData: Data, completion: @escaping (Result<Data, Error>) -> Void) {
        
        print(String(data: responseData, encoding: .utf8) ?? "Failed to print response as string")

        
=======

    // Define a custom error type for better error handling
    enum PDFMonkeyError: Error {
        case invalidStatus
        case missingDownloadURL
        case downloadFailed
    }

    func receiveResponseFromPDFMonkey(responseData: Data, completion: @escaping (Result<Data, Error>) -> Void) {
>>>>>>> main
        // Parse the response
        do {
            let parsedResponse = try JSONDecoder().decode(PDFMonkeyDocumentResponse.self, from: responseData)

<<<<<<< HEAD
            print("parsedResponse: \(parsedResponse)")
            // Check the status
            guard parsedResponse.document.status == "success" else {
=======
            // Check the status
            guard parsedResponse.status == "success" else {
>>>>>>> main
                completion(.failure(PDFMonkeyError.invalidStatus))
                return
            }

            // Confirm the download URL exists
<<<<<<< HEAD
            guard let downloadURLString = parsedResponse.document.download_url,
=======
            guard let downloadURLString = parsedResponse.download_url,
>>>>>>> main
                  let downloadURL = URL(string: downloadURLString) else {
                completion(.failure(PDFMonkeyError.missingDownloadURL))
                return
            }

            // Fetch the PDF from the download URL
            URLSession.shared.dataTask(with: downloadURL) { (data, _, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(PDFMonkeyError.downloadFailed))
                    return
                }

                completion(.success(data))
            }.resume()

        } catch {
<<<<<<< HEAD
            print("receiveResponseFromPDFMonkey catch")
            completion(.failure(error))
        }
    }
    
    
    
    enum RequestType {
        case initialRequest // For POST
        case statusCheck    // For GET
    }
    
    
    func retrievePDFMonkeyRequest(responseData: Data, requestType: RequestType, completion: @escaping (Result<String, Error>) -> Void) {
        
        print("\n retrievePDFMonkeyRequest:")
//        print(String(data: responseData, encoding: .utf8) ?? "Failed to print response as string")
//        print(responseData)
//        print("\n")
        
        // Parse the response
        do {
            let parsedResponse = try JSONDecoder().decode(PDFMonkeyDocumentResponse.self, from: responseData)
//            print("parsedResponse: \(parsedResponse)")
            
            // Check for failure cause
            if let failureCause = parsedResponse.document.failure_cause {
                completion(.failure(PDFMonkeyError.invalidStatus))
                return
            }

            switch requestType {
            case .initialRequest:
                // Confirm that the status is 'generating'
                guard parsedResponse.document.status == "generating" else {
                    completion(.failure(PDFMonkeyError.invalidStatus))
                    return
                }
                
                // Return the document ID
                print("RETRIEVED DOCUMENT ID")
                completion(.success(parsedResponse.document.id))
                
            case .statusCheck:
                // Confirm that the status is 'success'
                guard parsedResponse.document.status == "success" else {
                    print("GET retrieval failure")
                    completion(.failure(PDFMonkeyError.invalidStatus))
                    return
                }
                
                // Confirm the download URL exists
                guard let downloadURLString = parsedResponse.document.download_url else {
                    completion(.failure(PDFMonkeyError.missingDownloadURL))
                    return
                }
                
                // Return the download URL
                completion(.success(downloadURLString))
            }
            
        } catch {
            print("retrievePDFMonkeyRequest catch")
            completion(.failure(error))
        }
=======
            completion(.failure(error))
        }
    }

    // Define the structure for parsing the response from PDFMonkey
    struct PDFMonkeyDocumentResponse: Decodable {
        let status: String
        let download_url: String?
>>>>>>> main
    }

    
    
    
    
<<<<<<< HEAD
    
    
    
    
    func sendPDFtoFirestore(data: Data, completion: @escaping (Result<String, Error>) -> ()) {
        
        pdfRepository.uploadPdf(data) { result in
=======
    func sendPDFtoFirestore(data: Data, completion: @escaping (Result<String, Error>) -> ()) {
        
        foodPlanRepository.uploadPdf(data) { result in
>>>>>>> main
            switch result {
            case .success(let urlKey):
                completion(.success(urlKey))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    

}





// MARK: - FoodPLan - Complete Processes extension
<<<<<<< HEAD
extension FoodPlansDataStore {

    // returns URL key
//    func generateFoodPlan(completion: @escaping (Result<String, Error>) -> ()) {
////    func generateFoodPlan(completion: @escaping (Result<URL, Error>) -> ()) {
//
//        // 1. Send the JSON to PDFMonkey using the function from the previous extension.
//        // 2. Receive the generated PDF.
//        // 3. Upload the PDF to Firebase Storage using the PdfRepository.
//        // 4. Retrieve the URL from Firebase Storage.
//        // 5. Create and upload the FoodPlan object to Firestore.
//        // 6. Return the URL or any other relevant data to the caller.
//
//        if let bodyData = FoodPlan.createRequestBody(forTemplate: FoodPlan.template1_ID, withJSONString: FoodPlan.template1_InputData) {
//            sendInputToPDFMonkey(jsonData: bodyData) { result in
//                print(" result: \(result)")
//                switch result {
//                case .success(let responseData):
//                    self.receiveResponseFromPDFMonkey(responseData: responseData) { result in
//                        switch result {
//                        case .success(let pdfData):
//                            // Upload the PDF to Firestore
//                            self.sendPDFtoFirestore(data: pdfData) { result in
//                                switch result {
//                                case .success(let urlKey):
//                                    // Further processing, maybe saving the FoodPlan object to Firestore?
//                                    // ...
//
//                                    // For now, just return the URL key
//                                    //completion(.success(URL(string: urlKey)!))
//                                    completion(.success(urlKey))
//
//                                case .failure(let error):
//                                    completion(.failure(error))
//                                }
//                            }
//                        case .failure(let error):
//                            completion(.failure(error))
//                        }
//                    }
//                case .failure(let error):
//                    completion(.failure(error))
//                }
//            }
//        } else {
//            // Handle the error creating the request body
//        }
//    }
    
}









// MARK: - FoodPLan - Complete Processes extension New Pipeline
extension FoodPlansDataStore {

    // Define a custom error type for better error handling
    enum PDFMonkeyError: Error {
        case invalidRequestBody
        case invalidStatus
        case missingDownloadURL
        case downloadFailed
        case invalidURL
        case emptyData
        case noData
        case foodPlanNotFound
        case timeout
    }
    

    
    func createAndRetrieveDocument(withPayload payloadString: String, forFoodPlan foodPlan: FoodPlan, completion: @escaping (Result<String, Error>) -> Void) {

=======
extension FoodPlansDatastore {

    // returns URL key
    func createFoodPlan(json: Data, completion: @escaping (Result<URL, Error>) -> ()) {
>>>>>>> main
        
        // 1. Send the JSON to PDFMonkey using the function from the previous extension.
        // 2. Receive the generated PDF.
        // 3. Upload the PDF to Firebase Storage using the PdfRepository.
        // 4. Retrieve the URL from Firebase Storage.
        // 5. Create and upload the FoodPlan object to Firestore.
        // 6. Return the URL or any other relevant data to the caller.
<<<<<<< HEAD
        
        let apiKey = foodPlan.apiKey
        let documentID = foodPlan.pdfMonkeyTemplateID
        
        // SEND POST REQUEST WITH PAYLOAD
        initiateDocumentGeneration(forTemplate: documentID, apiKey: apiKey, withPayloadString: payloadString) { result in
            switch result {
            case .success(let documentID):
                self.storeDocumentInTemporaryState(documentID: documentID, foodPlan: foodPlan)
                
                // CYCLE THE GET REQUEST
                self.waitForDocumentCompletion(documentID: documentID, apiKey: apiKey) { result in
                    print("waitForDocumentCompletion - DONE result: \(result)")

                    switch result {
                    case .success(let downloadURL):
                        // GET PDF REQUEST
                        self.downloadPDF(fromURL: downloadURL, apiKey: apiKey) { result in
                            switch result {
                            case .success(let pdfData):
                                self.uploadPDFToFirebase(pdfData: pdfData) { result in
                                    switch result {
                                    case .success(let firebaseURL):
                                        self.updateFoodPlanStatus(firebaseURL: firebaseURL, foodPlanId: foodPlan.id) { result in
                                            switch result {
                                            case .success():
                                                completion(.success((firebaseURL)))
                                            case .failure(let error):
                                                completion(.failure(error))
                                            }
                                        }
                                    case .failure(let error):
                                        print("DOWNLOADING PDF FAILURE")
                                        completion(.failure(error))
                                    }
                                }
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }



    
    func initiateDocumentGeneration(forTemplate templateID: String, apiKey: String,  withPayloadString payloadString: String, completion: @escaping (Result<String, Error>) -> Void) {
        // Using existing POST request function here.
        // Return the document ID if the request is successful.

        
        guard let requestBody = FoodPlan.createRequestBody(forTemplate: templateID, withJSONString: payloadString) else {
            completion(.failure(PDFMonkeyError.invalidRequestBody))
            return
        }

        // SENDING POST RQUEST
        sendInputToPDFMonkey(requestBody: requestBody, apiKey: apiKey) { [self] result in
            switch result {
            case .success(let data):
                // RETRIEVING POST REQUEST documentID
                retrievePDFMonkeyRequest(responseData: data, requestType: .initialRequest) { result in
                    switch result {
                    case .success(let documentID):
                        completion(.success(documentID))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }


    func storeDocumentInTemporaryState(documentID: String, foodPlan: FoodPlan) {
        // Store the document ID with a "pending" status in Firestore.

        let updatedPlan = foodPlan.setStatus(status: .Generating).setDocumentID(documentID: documentID)
        
        // CREATING A FOODPLAN
        self.updateFoodPlan(updatedPlan) { result in
            // handle result
        }
    }

    
    func checkDocumentStatus(documentID: String, apiKey:String,  completion: @escaping (Result<String, Error>) -> Void) {
        // Make a GET request to PDFmonkey using the document ID.
        // Return the status of the document.
        guard let url = URL(string: "https://api.pdfmonkey.io/api/v1/documents/\(documentID)") else {
            completion(.failure(PDFMonkeyError.invalidURL))
            return
        }
        
        sendGetRequest(url: url, apiKey: apiKey) { result in
            switch result {
            case .success(let data):
                self.retrievePDFMonkeyRequest(responseData: data, requestType: .statusCheck) { result in
                    switch result {
                    case .success(let downloadURL):
                        print("retrievePDFMonkeyRequest SUCCESSFUL: ulrRequest: \(downloadURL)")
                        completion(.success(downloadURL))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }


    func waitForDocumentCompletion(documentID: String, apiKey: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        // Use a timer or other mechanism to periodically call `checkDocumentStatus`.
        // If the status is "Success", call the completion handler with `true`.
        // If there's an error or timeout, call the completion handler with `false`.
        
        let timeout = 180.0 // Desired timeout in seconds.
        let checkInterval = 10.0 // Interval to check the document status.
        
        let timeoutDate = Date().addingTimeInterval(timeout)
        var timer: Timer?
        
        
        let checkStatus = {
            if Date() >= timeoutDate {
                timer?.invalidate()
                completion(.failure(PDFMonkeyError.timeout)) // You can create a custom timeout error.
                return
            }
            print("CHECK STATUS STARTED")
            
            print(Thread.isMainThread) // should print 'true'

            // SEND GET REQUEST
            self.checkDocumentStatus(documentID: documentID, apiKey: apiKey) { result in
                switch result {
                case .success(let downloadURL):
                    timer?.invalidate() // Stop the timer when we've retrieved the download URL.
                    completion(.success(downloadURL))
                case .failure(let error):
                    
                    print("CHECK STATUS: FAILURE - CONTINUE")

                    // You can log the error here if necessary.
                    // The timer will automatically call `checkStatus` again after the interval.
                }
            }
        }

        DispatchQueue.main.async {
            timer = Timer.scheduledTimer(withTimeInterval: checkInterval, repeats: true) { _ in
                print("Timer START")
                checkStatus()
            }
        }

        //RunLoop.current.add(timer!, forMode: .common)

        // Start the first check immediately instead of waiting for the first timer interval.
        checkStatus()
    }

    
    
    
    
    func downloadPDF(fromURL url: String, apiKey: String, completion: @escaping (Result<Data, Error>) -> Void) {
        // Download the PDF and return its Data.

        guard let validURL = URL(string: url) else {
            completion(.failure(PDFMonkeyError.invalidURL))
            return
        }
        
        print("DOWNLOAD PDF FROM PDFMONKEY STARTED url: \(url)")

        var request = URLRequest(url: validURL)
        request.httpMethod = "GET"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: validURL) { data, _, error in
            if let error = error {
                print("DOWNLOAD PDF ERORR: \(error)")
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(PDFMonkeyError.emptyData))
                return
            }


            print("DOWNLOAD SUCCESS: \(data.count)")
            completion(.success(data))
        }.resume()
    }

    
    func uploadPDFToFirebase(pdfData: Data, completion: @escaping (Result<String, Error>) -> Void) {
        
        print("uploadPDFToFirebase START")
        // Upload the PDF to Firebase storage.
        // Return the Firebase storage URL.
        pdfRepository.uploadPdf(pdfData, completion: completion)
    }


    func updateFoodPlanStatus(firebaseURL: String, foodPlanId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // Try to retrieve the foodPlan from the collection
        guard let foodPlan = self.getFoodPlan(foodPlanID: foodPlanId) else {
            completion(.failure(PDFMonkeyError.foodPlanNotFound)) // Return an error if the foodPlan is not found
            return
        }
        
        // If found, update the status and Firebase URL
        let updatedPlan = foodPlan.setStatus(status: .Success).setFirebaseUrl(url: firebaseURL)
        
        // Assuming you have a function called `createFoodPlan` to save the changes
        self.createFoodPlan(updatedPlan) { result in
            switch result {
            case .success():
                completion(.success(())) // Notify of successful update
            case .failure(let error):
                completion(.failure(error)) // Forward the error
            }
        }
    }



}
=======

        if let bodyData = createRequestBody(forTemplate: templateID, withData: jsonData) {
            sendInputToPDFMonkey(jsonData: bodyData) { result in
                switch result {
                case .success(let responseData):
                    receiveResponseFromPDFMonkey(responseData: responseData) { result in
                        switch result {
                        case .success(let pdfData):
                            // Upload the PDF to Firestore
                            sendPDFtoFirestore(data: pdfData) { result in
                                switch result {
                                case .success(let urlKey):
                                    // Further processing, maybe saving the FoodPlan object to Firestore?
                                    // ...

                                    // For now, just return the URL key
                                    completion(.success(URL(string: urlKey)!))
                                case .failure(let error):
                                    completion(.failure(error))
                                }
                            }
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            // Handle the error creating the request body
        }
    }


}



>>>>>>> main

