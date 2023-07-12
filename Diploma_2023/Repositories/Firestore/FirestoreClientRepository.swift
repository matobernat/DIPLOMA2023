//
//  FirebaseClientRepository.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 18/04/2023.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestoreClientRepository: ClientRepository {
    private let collectionName = "clients"
    private let db = Firestore.firestore()
    
    func fetchClients(forUserId userId: String, completion: @escaping (Result<[Client], Error>) -> Void) {
        db.collection(collectionName)
            .whereField("accountID", isEqualTo: userId)
            .order(by: "dateOfCreation", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching clients: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    let clients = snapshot?.documents.compactMap { try? $0.data(as: Client.self) }
                    
                    completion(.success(clients ?? []))
                }
            }
    }
    
    func createClient(_ client: Client, for userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let clientRef = db.collection(collectionName).document(client.id)
        
        do {
            try clientRef.setData(from: client)
            completion(.success(()))
        } catch {
            print("Error creating client: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }
    
    func updateClient(_ client: Client, for userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let clientRef = db.collection(collectionName).document(client.id)
        
        do {
            try clientRef.setData(from: client, merge: true)
            completion(.success(()))
        } catch {
            print("Error updating client: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }
    
    func deleteClient(_ client: Client, for userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let clientRef = db.collection(collectionName).document(client.id)
        
        clientRef.delete { error in
            if let error = error {
                print("Error deleting client: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func clearClientImageUrl(clientId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        print(" \n clientId: \(clientId) \n ")
        
        
        let clientRef = db.collection(collectionName).document(clientId)
        clientRef.updateData(["imageUrl": FieldValue.delete()]) { error in
            if let error = error {
                print("Error clearing client imageUrl: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
