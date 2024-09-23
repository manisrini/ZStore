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
    
    @State var fabItems : [FabItem]
    
    let didTapMenuItem : ((SortWith)->Void)?
    
    var body: some View {
        
        Menu{
            VStack {
                
                ScrollView(.vertical) {
                    ForEach(fabItems,id: \.id) { item in
                        RadioButtonView(item: item) { selectedItem in
                            updateItems(item: selectedItem)
                            if selectedItem.id == "1"{
                                didTapMenuItem?(.Rating)
                            }else if selectedItem.id == "2"{
                                didTapMenuItem?(.Price)
                            }
                        }
                        .padding(.vertical,15)
                    }
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
    
    func updateItems(item : FabItem){
        var tempItems = fabItems
        for (index,option) in fabItems.enumerated(){
            if option.id == item.id{
                tempItems[index].isSelected = true
            }else{
                tempItems[index].isSelected = false
            }
        }
        self.fabItems = tempItems
    }
}

#Preview {
    FabView(fabItems: [
        .init(id : "1",image: "star", text: "Rating", isSelected: true),
        .init(id : "2",image: "dollar", text: "Price", isSelected: false)
    ]) { _ in
        
    }
}
