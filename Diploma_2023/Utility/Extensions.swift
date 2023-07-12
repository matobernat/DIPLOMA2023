//
//  Extensions.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 22/03/2023.
//

import Foundation



// DUPLICATE PHASE
extension Phase {
    
    // clean duplicate nothing more
    func duplicate() -> Phase {
        var copy = self
        copy.id = UUID().uuidString
        copy.dateOfCreation = Date()
//        copy.phaseName = keepName == true ? copy.phaseName : String.duplicateTitle(copy.phaseName, existingTitles: existingTitles)
        return copy
    }
    
    // clean duplicate nothing more
    func duplicateWithClearedLoads() -> Phase {
        var copy = self
        copy.id = UUID().uuidString
        copy.dateOfCreation = Date()
//        copy.phaseName = keepName == true ? copy.phaseName : String.duplicateTitle(copy.phaseName, existingTitles: existingTitles)

        // Iterate through each SheetRow in copy.sheetRows and clear the loads
        copy.sheetRows = copy.sheetRows.map { $0.clearLoads() }
        return copy
    }
    
    func setNewName(existingTitles:[String]) -> Phase{
        var copy = self
        copy.phaseName = String.duplicateTitle(copy.phaseName, existingTitles: existingTitles)
        return copy
    }

    // set ClientID
    func setClientID(clientID: String, clientName: String) -> Phase {
        var copy = self
        copy.clientID = clientID
        copy.headerClientName = clientName
        return copy
    }
    
    
    func setMezoID(mezoID: String) -> Phase{
        var copy = self
        copy.mezocycleID = mezoID
        return copy
    }
    
    func clearMezoID() -> Phase{
        var copy = self
        copy.mezocycleID = nil
        return copy
    }
    
    func getNumberOfAllAvailableSessions() -> Int{
        return Int(self.phaseDurationInWeeks) ?? 6
    }
    
    func getNumberOfAllFinishedSessions() -> Int{
        return self.highestCountOfNonEmptyLoads()
    }
    
    func highestCountOfNonEmptyLoads() -> Int {
        let counts = self.sheetRows.map { $0.countNonEmptyLoads() }
        return counts.max() ?? 0
    }
    
    
}


// clear Loads
extension SheetRow{
    func clearLoads() -> SheetRow {
        var copy = self
        copy.allLoadsPerPhase = [Load(),Load(),Load(),Load(),Load(),Load()]
        return copy
    }

    
    func getNumberOfAllFinishedSessions() -> Int{
        return countNonEmptyLoads()
    }
    
    func countNonEmptyLoads() -> Int {
        let nonEmptyLoads = self.allLoadsPerPhase.filter { $0.loadString != "" }
        return nonEmptyLoads.count
    }
}



extension Mezocycle{
    
    func setNewName(existingTitles:[String]) -> Mezocycle{
        var copy = self
        copy.title = String.duplicateTitle(copy.title, existingTitles: existingTitles)
        return copy
    }
    
    // duplicate (create new ID + assign new mezoID to all it's phases)
    func duplicate() -> Mezocycle {
        var copy = self
        copy.id = UUID().uuidString
        copy.dateOfCreation = Date()
        
        copy.phases = copy.phases.map { $0.setMezoID(mezoID: copy.id) }
//        copy.title = keepName == true ? copy.title : String.duplicateTitle(copy.title, existingTitles: existingTitles)
        return copy
    }
    
    
    // set clientID + all phases clientID
    func setClientID(clientID: String, clientName:String) -> Mezocycle {
        var copy = self
        copy.clientID = clientID
        copy.clientName = clientName
        copy.phases = copy.phases.map { $0.setClientID(clientID: clientID, clientName: clientName) }
         return copy
    }
    
    
    

    /// - Returns: The mezocycle with the new phase added
    func addPhase(phase: Phase) -> Mezocycle{
        var copy = self
        copy.phases.append(phase)
        return copy
    }
    
    
    // this function is essential when modifying phase inside mezocycle
    /// - Returns: The mezocycle with the updated phase
    func updatePhase(phase: Phase) -> Mezocycle {
        guard let index = self.phases.firstIndex(where: { $0.id == phase.id }) else {
            // Mezocycle with the given ID not found, return the original mezocycle
            return self
        }
        var copy = self
        copy.phases[index] = phase
        
        return copy
    }
    
    /// This function deletes a phase based on ID
    /// - Returns: The mezocycle with the deleted phase
    func deletePhase(phaseID: String) -> Mezocycle {
        var copy = self
        copy.phases.removeAll(where: { $0.id == phaseID })
        
        return copy
    }
    
}


















extension Mezocycle{
    func getNumberOfAllAvailableSessions() -> Int {
        let totalAvailableSessions = phases.reduce(0) { $0 + $1.getNumberOfAllAvailableSessions() }
        return totalAvailableSessions
    }
    
    func getNumberOfAllFinishedSessions() -> Int {
        let totalFinishedSessions = phases.reduce(0) { $0 + $1.getNumberOfAllFinishedSessions() }
        return totalFinishedSessions
    }
    
    func getInfoRowItems()-> [InfoRowItem]{
        let item1 = InfoRowItem(title: "DURATION", value: "\(self.durationInMonths)+", description: "Months")
        let item2 = InfoRowItem(title: "TRAINING FOCUS", value: "\(self.trainingFocus)", description: "")
        let item3 = InfoRowItem(title: "INTENSITY", value: "\(self.intensity)", description: "level")
        let item4 = InfoRowItem(title: "PROGRESSION STRATEGY", value: "\(self.progressionStrategy)", description: "")
        let item5 = InfoRowItem(title: "IN TOTAL ", value: "\(self.totalTrainings)", description: "Tranings")
        
        return [item1,item2,item3,item4,item5]

    }
}

// DUPLICATE TITLE
extension String {
    static func duplicateTitle(_ title: String, existingTitles: [String]) -> String {
        let pattern = "^" + title + " copy( \\d+)?$"
        var maxCopyNumber = 0
        let regex = try? NSRegularExpression(pattern: pattern, options: [])

        for existingTitle in existingTitles {
            if let match = regex?.firstMatch(in: existingTitle, options: [], range: NSRange(location: 0, length: existingTitle.utf16.count)) {
                if match.numberOfRanges > 1 {
                    let range = match.range(at: 1)
                    if range.location != NSNotFound, let range = Range(range, in: existingTitle) {
                        let copyNumberString = String(existingTitle[range]).trimmingCharacters(in: CharacterSet.whitespaces)
                        if let copyNumber = Int(copyNumberString) {
                            maxCopyNumber = Swift.max(maxCopyNumber, copyNumber)
                        }
                    }
                } else {
                    maxCopyNumber = Swift.max(maxCopyNumber, 1)
                }
            }
        }

        if maxCopyNumber == 0 {
            return title + " copy"
        }

        return title + " copy " + String(maxCopyNumber + 1)
    }
}



// UI CONSTANTS
extension Phase {
    struct Constants {
        struct InfoTable {
            static let height: CGFloat = 50
        
            static func width(isEditing: Bool) -> [CGFloat] {
                return isEditing ? [150, 150, 150, 150, 150, 150] : [200, 200, 200, 200, 200]
            }
            
            static func headerLabels(isEditing: Bool) -> [String] {
                return isEditing
                    ? ["PHASE NAME", "DURATION - IN WEEKS", "PHASE", "PERIODIZATION", "INTEGRATION GOAL"]
                    : ["CLIENT NAME", "PHASE", "PERIODIZATION", "INTEGRATION GOAL"]
            }
        }
        
        struct SheetTable {
            static let heightHeader: CGFloat = 50
            static let heightContent: CGFloat = 80
            
            static func width(isEditing: Bool) -> [CGFloat] {
                return isEditing ? [200, 120, 120, 120, 120, 120] : [200, 80, 80, 80, 80, 80, 130, 130, 130, 130,130, 130, 130, 130,130, 130, 130, 130,130, 130, 130, 130]
            }
            
            static let headerExerciseSettingsLabels = ["Exercise", "Tempo", "Rep", "Set", "Rest", "Micro"]
            static let headerLoadLabels = ["Load", "Load", "Load","Load","Load", "Load", "Load","Load","Load", "Load", "Load","Load","Load", "Load", "Load","Load"]
        }
    }
}



// UI CONSTANTS + FILLING WITH RANDOM DATA
extension Mezocycle{
    struct Constants {
        struct InfoRow{
            static let titles: [String] = ["Movie Star", "Superman", "Arnold's Plan", "Hypertrophy 1.0"]
            static let mezocycleAttributes: [String: [String]] = [
                "Duration": ["4 months", "8 months", "12 months"],
                "Training Focus": ["Hypertrophy", "Strength", "Power", "Endurance"],
                "Intensity": ["Beginner", "Intermediate", "Pro", "Athlete", "Superhuman"],
                "Progression Strategy": ["Linear progression", "Undulating periodization", "Block periodization"],
                "Total Tranings":["20","30","40","50","120",]
            ]
            static let descriptions: [String] = [
                "The 'Movie Star' mesocycle is the epitome of intensity, glamour, and transformation. Designed for individuals aspiring to achieve a physique worthy of the silver screen, this mesocycle takes your training to legendary heights. With a combination of cutting-edge exercises, strategic programming, and relentless dedication, the 'Movie Star' mesocycle promises to sculpt your muscles, enhance your strength, and unleash your inner star power. Each session is meticulously crafted to maximize muscle growth, build stunning definition, and sculpt the ultimate physique.You'll experience exhilarating workouts that blend explosive movements, targeted muscle isolation, and advanced training techniques.This mesocycle spares no expense in delivering results that will leave you feeling like the leading role in your own fitness journey.",
                "As you embark on this transformative training program, expect unparalleled gains in muscle size, strength, and aesthetics. From the chiseled chest to the sculpted abs, every muscle group is meticulously targeted to create a physique that turns heads and commands attention.Just like the stars of the silver screen, the 'Movie Star' mesocycle promises to take your fitness journey to blockbuster heights. Embrace the challenge, unleash your inner star, and prepare to witness a physique transformation that will leave everyone around you in awe. Get ready to step into the spotlight and shine like never before with the legendary 'Movie Star' mesocycle.",
                "Prepare to be captivated by dynamic workouts that push your limits and leave you feeling like a superhero. Each session is meticulously crafted to maximize muscle growth, build stunning definition, and sculpt the ultimate physique. You'll experience exhilarating workouts that blend explosive movements, targeted muscle isolation, and advanced training techniques. Lights, camera, action!",
                "This mesocycle spares no expense in delivering results that will leave you feeling like the leading role in your own fitness journey. As you embark on this transformative training program, expect unparalleled gains in muscle size, strength, and aesthetics. From the chiseled chest to the sculpted abs, every muscle group is meticulously targeted to create a physique that turns heads and commands attention."
            ]

        }
    }
    func randomizeAttributes() -> Mezocycle {
        var randomMezocycle = self
        
        // Randomly select values from the constants
        randomMezocycle.title = Constants.InfoRow.titles.randomElement() ?? ""
        randomMezocycle.durationInMonths = Constants.InfoRow.mezocycleAttributes["Duration"]?.randomElement() ?? ""
        randomMezocycle.trainingFocus = Constants.InfoRow.mezocycleAttributes["Training Focus"]?.randomElement() ?? ""
        randomMezocycle.intensity = Constants.InfoRow.mezocycleAttributes["Intensity"]?.randomElement() ?? ""
        randomMezocycle.progressionStrategy = Constants.InfoRow.mezocycleAttributes["Progression Strategy"]?.randomElement() ?? ""
        randomMezocycle.totalTrainings = Constants.InfoRow.mezocycleAttributes["Total Tranings"]?.randomElement() ?? ""
        randomMezocycle.description = Constants.InfoRow.descriptions.randomElement() ?? ""
        
        return randomMezocycle
    }
}
