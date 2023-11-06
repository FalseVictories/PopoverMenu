//
//  File.swift
//  
//
//  Created by iain on 31/10/2023.
//

import AppKit
import Foundation
import SwiftUI

private struct PopoverAnchorView<PopoverMenuContent>: NSViewRepresentable where PopoverMenuContent: View {
    let isShown: Binding<Bool>
    let content: () -> PopoverMenuContent
    let view = NSView()

    func makeNSView(context: Context) -> NSView {
        view
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        context.coordinator.setVisible(isShown.wrappedValue, in: nsView)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(isShown: isShown, content: content)
    }

    class Coordinator: NSObject, NSPopoverDelegate {
        private let popover: NSPopover
        private let isShown: Binding<Bool>

        private var popoverVisible: Bool = false

        init<V: View>(isShown: Binding<Bool>,
                      content: @escaping () -> V) {
            self.popover = NSPopover()
            self.isShown = isShown

            super.init()

            popover.delegate = self
            popover.contentViewController = NSHostingController(rootView: content())
            popover.behavior = .transient
            popover.animates = false
        }

        func setVisible(_ isVisible: Bool, in view: NSView) {
            // Track whether isVisible matches the current state
            // and ignore it if it does
            if isVisible == popoverVisible {
                return
            }
            
            if isVisible {
                popover.show(relativeTo: view.bounds, of: view, preferredEdge: .minY)
            } else {
                popover.close()
            }
        }

        func popoverDidShow(_ notification: Notification) {
            popoverVisible = true
        }

        func popoverDidClose(_ notification: Notification) {
            // If the popover was closed by setting the isShown to false,
            // then it doesn't need updated here as well
            if isShown.wrappedValue {
                isShown.wrappedValue = false
            }
            popoverVisible = false
        }
    }
}

struct PopoverMenuModifier<PopoverMenuContent>: ViewModifier where PopoverMenuContent: View {
    let isPresented: Binding<Bool>
    let contentBlock: () -> PopoverMenuContent

    func body(content: Content) -> some View {
        return content
            .background(PopoverAnchorView(isShown: isPresented, content: contentBlock))
    }
}
