//
//  TextFieldExtension.swift
//  Numo test1
//
//  Created by Тасік on 29.03.2024.
//

import Foundation
import SwiftUI

extension TextField {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        
        overlay {
            if shouldShow {
                placeholder().frame(maxWidth: .infinity, alignment: alignment)
            }
        }
    }
}
