//
//  FilterView.swift
//  ZStore
//
//  Created by Manikandan on 19/09/24.
//

import UIKit
import ZChip

class FilterView: UIView {

    static let nibname = "FilterView"
    var chipComponent = ZChipComponent()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addView(){
        
        chipComponent = ZChipComponent()
        chipComponent.config(viewModel:  ZChipComponentViewModel(tags: []))
        self.addSubview(chipComponent)
                
        chipComponent.snp.makeConstraints { make in
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.top.equalTo(self)
            make.bottom.equalTo(self)
        }
    }
    
    func updateView(_ items : [Tag]){
        chipComponent.updateTags(tags: items)
    }
    
}
