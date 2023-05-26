//
//  PhaseSheetString.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 31/03/2023.
//

import SwiftUI

struct PhaseSheetString: View {
    var headerLabels = ["NAME", "PHASE", "PERIODIZATION", "INTEGRATION GOAL"]
    var headerData = ["Add..", "Add..", "Add..", "Add.."]
    
    
    var sheetLabels = ["Exercise", "Tempo", "Rep", "Set","Rest", "Micro","Load", "Load","Load", "Load"]

    var sheetData = [
        ["Exercise1", "Add..", "Add..", "Add..", "Add..", "Add..", "Add..", "Add..", "Add..", "Add.."],
        ["Exercise1", "Add..", "Add..", "Add..", "Add..", "Add..", "Add..", "Add..", "Add..", "Add.."],
        ["Exercise2", "Add..", "Add..", "Add..", "Add..", "Add..", "Add..", "Add..", "Add..", "Add.."],
        ["Exercise3", "Add..", "Add..", "Add..", "Add..", "Add..", "Add..", "Add..", "Add..", "Add.."]
    ]


    var body: some View {
        ScrollView {
            VStack(spacing: 20){
                Text("Hello")
                
                PhaseHeaderString(labels: headerLabels,data: headerData)
            
                SheetString(labels:sheetLabels ,data: sheetData)
                
            }
        }
        


    }
}


struct PhaseHeaderString: View {
    var labels: [String]
    var data: [String]
    var height: CGFloat = 100
    var width: [CGFloat] = [300,300,300,300]

    var body: some View {
        ScrollView(.horizontal){
            VStack(spacing: 0){
                RowBuilderString(data: labels,
                             width: width,
                             height: 50,
                             color: Color.gray.opacity(0.2))
                RowBuilderString(data: data,
                             width: width,
                             height: height,
                             color: Color.white.opacity(0.2))
            }
        }


    }

    private func columnHeader(_ title: String) -> some View {
        Text(title)
            .padding()
            .background(Color.gray.opacity(0.2))
            .border(Color.gray, width: 1)
    }
}

struct SheetString: View {
    var labels: [String]
    var data: [[String]]
    var height: CGFloat = 100
    var width: [CGFloat] = [300,70,70,70,70,70,200,200,200,200,]

    
    var body: some View {
        Text("Hello")
        
        ScrollView(.horizontal){
            VStack(spacing: 0){
                RowBuilderString(data: labels, width: width, height: height, color: Color.secondary)
                SheetBuilderString(data: data, width: width, height: height, color: Color.white)
            }
        }
    }

    private func columnHeader(_ title: String) -> some View {
        Text(title)
            .padding()
            .background(Color.gray.opacity(0.2))
            .border(Color.gray, width: 1)
    }
}



struct SheetBuilderString: View {
    var data: [[String]]
    var width: [CGFloat]
    var height: CGFloat
    var color: Color

    var body: some View {
        VStack(spacing: 0) {
            ForEach(data.indices, id: \.self) { index in
                RowBuilderString(data: data[index], width: width, height: height, color: color)
            }
        }
    }
}

struct RowBuilderString: View {
    var data: [String]
    var width: [CGFloat]
    var height: CGFloat
    var color: Color

    var body: some View {
        HStack(spacing: 0) {
            ForEach(data.indices, id: \.self) { index in
                CellBuilderString(content: data[index], width: width[index], height: height, color: color)
            }
        }
    }
}

struct CellBuilderString: View {
    var content: String
    var width: CGFloat
    var height: CGFloat
    var color: Color

    var body: some View {
        Text(content)
            .frame(width: width, height: height)
            .background(color)
            .border(Color.gray, width: 1)
    }
}




struct PhaseSheetString_Previews: PreviewProvider {
    static var previews: some View {
        PhaseSheetString()
    }
}
