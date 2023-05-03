//
//  AnyViews.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 28/03/2023.
//

import SwiftUI


struct AnyDetailView: View {
    private let view: AnyView

    init<T: DetailView>(_ view: T) {
        self.view = AnyView(view)
    }

    var body: some View {
        view
    }
}

struct AnyCardView: View {
    private let view: AnyView

    init<T: CardViewMock>(_ view: T) {
        self.view = AnyView(view)
    }

    var body: some View {
        view
    }
}
