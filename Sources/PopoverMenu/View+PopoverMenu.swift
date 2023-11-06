//
//  File.swift
//  
//
//  Created by iain on 31/10/2023.
//

import SwiftUI

extension View {
    public func popoverMenu<Content>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View where Content: View {
        self.modifier(PopoverMenuModifier(isPresented: isPresented, contentBlock: content))
    }
}
