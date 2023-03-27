//
//  GridListView.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 25/03/2023.
//

import SwiftUI

struct GridListView: View {
    
    let items: [IdentifiableItem]
    let dataType: DataType
    let title: String?

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    
    var body: some View {
        ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(items, id: \.id) { item in
                            
                            switch dataType {
                                case DataType.phase:
                                    NavigationLink(
                                        destination: TrainingPlanDetailView(item: item)) {
                                        TrainingPlanCard(item: item)
                                    }
                                
                                case DataType.mezocycle:
                                    NavigationLink(
                                        destination: TrainingPlanDetailView(item: item)) {
                                        TrainingPlanCard(item: item)
                                    }
                                
                            case DataType.client:
                                    NavigationLink(
                                        destination: ClientDetailView(client: item as! ClientMock)) {
                                        TrainingPlanCard(item: item)
                                    }
                                
                            case .exercise:
                                NavigationLink(
                                    destination: TrainingPlanDetailView(item: item)) {
                                    TrainingPlanCard(item: item)
                                }
                            case .foodPlan:
                                NavigationLink(
                                    destination: TrainingPlanDetailView(item: item)) {
                                    TrainingPlanCard(item: item)
                                }
                            case .measurement:
                                NavigationLink(
                                    destination: TrainingPlanDetailView(item: item)) {
                                    TrainingPlanCard(item: item)
                                }
                            case .progressAlbum:
                                NavigationLink(
                                    destination: TrainingPlanDetailView(item: item)) {
                                    TrainingPlanCard(item: item)
                                }
                            case .trainingPlan:
                                if item.dataType == .mezocycle{
                                    NavigationLink(
                                        destination: TrainingPlanDetailView(item: item)) {
                                        TrainingPlanCard(item: item)
                                        }
                                }else{
                                    NavigationLink(
                                        destination: TrainingPlanDetailView(item: item)) {
                                        TrainingPlanCard(item: item)
                                    }
                                }
                            }
                            
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                }
        if let title = title {
            navigationTitle("All \(title)")
        }
    }
}

struct GridListView_Previews: PreviewProvider {
    static var previews: some View {
        GridListView(items: DataModelMock.trainingProtocols, dataType: DataType.phase, title: nil)
    }
}
