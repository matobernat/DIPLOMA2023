//
//  SplitViewExtension.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 15/03/2023.
//


import SwiftUI

extension UISplitViewController {
    open override func viewDidLoad() {
        super.viewDidLoad()
        preferredDisplayMode = .twoBesideSecondary
    }
}
