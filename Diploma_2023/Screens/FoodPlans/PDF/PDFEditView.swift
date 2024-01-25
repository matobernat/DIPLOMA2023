//
//  PDFEditView.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 01/11/2023.
//

import SwiftUI

<<<<<<< HEAD

// MARK: [UnifiedPage] needs to be decoupled into ObservableObjects to prevent re-rendering of whole Views
// and then it needs to be "coupled back" by manually updating all poperties back so the whole [UnifiedPage] can be passed into parent view for saving

// UI structure
//struct UnifiedPage: Hashable {
//    var name: String
//    var title: String?
//    var subtitle: String?
//
//    var bulletGroups: [BulletGroup]?
//
//    struct BulletGroup: Hashable {
//        var subsubtitle: String?
//        var bullets: [String]?
//    }
//}


// MARK: ViewModels -


//PDFEdit ViewModel
class PDFEditViewModel: ObservableObject {
    @Published var pageViewModels: [UnifiedPageViewModel]

    init(pages: [UnifiedPage]) {
        self.pageViewModels = pages.map { UnifiedPageViewModel(page: $0) }
    }

    private func commitPageViewModelChanges() {
        for viewModel in pageViewModels {
            viewModel.commitChanges()
        }
    }

    func getCurrentData() -> [UnifiedPage] {
        commitPageViewModelChanges()
        return pageViewModels.map { $0.page }
    }
}




// UnifiedPage
class UnifiedPageViewModel: ObservableObject {
    @Published var page: UnifiedPage
    @Published var title: String?
    @Published var subtitle: String?
    @Published var bulletGroupViewModels: [BulletGroupViewModel]

    init(page: UnifiedPage) {
        self.page = page
        self.title = page.title
        self.subtitle = page.subtitle
        self.bulletGroupViewModels = page.bulletGroups?.map { BulletGroupViewModel(bulletGroup: $0) } ?? []
    }

    
    func updateSubtitle(_ newSubtitle: String?) {
        if subtitle != newSubtitle {
            subtitle = newSubtitle
            page.subtitle = newSubtitle
        }
    }

    func updateBulletGroups(_ newBulletGroups: [UnifiedPage.BulletGroup]) {
        bulletGroupViewModels = newBulletGroups.map { BulletGroupViewModel(bulletGroup: $0) }
        page.bulletGroups = newBulletGroups
    }

    func commitChanges() {
        page.title = title
        page.subtitle = subtitle
        page.bulletGroups = bulletGroupViewModels.map { $0.commitChanges() }
    }
    
}



class BulletGroupViewModel: ObservableObject {
    @Published var bulletGroup: UnifiedPage.BulletGroup
    @Published var subsubtitle: String?
    @Published var bulletViewModels: [BulletViewModel]

    init(bulletGroup: UnifiedPage.BulletGroup) {
        self.bulletGroup = bulletGroup
        self.subsubtitle = bulletGroup.subsubtitle
        self.bulletViewModels = bulletGroup.bullets?.map { BulletViewModel(text: $0) } ?? []
    }

    func updateSubsubtitle(_ newSubsubtitle: String?) {
        if subsubtitle != newSubsubtitle {
            subsubtitle = newSubsubtitle
            bulletGroup.subsubtitle = newSubsubtitle
        }
    }

    func updateBullets(_ newBullets: [String]) {
        bulletViewModels = newBullets.map { BulletViewModel(text: $0) }
        bulletGroup.bullets = newBullets
    }

    func commitChanges() -> UnifiedPage.BulletGroup {
        bulletGroup.subsubtitle = subsubtitle
        bulletGroup.bullets = bulletViewModels.map { $0.text }
        return bulletGroup
    }
}


class BulletViewModel: ObservableObject {
    @Published var text: String

    init(text: String) {
        self.text = text
    }
    
    func updateText(_ newText: String) {
        if self.text != newText {
            self.text = newText
        }
    }
}







// MARK: Views -
struct PDFEditView: View {
    
//    @Binding var unifiedPages: [UnifiedPage]
    @State private var useGrayBackground = true  // Toggle this to switch between styles

    @ObservedObject var viewModel: PDFEditViewModel // Change to ObservableObject

    
    
    
    // Initialize pageViewModels when unifiedPages change
    init(viewModel: PDFEditViewModel) {
        self.viewModel = viewModel
    }
    

    
    var body: some View {
        ScrollView {
        
            VStack(alignment: .leading, spacing: 20) {
//                ForEach(, id: \.self) { $page in
                ForEach(viewModel.pageViewModels.indices, id: \.self) { index in
                    let viewModel = viewModel.pageViewModels[index]
                    Section(header: Text(viewModel.page.name).font(.headline)) {
//                        PageEditorView(page: $page, useGrayBackground: $useGrayBackground)
                        PageEditorView(useGrayBackground: $useGrayBackground, viewModel: viewModel)
                    }
                }
            }
            .padding()
        }
        .onAppear {
            print(" \n  RENDER: PDFEditView \n")
        }
    }
    
//    // Function to commit changes and return updated data
//    func getUpdatedData() -> [UnifiedPage] {
//        for viewModel in pageViewModels {
//            viewModel.commitChanges()
//        }
//        return pageViewModels.map { $0.page }
//    }
}


struct PageEditorView: View {
//    @Binding var page: UnifiedPage
    @Binding var useGrayBackground: Bool
    
    @ObservedObject var viewModel: UnifiedPageViewModel // Change to ObservableObject

    

    var body: some View {

        VStack(alignment: .leading, spacing: 15) {
//            TitleField(title: $page.title)
//            SubtitleField(subtitle: $page.subtitle)
            TitleField(title: $viewModel.title) // Bind to ViewModel
            SubtitleField(subtitle: $viewModel.subtitle) // Bind to ViewModel
            

//            // Check if bulletGroups exist, if not, provide an empty array
//            let bulletGroupsBinding = Binding(
//                get: { self.viewModel.bulletGroups ?? [] },
//                set: {
//                    print("Updating bulletGroups")
//                    self.page.bulletGroups = $0.isEmpty ? nil : $0 }
//            )
//
//            ForEach(Array(bulletGroupsBinding.wrappedValue.enumerated()), id: \.element) { (index, _) in
//                BulletGroupEditorView(bulletGroup: bulletGroupsBinding[index], useGrayBackground: $useGrayBackground)
//            }
            
            
            // Iterate over bulletGroupViewModels
            ForEach(viewModel.bulletGroupViewModels.indices, id: \.self) { index in
                BulletGroupEditorView(viewModel: viewModel.bulletGroupViewModels[index], useGrayBackground: $useGrayBackground)
            }
            
            
        }.onAppear{print(" \n  RENDER: PageEditorView \n")}
    }
}



struct TitleField: View {
    @Binding var title: String?

    var body: some View {
        if let t = title {
            TextField("Title", text: Binding<String>(
                get: { title ?? "" },
                set: { title = $0 }
            ))
            .padding(10)
            .background(Color(UIColor.systemGray6))
            .cornerRadius(5)
            .onAppear{print(" \n  RENDER: TitleField \n")}
        }
            
    }
}

struct SubtitleField: View {
    @Binding var subtitle: String?

    var body: some View {
        
        
        if let sub = subtitle {
            TextField("Title", text: Binding<String>(
                get: { subtitle ?? "" },
                set: { subtitle = $0 }
            ))
            .padding(10)
            .background(Color(UIColor.systemGray6))
            .cornerRadius(5)
            .onAppear{print(" \n  RENDER: SubtitleField \n")}
        }
    }
}


struct BulletGroupEditorView: View {
//    @Binding var bulletGroup: UnifiedPage.BulletGroup
    @ObservedObject var viewModel: BulletGroupViewModel

    @Binding var useGrayBackground: Bool

    var body: some View {
        // Only show the TextField for subsubtitle if it exists
//        if let subsubtitle = bulletGroup.subsubtitle {
//                        TextField("Subsubtitle", text: Binding(
//                            get: { subsubtitle },
//                            set: { bulletGroup.subsubtitle = $0.isEmpty ? nil : $0 }
//                        ))
//        }
        
        TextField("Subsubtitle", text: Binding<String>(
            get: { viewModel.subsubtitle ?? "" },
            set: { viewModel.subsubtitle = $0.isEmpty ? nil : $0 }
        ))
        .padding(7)
        .background(Color(UIColor.systemGray6))
        .cornerRadius(5)
        
        
        // Only show the list of bullet points if there are any
//        if let bullets = bulletGroup.bullets {
//        if let bullets = viewModel.bulletViewModels {
//            
//            }
            
        
        ForEach(viewModel.bulletViewModels.indices, id: \.self) { index in
            HStack {
                Text("•")
                TextField("", text: $viewModel.bulletViewModels[index].text)
                .padding(10)
                .background(useGrayBackground ? Color(UIColor.systemGray6) : Color.clear)
                .cornerRadius(5)
            }
            
            
            
//            ForEach(bullets.indices, id: \.self) { index in
//                HStack {
//                    Text("•")
//                    TextField("", text: Binding(
//                        get: { bullets[index] },
//                        set: { bulletGroup.bullets?[index] = $0 }
//                        set: { viewModel.bullets[index] = $0 }
//                    ))
//                    .padding(10)
//                    .background(useGrayBackground ? Color(UIColor.systemGray6) : Color.clear)
//                    .cornerRadius(5)
//                }
//            }
        }
    }
}




//struct PageEditorView: View {
//    @Binding var page: UnifiedPage
//    @Binding var useGrayBackground: Bool
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 15) {
//            TitleField(title: $page.title)
//            SubtitleField(subtitle: $page.subtitle)
//
//            if let bulletGroups = page.bulletGroups {
//                ForEach(bulletGroups.indices, id: \.self) { index in
//                    BulletGroupEditorView(bulletGroup: $page.bulletGroups[index]!, useGrayBackground: $useGrayBackground)
//                }
//            }
//        }
//    }
//}



//ForEach(0..<unifiedPages[pageIndex].bulletGroups.count, id: \.self) { groupIndex in
//    ForEach(0..<unifiedPages[pageIndex].bulletGroups[groupIndex].count, id: \.self) { bulletIndex in
//        HStack {
//            Text("•")
//            if useGrayBackground {
//                TextField("", text: $unifiedPages[pageIndex].bulletGroups[groupIndex][bulletIndex])
//                    .padding(10)
//                    .background(Color(UIColor.systemGray6))
//                    .cornerRadius(5)
//            } else {
//                TextField("", text: $unifiedPages[pageIndex].bulletGroups[groupIndex][bulletIndex])
//                    .padding(10)
//                    .background(
//                        Color.white
//                            .cornerRadius(5)
//                            .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 2)
//                    )
//
//            }
//        }
//    }
//}



//struct PDFEditViewOLD: View {
//    @Binding var unifiedPages: [UnifiedPage]
//    @State private var useGrayBackground = true  // Toggle this to switch between styles
//
//
//    var body: some View {
//        ScrollView {
//            Button {
//                useGrayBackground.toggle()
//            } label: {
//                Text("TOGGLE")
//            }
//
//            VStack(alignment: .leading, spacing: 20) {
//                ForEach(0..<unifiedPages.count, id: \.self) { pageIndex in
//                    VStack(alignment: .leading, spacing: 15) {
//                        Text(unifiedPages[pageIndex].name)
//                            .font(.headline)
//                        ForEach(0..<unifiedPages[pageIndex].bulletGroups.count, id: \.self) { groupIndex in
//                            ForEach(0..<unifiedPages[pageIndex].bulletGroups[groupIndex].count, id: \.self) { bulletIndex in
//                                HStack {
//                                    Text("•")
//                                    if useGrayBackground {
//                                        TextField("", text: $unifiedPages[pageIndex].bulletGroups[groupIndex][bulletIndex])
//                                            .padding(10)
//                                            .background(Color(UIColor.systemGray6))
//                                            .cornerRadius(5)
//                                    } else {
//                                        TextField("", text: $unifiedPages[pageIndex].bulletGroups[groupIndex][bulletIndex])
//                                            .padding(10)
//                                            .background(
//                                                Color.white
//                                                    .cornerRadius(5)
//                                                    .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 2)
//                                            )
//
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//            .padding()
//        }
//    }
//}


=======
struct PDFEditView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct PDFEditView_Previews: PreviewProvider {
    static var previews: some View {
        PDFEditView()
    }
}
>>>>>>> main
