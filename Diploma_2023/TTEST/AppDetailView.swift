//
//  AppDetailView.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 16/03/2023.
//
import SwiftUI

struct AppDetailView: View {
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Image("app-icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                
                Text("App Name")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("App Developer")
                    .foregroundColor(.gray)
                    .font(.headline)
                
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text("4.9")
                        .foregroundColor(.gray)
                        .font(.headline)
                    Spacer()
                    Text("Categories")
                        .foregroundColor(.gray)
                        .font(.headline)
                }
                
                Text("App Description")
                    .foregroundColor(.primary)
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                
                Button(action: {}) {
                    Text("Get")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(15)
                }
                .padding(.top, 20)
                
                Divider()
                

                AppOverallInfo()
            }
            .padding()
        }
    }
}




struct AppOverallInfo: View {
    
    var body: some View {
        HStack(spacing: 0) {
            AppOverallInfoCard(title1: "AGE", title2: "4+", title3: "Years Old")

            Divider()
            AppOverallInfoCard(title1: "CHART", title2: "No.3", title3: "Finance")
            
            Divider()
            AppOverallInfoCard(title1: "DEVELOPER", title2: "SF Symbol", title3: "Diligent Robot")

            Divider()
            AppOverallInfoCard(title1: "LANGUAGE", title2: "EN", title3: "(English)")

        }
        .padding(.vertical, 20)
    }
}

struct AppOverallInfoCard: View {
    
    let title1: String
    let title2: String
    let title3: String
    
    var body: some View {
        Spacer()
            VStack(alignment: .center, spacing: 5) {
                Text(title1)
                    .font(.headline)
                    .foregroundColor(.gray)
                Text(title2)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(title3)
                    .font(.headline)
                    .foregroundColor(.gray)
            }
            Spacer()
            
    }
}


struct AppDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AppDetailView()
    }
}



