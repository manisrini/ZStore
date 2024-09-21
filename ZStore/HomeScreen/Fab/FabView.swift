//
//  FabView.swift
//  ZStore
//
//  Created by Manikandan on 21/09/24.
//

import SwiftUI
import DesignSystem


struct FabItem{
    var id : String
    var image : String
    var text : String
    var isSelected : Bool
}

struct FabView: View {
    
    var fabItems : [FabItem] = [
        .init(id : "1",image: "star", text: "Rating", isSelected: true),
        .init(id : "2",image: "dollar", text: "Price", isSelected: false)
    ]
    
    var body: some View {
        
        Menu{
            ScrollView(.vertical) {
                ForEach(fabItems,id: \.id) { item in
                    RadioButtonView(item: item) { selectedItem in
                        print(selectedItem)
                    }
                    .padding(.vertical,15)
                }
            }

        } label: {
            RoundedRectangle(cornerRadius: 25)
                .foregroundStyle(Color(uiColor: Utils.hexStringToUIColor(hex: DSMColorTokens.Arattai_Tangelo.rawValue)))
                .frame(width: 50,height: 50)
                .overlay {
                    Image("sort").resizable()
                        .frame(width: 25,height: 25)
                }
        }
    }
}

#Preview {
    FabView()
}
