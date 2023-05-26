//
//  PhaseSheet.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 29/03/2023.
//
import SwiftUI

struct StaticPhaseSheetView: View {

    var phaseInfoTableHeaderLabels = ["NAME", "PHASE", "PERIODIZATION", "INTEGRATION GOAL"]
    var phaseInfoTableHeaderData = ["Add..", "Add..", "Add..", "Add.."]
    
    
    var phaseSheetTableHeaderLabels = ["Exercise", "Tempo", "Rep", "Set","Rest", "Micro","Load", "Load","Load", "Load"]

    var exercisesSettingsTexfieldTexts = [
        ["Exercise1", "Add..", "Add..", "Add..", "Add..", "Add.."],
        ["Exercise2", "Add..", "Add..", "Add..", "Add..", "Add.."],
        ["Exercise3", "Add..", "Add..", "Add..", "Add..", "Add.."],
        ["Exercise4", "Add..", "Add..", "Add..", "Add..", "Add.."],
    ]
    


    var body: some View {
        ScrollView {
            VStack(spacing: 20){
                
                StaticHeader(labels: phaseInfoTableHeaderLabels,data: phaseInfoTableHeaderData)
            
                StaticSheet(labels:phaseSheetTableHeaderLabels ,ExercisesSettings: exercisesSettingsTexfieldTexts)
                
            }
        }

    }
}



struct StaticSheet: View {
    var labels: [String]
    var ExercisesSettings: [[String]]
    var height: CGFloat = 100
    var width: [CGFloat] = [300,70,70,70,70,70,200,200,200,200,]
    
    var body: some View {
        Text("Hello")
        
        ScrollView(.horizontal){
            VStack(spacing: 0){
                // LABEL HEADER
                StaticSheetRowBuilder(exerciseSettingsData: labels, width: width, height: height, color: Color.secondary)
                // TABLE
                StaticSheetBuilder(exercisesSettingsData: ExercisesSettings, width: width, height: height, color: Color.white)
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



struct StaticSheetBuilder: View {
    var exercisesSettingsData: [[String]]
    var width: [CGFloat]
    var height: CGFloat
    var color: Color
    @State var textFields: [[String]] = [["1.\n2.\n3.\n4.\n5.","1.\n2.\n3.\n4.\n5.","1.\n2.\n3.\n4.\n5.","1.\n2.\n3.\n4.\n5."],
                                         ["1.\n2.\n3.\n4.\n5.","1.\n2.\n3.\n4.\n5.","1.\n2.\n3.\n4.\n5.","1.\n2.\n3.\n4.\n5."],
                                         ["1.\n2.\n3.\n4.\n5.","1.\n2.\n3.\n4.\n5.","1.\n2.\n3.\n4.\n5.","1.\n2.\n3.\n4.\n5."],
                                         ["1.\n2.\n3.\n4.\n5.","1.\n2.\n3.\n4.\n5.","1.\n2.\n3.\n4.\n5.","1.\n2.\n3.\n4.\n5."]
    ]

    var body: some View {
        VStack(spacing: 0) {
            ForEach(exercisesSettingsData.indices, id: \.self) { index in
                StaticSheetRowBuilder(exerciseSettingsData: exercisesSettingsData[index], loadsTextFields: $textFields[index], width: width, height: height, color: color)
            }
        }
    }
}


// This Struct may have some indexing error in the future
struct StaticSheetRowBuilder: View {
    var exerciseSettingsData: [String]
    var loadsTextFields: Binding<[String]>?

    var width: [CGFloat]
    var height: CGFloat
    var color: Color



    var body: some View {
        HStack(spacing: 0) {
            
            // Text Cells with data
            ForEach(exerciseSettingsData.indices, id: \.self) { index in
                StaticStaticCellBuilder(content: exerciseSettingsData[index], text: nil, width: width[index], height: height, color: color)
            }
            
            // TextFields with Bindings
            if let textFieldsBinding = loadsTextFields {
                ForEach(textFieldsBinding.indices, id: \.self) { index in
                    StaticStaticCellBuilder(content: nil, text: textFieldsBinding[index], width: width[index + exerciseSettingsData.count], height: height, color: color)
                }
            }

        }
    }
}


struct StaticHeader: View {
    var labels: [String]
    var data: [String]
    var height: CGFloat = 100
    var width: [CGFloat] = [300,300,300,300]

    var body: some View {
        ScrollView(.horizontal){
            VStack(spacing: 0){
                StaticHeaderRowBuilder(data: labels,
                             width: width,
                             height: 50,
                             color: Color.gray.opacity(0.2))
                StaticHeaderRowBuilder(data: data,
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

struct StaticHeaderRowBuilder: View {
    var data: [String]
    var width: [CGFloat]
    var height: CGFloat
    var color: Color

    var body: some View {
        HStack(spacing: 0) {
            ForEach(data.indices, id: \.self) { index in
                StaticStaticCellBuilder(content: data[index], text: nil, width: width[index], height: height, color: color)
            }
        }
    }
}


struct StaticStaticCellBuilder: View {
    var content: String?
    var text: Binding<String>?

    
    var width: CGFloat
    var height: CGFloat
    var color: Color

    var body: some View {
        if let textBinding = text {
            CustomTextEditorCell(textBinding: textBinding,
                         width: width,
                         height: height,
                         color: color)
        } else if let content = content {
            Text(content)
                .frame(width: width, height: height)
                .background(color)
                .border(Color.gray, width: 1)
        } else {
            Text("Input error")
                .frame(width: width, height: height)
                .background(color)
                .border(Color.red, width: 5)
        }
    }
}



struct StaticPhaseSheet_Previews: PreviewProvider {
    static var previews: some View {
        StaticPhaseSheetView()
    }
}

