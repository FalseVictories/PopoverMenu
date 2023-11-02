//
//  MenuButton.swift
//  Ohia
//
//  Created by iain on 30/10/2023.
//

import SwiftUI

@MainActor
public final class MenuContext: ObservableObject {
    var popupShown: Binding<Bool>?

    func openMenu() {
        print("Will change show")
        popupShown?.wrappedValue = true
        print("Did change show")
    }

    public func closeMenu() {
        print("Will queue close")
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        print("Will change close: \((popupShown != nil) ? "binding set" : "No binding set")")
            popupShown?.wrappedValue = false
            print("did change close")
//        }
        print("did queue close")
    }
}

public struct MenuButton<Content: View, MenuContent: View>: View {
    @ViewBuilder var contents: () -> Content
    @ViewBuilder var menu: (_ context: MenuContext) -> MenuContent

    @State private var hover: Bool = false
    @State private var isShown: Bool = false
    @ObservedObject private var context = MenuContext()

    public init(contents: @escaping () -> Content,
                @ViewBuilder menu: @escaping (_ context: MenuContext) -> MenuContent) {
        self.contents = contents
        self.menu = menu
    }
    
    public var body: some View {
        Button(action: {
//            context.openMenu()
            context.popupShown = $isShown
//            isShown.toggle()
            context.openMenu()
        }) {
            contents()
                .padding()
                .brightness(hover ? 0.1 : 0)
        }
        .buttonStyle(.borderless)
        .popupMenu(isPresented: $isShown) {
            VStack(alignment: .leading) {
                menu(context)
            }
                .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
        }
        .onAppear {
            context.popupShown = $isShown
        }
        .onHover { hovering in
            hover.toggle()
        }
    }
}

#Preview {
    MenuButton() {
        Text("Menu")
    } menu: { context in
        MenuItem(image: Image(systemName: "bolt.fill"), action: {
            context.closeMenu()
        }) {
            Text("Test Menu Item")
        }

        MenuItem(image: Image(systemName: "circle.fill"), action: {
            context.closeMenu()
        }) {
            Text("Red Color")
            Rectangle().fill(.red).frame(width: 32, height: 32)
        }
    }
}
