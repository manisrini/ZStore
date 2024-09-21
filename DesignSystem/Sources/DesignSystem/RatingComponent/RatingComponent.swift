//
//  SwiftUIView.swift
//  
//
//  Created by Manikandan on 21/09/24.
//

import SwiftUI

public struct RatingComponent: View {
    
    @ObservedObject var viewModel : RatingComponentViewModel
    
    public init(viewModel: RatingComponentViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        HStack(spacing : 2){
            
            Text(Utils.shared.formatDecimal(viewModel.rating))
                .foregroundStyle(Color(Utils.shared.hexStringToUIColor(hex: DSMColorTokens.Arattai_Tangelo.rawValue)))
                .font(.system(size: 13,weight: .semibold))
                .frame(width: 25)
            
            ForEach(1 ... viewModel.maxRating,id: \.self) { item in
                if item <= Int(viewModel.rating){
                    if let _onImage = viewModel.onImage{
                        Image(uiImage: _onImage)
                            .resizable()
                            .frame(width: 18, height: 18)
                    }
                }else{
                    if let _offImage = viewModel.offImage{
                        Image(uiImage: _offImage)
                            .resizable()
                            .frame(width: 18, height: 18)
                    }
                }
            }
        }
        
    }
    
    public func setRating(rating : Double){
        self.viewModel.rating = rating
    }
}

#Preview {
    RatingComponent(viewModel: RatingComponentViewModel(rating: 4.5, onImage: nil, offImage: nil))
}
