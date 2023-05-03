//
//  ExerciseDetailView.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 19/03/2023.
//

import SwiftUI
import WebKit

// MARK: - Exercise Detail - ViewModel  not used

class ExerciseDetailViewModel: ObservableObject{
    
    @Published var selectedExercise: Exercise
    
    
    init(selectedExercise: Exercise){
        self.selectedExercise = selectedExercise
    }
    
    
    
}



// MARK: - Exercise Detail - View

struct ExerciseDetailView: View {
    
    

    @ObservedObject private var parentVm: ExercisesViewModel
    
    
    init( parentVm: ExercisesViewModel) {
        self.parentVm = parentVm
    }
    
    
    var body: some View {
        ScrollView(.vertical){
            TagList(vm: self.parentVm)
            Divider()
            InfoRowView(items: self.parentVm.getInfoRowItems())
            Divider()
            if let url = URL(string: parentVm.selectedExercise!.link) {
                 Link(parentVm.selectedExercise!.link, destination: url)
             }
            ZStack{
                YoutubeVideoView(link: parentVm.selectedExercise!.link)
                    .scaledToFit()
            }

        }
    }
}




struct YoutubeVideoView: UIViewRepresentable {
    
    var link: String
    
    func makeUIView(context: Context) -> WKWebView  {
            WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
//        let path = "https://www.youtube.com/embed/\(youtubeVideoID)"
        guard let url = URL(string: link) else { return }
        
        uiView.scrollView.isScrollEnabled = false
        uiView.load(.init(url: url))
    }
}



struct TagList: View {
    @ObservedObject var vm: ExercisesViewModel

    var body: some View {
        if !(self.vm.selectedExercise?.tags.isEmpty ?? true) {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))], spacing: 8) {
                ForEach(self.vm.selectedExercise!.tags.sorted(), id: \.self) { tag in
                    HStack {
                        Text(tag)
                            .font(.footnote)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                    }
                }
            }
        } else {
            Text("No tags added")
        }
    }
}


//struct ExerciseDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExerciseDetailView()
//    }
//}
