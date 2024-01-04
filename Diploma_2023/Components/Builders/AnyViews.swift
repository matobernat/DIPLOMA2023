//
//  AnyViews.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 28/03/2023.
//

import SwiftUI


protocol DetailView: View {
    init(item: IdentifiableItem)
}

struct AnyDetailView: View {
    private let view: AnyView

    init<T: DetailView>(_ view: T) {
        self.view = AnyView(view)
    }

    var body: some View {
        view
    }
}


protocol CardView: View {
    init(item: IdentifiableItem)
}

struct AnyCardView: View {
    private let view: AnyView

    init<T: CardView>(_ view: T) {
        self.view = AnyView(view)
    }

    var body: some View {
        view
    }
}
