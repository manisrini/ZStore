//
//  AvailableColorView.swift
//  ZStore
//
//  Created by Manikandan on 21/09/24.
//

import SwiftUI
import UIKit


struct AvailableColorsView: View {
    
    @ObservedObject var viewModel : AvailableColorsViewModel
    
    var body: some View {
        HStack{
            ForEach(self.viewModel.colors,id: \.self) { color in
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(Color(uiColor: self.viewModel.getColor(color)))
                    .frame(width: 28,height: 28)
                    .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.gray, lineWidth: 1)
                        )
            }
            Spacer()
        }
        .frame(height: 30)
        
    }
    
    func setColors(colors : [String]){
        self.viewModel.colors = colors
    }
}

#Preview {
    AvailableColorsView(viewModel: AvailableColorsViewModel(colors: ["red","green"]))
}
