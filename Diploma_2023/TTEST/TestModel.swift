//
//  TestModel.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 09/03/2023.
//

import SwiftUI


struct Department: Decodable, Identifiable{
    let id: Int
    let name: String
    let employees: [Employee]
}

struct Employee: Decodable, Identifiable{
    let id: Int
    let name: String
}

class Model {
    let departments: [Department]
    let employees: [Employee]

    init() {
        let employees1 = [
            Employee(id: 1, name: "John"),
            Employee(id: 2, name: "Jane"),
            Employee(id: 3, name: "Jim")
        ]
        let employees2 = [
            Employee(id: 4, name: "Bob"),
            Employee(id: 5, name: "Alice"),
            Employee(id: 6, name: "Bill")
        ]
        let employees3 = [
            Employee(id: 7, name: "Sue"),
            Employee(id: 8, name: "Tom"),
            Employee(id: 9, name: "Anne")
        ]

        self.employees = employees1 + employees2 + employees3
        self.departments = [
            Department(id: 1, name: "Sales", employees: employees1 + employees2),
            Department(id: 2, name: "Marketing", employees: employees2),
            Department(id: 3, name: "Engineering", employees: employees3 + employees1)
        ]
    }

    func department(id: Int?) -> Department? {
        if let id = id {
            return departments.first(where: { $0.id == id })
        } else {
            return nil
        }
    }
    
    func employee(id: Int?) -> Employee? {
        if let id = id {
            return employees.first(where: { $0.id == id })
        } else {
            return nil
        }
    }
}

let model = Model()

