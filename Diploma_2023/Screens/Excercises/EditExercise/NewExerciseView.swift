//
//  NewExerciseView.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 01/05/2023.
//

import SwiftUI

// MARK: - NewExercise - ViewModel
class NewExerciseViewModel: ObservableObject {
    @Published var newExercise:Exercise
    
    @Published var tags: [String] = []
    @Published var newTag: String = ""
    
    
    var categories: [Category]
    var selectedCategory: Category
    var loggedAccount: Account
    
    
    
    init(categories: [Category], selectedCategory: Category, loggedAccount: Account) {
        self.categories = categories
        self.selectedCategory = selectedCategory
        self.loggedAccount = loggedAccount

        
        newExercise = Exercise(
            title: "",
            subTitle: "",
            categoryIDs: [],
            dateOfCreation: Date.now,
            accountID: loggedAccount.id,
            
            bodyPart: "",
            recovery: false,
            baseMovement: "",
            difficulty: " ",
            
            link: "",
            tags: [])
    }
    
    
    func createMockExercise() -> Exercise {
        
        let exercisesDict: [String: String] = [
            "Bent neutral row - Band": "https://youtu.be/o5CyBtvfi8M",
            "Telle lateral raise - Band": "https://youtu.be/C7QCthf-Wuw",
            "LP Single arm row neutral (Bent knee)": "https://youtu.be/YB7VI2MvutU",
            "Chest fly - Band": "https://youtu.be/AhPgSVTqs4k",
            "Preacher EZ curls - close grip": "https://youtu.be/Ssbx0t1uDdM",
            "Standing lateral raise - band": "https://youtu.be/7Wo94zCDj3c",
            "Facepull rope to chin": "https://youtu.be/i3W3Vr_kQx4",
            "Single arm row, neutral to supinated - Band": "https://youtu.be/2D7vqD9ZZLg",
            "Biceps curl , supinated - Band with grip": "https://youtu.be/gNGFogZagMg",
            "Ez skullcruhers": "https://youtu.be/8AaBj71PwpQ",
            "Elbow benders - Band with grip": "https://youtu.be/n7rwJiAdlQU",
            "Preacher EZ reverse curls - narrow grip": "https://youtu.be/Eh_rBkqaBoY",
            "Shoulder complex -  Band with grip": "https://youtu.be/AWZxYGzD2z8",
            "45' DB Trap 3 raise": "https://youtu.be/O8vvM9ZuXUk",
            "Low pulley shoulder internal rotation": "https://youtu.be/7UP-paH5ICQ",
            "Preacher EZ reverse curl - close grip": "https://youtu.be/2vX2MCw8DmY",
            "Facepull rope to nose": "https://youtu.be/LRnvER1kPOQ",
            "Standing french press - Band": "https://youtu.be/A4Y4_0hpqXc",
            "DB triceps extensions (Flat bench)": "https://youtu.be/Exnsoj0Tj8g",
            "Dip - Chair": "https://youtu.be/AWONFsF3Zl4",
            "DB seated zottman curls": "https://youtu.be/S7z-6q7vIBM",
            "Lateral raise pronated - Band with grip": "https://youtu.be/XzCXxnGmgQw",
            "Preacher EZ curls - narrow grip": "https://youtu.be/Gey5W_iXWwg",
            "DB seated hammer curls": "https://youtu.be/qjo1o8VSkdE",
            "DB seated comerford curls": "https://youtu.be/ryqCuGsisPg",
            "Rope to forehead": "https://youtu.be/iCFS51Pj4-U",
            "Bent row, neutral to supinated - Band with grip": "https://youtu.be/zU0XU4vxll8",
            "Ex rotations abducted - Band with grip": "https://youtu.be/gxNYqsBKU2w"]
        let titleLinkPair = exercisesDict.randomElement()
        
        
        let muscleTypes = [
            "Abs", "Arms", "Back", "Chest", "Legs", "Shoulders"
        ]

        let gymEquipment = [
            "Barbell", "Bench", "Cable Machine", "Dumbbell", "Kettlebell", "Pull-Up Bar", "Smith Machine"
        ]

        let movements = [
            "Bench Press", "Deadlift", "Lunge", "Pull-Up", "Push-Up", "Squat"
        ]

        let tags = muscleTypes + gymEquipment + movements
        
        let randomCount = Int.random(in: 1...tags.count) // generate a random count between 1 and the size of the array
        let randomTags = (0..<randomCount).compactMap { _ in tags.randomElement() } // get random non-nil elements from the array

        

        return Exercise(
            title: titleLinkPair?.key ?? "Exercise",
            subTitle: "Add Description..",
            categoryIDs: getCategoryIDs(),
            dateOfCreation: Date.now,
            accountID: loggedAccount.id,
            
            bodyPart: muscleTypes.randomElement()!,
            recovery: Bool.random(),
            baseMovement: movements.randomElement()!,
            difficulty: ["Easy","Intermediate","Hard"].randomElement()!,
            
            link: titleLinkPair?.value ?? "Invalid Link",
            tags: Set(randomTags)
            )
    }
    
    func getCategoryIDs() -> [String]{
        var IDs=[String]()
//        self.selectedCategory.id
        
        for category in self.categories {
            
            // if archived, add only to archived
            if self.selectedCategory.name.contains("Archived"){
                if category.name.contains("Archived"){
                    IDs.append(category.id)
                }
                continue
            }
                
                
            // This is the default rule
            if category.name.contains("All") ||
                category.name.contains("Recent") ||
                category.name.contains("My") {
                
                IDs.append(category.id)
            }
            
            // Favorites is optional
            if self.selectedCategory.name.contains("Favorite"){
                if category.name.contains("Favorite"){
                    IDs.append(category.id)
                }
            }
            
        }
        return IDs
    }
    
}



// MARK: - NewExercise - View
struct NewExerciseView: View {
    
    @ObservedObject private var parentVm: ExercisesViewModel
    @ObservedObject private var vm: NewExerciseViewModel
    
    init( parentVm: ExercisesViewModel) {
        self.parentVm = parentVm
        self.vm = NewExerciseViewModel(categories: parentVm.categories,
                                     selectedCategory: parentVm.selectedCategory!,
                                     loggedAccount: parentVm.loggedAccount!)
        
    }
    
    var body: some View {
        NavigationView {
            
            Form {
                
                Button("Create mocked Exercise") {

                    // parentVm uploads client to DB and updates allClients list
                    parentVm.createExercise(exercise: vm.createMockExercise())
                    parentVm.isShowingForm = false
                    
                }
                
                Section(header: Text("Default Information")) {
                    TextField("Name", text: $vm.newExercise.title)
                    TextField("Description", text: $vm.newExercise.subTitle)
                    TextField("Youtube link", text: $vm.newExercise.link)
                }
                
                Section(header: Text("Exercise Information")) {
                    // Toggle Picker
                    VStack(alignment: .leading, spacing: 8) {
                        Toggle("Recovery", isOn: $vm.newExercise.recovery)
                        Text("Determine if is this exercise used for recovery")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    TextField("Body part", text: $vm.newExercise.bodyPart)
                    TextField("Base movement", text: $vm.newExercise.baseMovement)
                    TextField("difficulty", text: $vm.newExercise.difficulty)
                }
                
                VStack {
                     Label("Add Tag:", systemImage: "tag")
                     HStack {
                         TextField("Type tag name", text: $vm.newTag, onCommit: addTag)
                             .textFieldStyle(.roundedBorder)
                         Button("Add") {
                             addTag()
                         }
                     }
                    TagListView(tags: vm.tags, onDelete: removeTag)
                 }
                
                
            }
        }
        .navigationTitle("Add new Exercise")
    }
    
    func addTag() {
        let tag = vm.newTag.trimmingCharacters(in: .whitespacesAndNewlines)
        if !tag.isEmpty && !vm.tags.contains(tag) {
            vm.tags.append(tag)
            vm.newTag = ""
        }
    }
    
    func removeTag(_ tag: String) {
        vm.tags.removeAll { $0 == tag }
    }
}



struct TagBubble: View {
    let tag: String
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            Text(tag)
                .font(.footnote)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            Button(action: onDelete) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red)
                    .padding(4)
            }
        }
    }
}

struct TagListView: View {
    let tags: [String]
    let onDelete: (String) -> Void
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))], spacing: 8) {
            ForEach(tags, id: \.self) { tag in
                TagBubble(tag: tag) {
                    onDelete(tag)
                }
            }
        }
    }
}

//
//struct NewExerciseView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewExerciseView()
//    }
//}
