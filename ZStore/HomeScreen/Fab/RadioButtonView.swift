//
//  RadioButtonView.swift
//  ZStore
//
//  Created by Manikandan on 21/09/24.
//

import SwiftUI
import DesignSystem

public struct RadioButtonView: View {
    var item : FabItem
    var onChange: ((FabItem) -> Void)?
    
    init(item: FabItem, onChange: ((FabItem) -> Void)? = nil) {
        self.item = item
        self.onChange = onChange
    }
    
    public var body: some View {
        Button{
            self.onChange?(item)
        } label: {
            HStack{
                RoundedRectangle(cornerRadius : 15)
                    .foregroundStyle(Color.white)
                    .overlay {
                        Image(item.image).resizable()
                            .renderingMode(.template)
                            .tint(Color(uiColor: Utils.hexStringToUIColor(hex: DSMColorTokens.Arattai_Tangelo.rawValue)))
                            .frame(width: 20,height: 20)
                    }
                    .frame(width: 36,height: 36)
                
                Text(item.text)
                    .padding(.leading,5)
                
                Spacer()
                
                Image(item.isSelected ? "select" : "unselect").resizable()
                    .frame(width: 28,height: 28)
                    .padding(.trailing,15)
            }
            .padding(.horizontal,16)

        }
    }
}

#Preview {
    RadioButtonView(item: .init(id: "1", image: "sort", text: "Test", isSelected: true))
}
