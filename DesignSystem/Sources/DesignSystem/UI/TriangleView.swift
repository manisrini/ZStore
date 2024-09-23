//
//  File.swift
//  
//
//  Created by Manikandan on 23/09/24.
//

import Foundation
import UIKit

public class TriangleView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
    }

    public override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.width, y: 0))  // Top right corner
        path.addLine(to: CGPoint(x: rect.width, y: rect.height)) // Bottom right corner
        path.addLine(to: CGPoint(x: 0, y: rect.height)) // Bottom left corner
        path.close() // Connect back to the start
        
        UIColor.systemPink.setFill()
        path.fill()
    }
    
    public func rotateTriangle(by angle: CGFloat) {
        self.transform = CGAffineTransform(rotationAngle: angle)
    }
}
