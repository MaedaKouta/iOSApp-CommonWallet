//
//  PkhudView.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/05/20.
//

import SwiftUI
import PKHUD

struct PKHUDView: UIViewRepresentable {

    @Binding var isPresented: Bool

    var HUDContent: HUDContentType
    var delay: Double

    func makeUIView(context: UIViewRepresentableContext<PKHUDView>) -> UIView {
        return UIView()
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PKHUDView>) {
        if isPresented {
            HUD.flash(HUDContent, delay: delay) { finished in
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
