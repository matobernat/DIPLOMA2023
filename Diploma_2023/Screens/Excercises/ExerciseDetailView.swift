//
//  ExerciseDetailView.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 19/03/2023.
//

import SwiftUI
import WebKit

// MARK: - Exercise Detail - ViewModel  not used




// MARK: - Exercise Detail - View

struct ExerciseDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    
    
    @ObservedObject var vm: ExercisesViewModel
    
    
    var body: some View {
        NavigationStack{
            if let exercise = vm.selectedExercise {
                ScrollView(.vertical){
                    TagList(vm: self.vm)
                        .padding(.leading, 50)
                    Divider()
                    InfoRowView(infoRowItem: self.vm.getInfoRowItems())
                    Divider()
                    if let url = URL(string: exercise.link) {
                         Link(exercise.link, destination: url)
                     }
                    ZStack{
                        YoutubeVideoView(link: exercise.link)
                            .scaledToFit()
                    }

                }
            }
        }

        .navigationTitle(vm.selectedExercise?.title ?? "Select Exercise")
        
        .navigationBarItems(trailing: Button(action: {
            // Empty action, button only used to present ContextMenu
        }, label: {
            Image(systemName: "ellipsis.circle") // This is the "more" button
        }).contextMenu {
            NavigationLink(destination: EditExerciseView(selectedExercise: vm.selectedExercise! ,vm: self.vm)) {
                HStack{
                    Text("Edit Client")
                    Spacer()
                    Image(systemName: "slider.horizontal.3")
                }
                
            }
            Button(action: {
                presentationMode.wrappedValue.dismiss()
                vm.archiveExercise()
                // Call your function to delete the client here
            }, label: {
                HStack{
                    Text("Archive Client")
                    Spacer()
                    Image(systemName: "archivebox")
                }
                .foregroundColor(.red)
            })
            Button(role: .destructive) {
                presentationMode.wrappedValue.dismiss()
                vm.deleteExercise(selectedExercise: vm.selectedExercise!)
                // Call your function to delete the client here
            } label: {
                Label("Delete", systemImage: "trash")
            }
            Button(role: .cancel) {
                // Call your function to delete the client here
            } label: {
                Label("Cancel", systemImage: "xmark")
            }
        })

        
        
        
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
