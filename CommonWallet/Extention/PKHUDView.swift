//
//  PkhudView.swift
//  CommonWallet
//

import SwiftUI
import PKHUD

struct PKHUDView: UIViewRepresentable {

    @Binding var isPresented: Bool

    var HUDContent: HUDContentType
    var delay: Double

    func makeUIView(context: UIViewRepresentableContext<PKHUDView>) -> UIView {
        HUD.hide()
        return UIView()
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PKHUDView>) {
        if isPresented {
            HUD.hide()
            HUD.flash(HUDContent, delay: delay) { _ in
                isPresented = false
            }
        } else {
            HUD.hide()
        }
    }

}

struct PKHUDViewModifier<Parent: View>: View {

    @Binding var isPresented: Bool
    var HUDContent: HUDContentType
    var delay: Double
    var parent: Parent

    var body: some View {
        ZStack {
            parent
            if isPresented {
                PKHUDView(isPresented: $isPresented, HUDContent: HUDContent, delay: delay)
            }
        }
    }

}

extension View {
    public func PKHUD(isPresented: Binding<Bool>, HUDContent: HUDContentType, delay: Double) -> some View {
        PKHUDViewModifier(isPresented: isPresented, HUDContent: HUDContent, delay: delay, parent: self)
    }
}
