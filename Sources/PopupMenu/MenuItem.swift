//
//  MenuItem.swift
//  Ohia
//
//  Created by iain on 30/10/2023.
//

import SwiftUI

public struct MenuItem<MenuContent: View>: View {
    let image: Image
    @ViewBuilder let content: () -> MenuContent
    let action: () -> ()

    @State private var hilighted: Bool = false
    var highlightColor: Color {
        hilighted ? Color.accentColor : Color.clear
    }

    public init(image: Image,
                action: @escaping () -> Void,
                @ViewBuilder label: @escaping () -> MenuContent) {
        self.image = image
        self.content = label
        self.action = action
    }

    public var body: some View {
        Button(action: {
            hilighted = false
            action()
        }) {
            Label {
                content()
                Spacer()
            } icon: {
                image
            }
            .frame(minWidth: 150, alignment: .leading)
            .padding(EdgeInsets(top: 4, leading: 10, bottom: 4, trailing: 10))
            .background(RoundedRectangle(cornerSize: CGSize(width: 3, height: 3)).fill(highlightColor))
            .onHover { hovering in
                hilighted = hovering
            }
        }
        .buttonStyle(.borderless)
    }
}

#Preview {
    MenuItem(image: Image(systemName: "bolt.fill"), action:
    {
        print("Clicked")
    })
    {
        Text("Test Menu Item")
    }
        .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
}
