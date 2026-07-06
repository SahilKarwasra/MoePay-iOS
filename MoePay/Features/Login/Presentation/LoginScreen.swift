//
//  LoginScreen.swift
//  MoePay
//
//  Created by Sahil Karwasrsa on 06/07/26.
//

import SwiftUI

struct LoginScreen: View {
    var body: some View {
        VStack {
            VerticalSpacer(height: 16)
            Text("Phone number")
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(Color.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)

            VerticalSpacer(height: 8)
            
            Text("Enter your phone number")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.textSecondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
        }.padding(.horizontal, 16).frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .topLeading
        )
        
        
    }
}

#Preview {
    LoginScreen()
}
