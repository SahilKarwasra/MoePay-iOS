//
//  PageIndicator.swift
//  MoePay
//
//  Created by Sahil Karwasrsa on 06/07/26.
//

import SwiftUI

struct PageIndicator: View {
    let total: Int
    let current: Int

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<total, id: \.self) { index in
                Capsule()
                    .fill(index == current ? Color.brandPrimary : Color.borderSubtle)
                    .frame(
                        width: index == current ? 24 : 8,
                        height: 8
                    )
                    .animation(.spring(response: 0.35, dampingFraction: 0.8),value: current)
            }

        }
    }
}
#Preview {
    PageIndicator(total: 4, current: 2)
}
