//
//  File.swift
//  
//
//  Created by Manikandan on 23/09/24.
//

import UIKit
import SnapKit

public class ZChipView : UIView{
    
    let chipBtn : UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let containerView : UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.addView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addView(){
        
        var configuration = UIButton.Configuration.bordered()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 2, bottom: 0, trailing: 2)
        configuration.baseForegroundColor = .white
        configuration.titlePadding = 0  
        chipBtn.configuration = configuration
        self.addSubview(chipBtn)
        
        self.layer.cornerRadius = 15
        
        chipBtn.snp.makeConstraints { make in
            make.left.equalTo(self).offset(5)
            make.top.equalTo(self)
            make.height.equalTo(30)
        }
    }
    
    public func config(
        with text : String,
        height : CGFloat = 14,
        font : UIFont = .fontStyle(size: 13, weight: .medium),
        bgColor : UIColor = Utils.hexStringToUIColor(hex: DSMColorTokens.Capsicum.rawValue),
        textColor : UIColor = .white
    ){
        var configuration = UIButton.Configuration.bordered()
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: height), // Set the font size
            .foregroundColor: textColor
        ]
        let attributedTitle = NSAttributedString(string: text, attributes: attributes)
        configuration.baseBackgroundColor = bgColor
        configuration.attributedTitle = AttributedString(attributedTitle)
        self.chipBtn.configuration = configuration

    }

}
