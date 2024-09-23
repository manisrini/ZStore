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
        HStack{
            HStack(spacing : 2){
                
                Text(Utils.formatDecimal(viewModel.rating))
                    .foregroundStyle(Color(Utils.hexStringToUIColor(hex: DSMColorTokens.Arattai_Tangelo.rawValue)))
                    .font(.system(size: 13,weight: .semibold))
                
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
                Text("(\(self.viewModel.reviewCount))")
                    .foregroundStyle(
                        Color(
                            uiColor: Utils.hexStringToUIColor(hex: DSMColorTokens.Quaternary.rawValue)
                        )
                    )
                    .font(.system(size: 12,weight: .regular))

            }
            
            Spacer()
        }
    }
    
    public func setRating(rating : Double,reviewCount : Int){
        self.viewModel.rating = rating
        self.viewModel.reviewCount = reviewCount
    }
}

#Preview {
    RatingComponent(viewModel: RatingComponentViewModel(rating: 4.5, onImage: nil, offImage: nil,reviewCount: 5))
}
