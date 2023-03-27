//
//  ExerciseDetailView.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 19/03/2023.
//

import SwiftUI
import WebKit

struct ExerciseDetailView: View {
    
    let cardTitles = ["Body Part", "Recovery", "Base", "Difficulty"]
    let cardValues = ["Chest", "No", "Bench Press", "Easy"]
    let link = "https://www.youtube.com/watch?v=vthMCtgVtFw&t=54s"
    
    
    var body: some View {
        ScrollView(.vertical){
            TagList()
            Divider()
            InfoRowView(cardTitles: cardTitles, cardValues: cardValues, cardDescriptions: nil)
            Divider()
            Link(link, destination: URL(string: link)!) // 1
            ZStack{
                YoutubeVideoView(link: link)
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



struct TagList: View{
    var body: some View {
        HStack{
            Text("Chest")
            Text("Bilateral")
            Text("Compound")
            Text("Bench")
        }
    }
}

struct ExerciseDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseDetailView()
    }
}
