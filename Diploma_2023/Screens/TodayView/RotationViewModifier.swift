//
//  RotationViewModifier.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 09/03/2023.
//

import SwiftUI

// Our custom view modifier to track rotation and
// call our action
struct RotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}

// A View wrapper to make the modifier easier to use
extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(RotationViewModifier(action: action))
    }
}

