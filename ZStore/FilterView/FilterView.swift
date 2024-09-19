//
//  FilterView.swift
//  ZStore
//
//  Created by Manikandan on 19/09/24.
//

import UIKit

class FilterView: UIView {

    static let nibname = "FilterView"
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: FilterView.nibname, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }

}
