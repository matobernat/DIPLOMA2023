//
//  Measurements.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 01/10/2023.
//

import Foundation
<<<<<<< HEAD



struct Measurements: IdentifiableItem, Identifiable, Hashable, Encodable, Decodable {
    var id = UUID().uuidString // fireBase UID
    var clientName: String
    var dateOfCreation: Date
    var measurements: [Measurement] // Array of individual Measurement
    
    var title: String
    var dataType = DataType.measurement
    var subTitle: String
    var categoryIDs: [String]
    var clientID: String?
    var profileID: String
    var accountID: String
    var placeholderName = "MeasurementsPlaceholder"
    
    // flag properties
    var inputWasChanged: Bool = false
    var dataWasCalculated: Bool = false
    
    mutating func prepareAllForSave() {
        for index in measurements.indices {
            var measurement = measurements[index]
            measurement.prepareForSave()
            measurements[index] = measurement
        }
    }
    
    // Call this method when a user input changes
    mutating func userInputChanged() {
        self.inputWasChanged = true
        self.recalculateAllRatings(gender: "w")
        self.inputWasChanged = false
    }
    
    // Call this method to recalculate all ratings
    mutating func recalculateAllRatings(gender: String) {
        for (index, _) in measurements.enumerated() {
            measurements[index].recalculateRatings(gender: gender)
        }
    }
    
}


struct Measurement: Identifiable, Hashable, Encodable, Decodable {
    
    var id = UUID().uuidString // fireBase UID
    var date: String
    var age: String // in years, now a String
    var height: String // in cm, now a String
    var weight: String // in kg, now a String
    
    // Body part measurements in mm, now as Strings
    var chin: String // in mm
    var cheek: String // in mm
    var pec: String // in mm
    var triceps: String // in mm
    var subscap: String // in mm
    var midAx: String // in mm
    var suprailiac: String // in mm
    var umbilical: String // in mm
    var knee: String // in mm
    var calve: String // in mm
    var quad: String // in mm
    var hamstring: String // in mm
    var biceps: String // in mm
    
    
    // Ratings for each body part
    var ratingChin: Int?
    var ratingCheek: Int?
    var ratingPec: Int?
    var ratingTriceps: Int?
    var ratingSubscap: Int?
    var ratingMidAx: Int?
    var ratingSuprailiac: Int?
    var ratingUmbilical: Int?
    var ratingKnee: Int?
    var ratingCalve: Int?
    var ratingQuad: Int?
    var ratingHamstring: Int?
    var ratingBiceps: Int?


    
    // New fields for storing computed properties
    var storedLeanMass: Double?
    var storedSumOfMeasurements: Double?
    var storedBodyfat: Double?


}


// functions
extension Measurement{
    
    
    mutating func prepareForSave() {
        self.storedLeanMass = self.leanMass
        self.storedBodyfat = self.bodyfat
        self.storedSumOfMeasurements = self.sumOfMeasurements
    }
    
    
    // Recalculate all ratings (NOT USED, SIMPLE ORDERING)
    mutating func recalculateRatingsOLD(gender: String) {
        let ratingCalculator = Rating()  // Instantiate the Rating struct
        var intermediateValuesDict: [String: Double] = [:]


        // First iteration: Calculate intermediate values
        for (bodyPart, measurementStr) in bodyPartsMeasurementsDict {
            guard let measurement = Double(measurementStr ?? "") else {
                continue  // Skip to the next iteration if the conversion fails
            }

            if let midValue = ratingCalculator.getValue(for: gender, measurementType: "mid", bodyPart: bodyPart) {
                let intermediateValue = ratingCalculator.calculateIntermediateValue(measurement: measurement, gender: gender, midValue: midValue)
                if let value = intermediateValue {
                    intermediateValuesDict[bodyPart] = value
                }
            }
        }


        // Sort intermediateValuesDict by value
        let sortedIntermediateValues = intermediateValuesDict.sorted { $0.value > $1.value }



        // Update ratings based on the sorted order
        for (index, element) in sortedIntermediateValues.enumerated() {

//            print("\(element.key) : \(element.value)")


            setBodyPartRating(element.key, index + 1)  // Ratings start from 1
        }
    }

    
    // Recalculate all ratings (USED NOW KEEPING SAME RATING ON SAME INTERMEDIATE VALUES)
    mutating func recalculateRatings(gender: String) {
        let ratingCalculator = Rating()  // Instantiate the Rating struct
        var intermediateValuesDict: [String: Double] = [:]

        // First iteration: Calculate intermediate values
        for (bodyPart, measurementStr) in bodyPartsMeasurementsDict {
            guard let measurement = Double(measurementStr ?? "") else {
                setBodyPartRating(bodyPart, nil)
                continue  // Skip to the next iteration if the conversion fails
            }

            if let midValue = ratingCalculator.getValue(for: gender, measurementType: "mid", bodyPart: bodyPart) {
                let intermediateValue = ratingCalculator.calculateIntermediateValue(measurement: measurement, gender: gender, midValue: midValue)
                if let value = intermediateValue {
                    intermediateValuesDict[bodyPart] = value
                }
            }
        }

        // Sort intermediateValuesDict by value
        let sortedIntermediateValues = intermediateValuesDict.sorted { $0.value > $1.value }

        // Update ratings based on the sorted order
        var lastIntermediateValue: Double? = nil
        var currentRating = 1

        for (index, element) in sortedIntermediateValues.enumerated() {
//            print("\(element.key) : \(element.value)")

            if let lastValue = lastIntermediateValue, lastValue != element.value {
                currentRating = index + 1  // Update current rating if the last intermediate value is different
            }

            setBodyPartRating(element.key, currentRating)  // Set the rating, identical intermediate values will have the same rating

            lastIntermediateValue = element.value  // Update the last intermediate value for the next iteration
        }
    }


    
}





// MARK: RATING STRUCTS

struct Rating{
    
    typealias BodyPartValue = [String: Double]
    typealias GenderValues = [String: BodyPartValue]
    
    func getValue(for gender: String, measurementType: String, bodyPart: String) -> Double? {
        let value = valueRanges[gender]?[bodyPart]?[measurementType]
        
    
        return valueRanges[gender]?[bodyPart]?[measurementType]
    }
    
    var valueRanges: [String: GenderValues] = [
        "m": [
            "chin": ["min": 1.30, "mid": 1.41, "max": 1.51],
            "cheek": ["min": 1.97, "mid": 1.99, "max": 2.00],
            "pec": ["min": 0.78, "mid": 0.80, "max": 0.81],
            "triceps": ["min": 1.00, "mid": 1.00, "max": 1.00],
            "subscap": ["min": 2.10, "mid": 2.26, "max": 2.41],
            "midAx": ["min": 1.23, "mid": 1.41, "max": 1.58],
            "suprailiac": ["min": 2.00, "mid": 2.15, "max": 2.30],
            "umbilical": ["min": 1.96, "mid": 2.01, "max": 2.06],
            "knee": ["min": 1.51, "mid": 1.63, "max": 1.74],
            "calve": ["min": 0.91, "mid": 0.95, "max": 0.99],
            "quad": ["min": 1.25, "mid": 1.33, "max": 1.40],
            "hamstring": ["min": 1.25, "mid": 1.33, "max": 1.40],
            "biceps": ["min": 0.83, "mid": 0.84, "max": 0.85]
        ],
        "w": [
            "chin": ["min": 0.59, "mid": 0.66, "max": 0.72],
            "cheek": ["min": 0.82, "mid": 0.87, "max": 0.92],
            "pec": ["min": 0.33, "mid": 0.34, "max": 0.35],
            "triceps": ["min": 1.00, "mid": 1.00, "max": 1.00],
            "subscap": ["min": 0.74, "mid": 0.87, "max": 1.00],
            "midAx": ["min": 0.60, "mid": 0.71, "max": 0.81],
            "suprailiac": ["min": 0.64, "mid": 0.78, "max": 0.91],
            "umbilical": ["min": 0.71, "mid": 0.82, "max": 0.92],
            "knee": ["min": 0.58, "mid": 0.60, "max": 0.62],
            "calve": ["min": 0.82, "mid": 0.87, "max": 0.91],
            "quad": ["min": 1.69, "mid": 1.75, "max": 1.80],
            "hamstring": ["min": 1.69, "mid": 1.75, "max": 1.80],
            "biceps": ["min": 0.41, "mid": 0.45, "max": 0.49]
        ]
    ]

    func calculateIntermediateValue(measurement: Double?, gender: String, midValue: Double) -> Double? {
        guard let measurement = measurement else {
            return nil
        }
        
        if gender == "m" {
            return abs(measurement / 4.0 - midValue)
        } else {
            return abs(measurement / 4.0 - midValue)
        }
    }
}




// computed properties
extension Measurement{
    
    // in kg
    var leanMass: Double? {
        guard let weight = Double(self.weight), let bodyfat = self.bodyfat else {
            return nil
        }
        return weight * (1 - bodyfat / 100)
    }
    
    
    
    // in percentage
    var bodyfat: Double? {
        guard let weight = Double(self.weight), let height = Double(self.height), let sum = self.sumOfMeasurements else {
            return nil
        }
        
        // Translating Excel formula to Swift
        let part1 = Measurement.weight_K[0] * pow(weight, Measurement.weight_K[1])

        let part2 = Measurement.height_L[0] * pow(height, Measurement.height_L[1])

        let part3 = abs(sum - ((Measurement.constant_J[1] * pow(height, Measurement.constant_J[2]) * pow(weight, Measurement.constant_J[3]) + Measurement.constant_J[0])))

        let part4 = pow(part3, Measurement.basicFunction_M)

        let bodyfat = Measurement.m_O * (part1 * part2 * part4) + Measurement.b_P
        
        return bodyfat
    }

    
    // in mm
    var sumOfMeasurements: Double? {
        guard let chin = Double(self.chin), let cheek = Double(self.cheek), let pec = Double(self.pec), let triceps = Double(self.triceps), let subscap = Double(self.subscap), let midAx = Double(self.midAx), let suprailiac = Double(self.suprailiac), let umbilical = Double(self.umbilical), let knee = Double(self.knee), let calve = Double(self.calve), let quad = Double(self.quad), let hamstring = Double(self.hamstring), let biceps = Double(self.biceps) else {
            return nil
        }
        return chin + cheek + pec + triceps + subscap + midAx + suprailiac + umbilical + knee + calve //+ quad + hamstring + biceps
    }
    
    
    
    var bodyPartsMeasurementsDict: [String: String?] {
        return [
            "chin": chin,
            "cheek": cheek,
            "pec": pec,
            "triceps": triceps,
            "subscap": subscap,
            "midAx": midAx,
            "suprailiac": suprailiac,
            "umbilical": umbilical,
            "knee": knee,
            "calve": calve,
            "quad": quad,
            "hamstring": hamstring,
            "biceps": biceps
        ]
    }

//    var bodyPartsRatingsDict: [String: Int?] {
//        return [
//            "chin": ratingChin,
//            "cheek": ratingCheek,
//            "pec": ratingPec,
//            "triceps": ratingTriceps,
//            "subscap": ratingSubscap,
//            "midAx": ratingMidAx,
//            "suprailiac": ratingSuprailiac,
//            "umbilical": ratingUmbilical,
//            "knee": ratingKnee,
//            "calve": ratingCalve,
//            "quad": ratingQuad,
//            "hamstring": ratingHamstring,
//            "biceps": ratingBiceps
//        ]
//    }

    
    mutating func setBodyPartRating(_ bodyPart: String, _ rating: Int?) {
        switch bodyPart {
        case "chin":
            ratingChin = rating
        case "cheek":
            ratingCheek = rating
        case "pec":
            ratingPec = rating
        case "triceps":
            ratingTriceps = rating
        case "subscap":
            ratingSubscap = rating
        case "midAx":
            ratingMidAx = rating
        case "suprailiac":
            ratingSuprailiac = rating
        case "umbilical":
            ratingUmbilical = rating
        case "knee":
            ratingKnee = rating
        case "calve":
            ratingCalve = rating
        case "quad":
            ratingQuad = rating
        case "hamstring":
            ratingHamstring = rating
        case "biceps":
            ratingBiceps = rating
        default:
            print("Invalid body part")
        }
    }

    
}





// Measurements constant pool extension
extension Measurement{
    
    // static constants
    struct Constants {
        
        struct SheetTable {
            static let heightHeader: CGFloat = 30
            static let heightContent: CGFloat = 20
            static let cellsWidth: CGFloat = 80
            
            static let sheetLabels: [String] = [
                "Date",
                "Age",
                "Height \n cm",
                "Weight \n kg",
                "Lean Mass",
                "Bodyfat",
                "Chin",
                "Cheek",
                "Pec",
                "Triceps",
                "Subscap",
                "Mid Ax",
                "Suprailiac",
                "Umbilical",
                "Knee",
                "Calve",
                "Quad",
                "Hamstring",
                "Biceps",
                "Sum"
            ]
            static let sheetLabelsUnits: [String] = [
                "",
                "",
                "cm",
                "kg",
                "kg",
                "%",
                "mm",
                "mm",
                "mm",
                "mm",
                "mm",
                "mm",
                "mm",
                "mm",
                "mm",
                "mm",
                "mm",
                "mm",
                "mm",
                "mm"
            ]
            
        }
        
        static let units: [String: String] = [
            "date": "Date",
            "age": "Years",
            "height": "cm",
            "weight": "kg",
            "leanMass": "kg",
            "bodyfat": "%",
            "chin": "mm",
            "cheek": "mm",
            "pec": "mm",
            "triceps": "mm",
            "subscap": "mm",
            "midAx": "mm",
            "suprailiac": "mm",
            "umbilical": "mm",
            "knee": "mm",
            "calve": "mm",
            "quad": "mm",
            "hamstring": "mm",
            "biceps": "mm",
            "sum": "mm"
        ]
    }
    static let constant_J: [Double] = [40, 11.278, -0.725, 0.575]
    static let weight_K: [Double] = [7.811, -0.288]
    static let height_L: [Double] = [0.304, 0.362]
    static let basicFunction_M: Double = 0.5
    static let m_O: Double = 0.483
    static let b_P: Double = -0.006
}





// static factory methods
extension Measurements{
     
    static func getNewMeasurements(selectedClient: Client, categoryIDs: [String]) -> Measurements {
        
        let date = Date.now
        
        // Create an empty Measurement instance
        let emptyMeasurement = Measurement(
            date: "",
            age: "",
            height: "",
            weight: "",
            chin: "",
            cheek: "",
            pec: "",
            triceps: "",
            subscap: "",
            midAx: "",
            suprailiac: "",
            umbilical: "",
            knee: "",
            calve: "",
            quad: "",
            hamstring: "",
            biceps: "",
            ratingChin: nil,
            ratingCheek: nil,
            ratingPec: nil,
            ratingTriceps: nil,
            ratingSubscap: nil,
            ratingMidAx: nil,
            ratingSuprailiac: nil,
            ratingUmbilical: nil,
            ratingKnee: nil,
            ratingCalve: nil,
            ratingQuad: nil,
            ratingHamstring: nil,
            ratingBiceps: nil
        )
        
        // Create an array containing 20 copies of the empty Measurement
        let emptyMeasurements = Array(repeating: emptyMeasurement, count: 20)
        
        return Measurements(
            
            clientName: selectedClient.title,
            dateOfCreation: date,
            measurements: emptyMeasurements,

            title: "\(selectedClient.title)'s measurements",
            subTitle: "created: \(date)",
            categoryIDs: categoryIDs,
            clientID: selectedClient.id,
            profileID: selectedClient.profileID,
            accountID: selectedClient.accountID
        )
    }

}




=======
>>>>>>> main
