//
//  ViewExtension.swift
//  wordcounter
//
//  Created by 최명근 on 2023/04/23.
//

import SwiftUI

extension View {

    func onLoad(perform action: (() -> Void)? = nil) -> some View {
        modifier(ViewDidLoadModifier(perform: action))
    }

}
