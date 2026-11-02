//
//  RoundedViews.swift
//  GitmeZamani
//
//  Created by CAN AKGUN on 7.05.2021.
//

import UIKit

class RoundedButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10
    }
    
}

class RoundedMenuButton: RoundedButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let gradient = CAGradientLayer()
        gradient.frame = layer.bounds
        gradient.colors = [#colorLiteral(red: 0.1529411765, green: 0.2470588235, blue: 0.4392156863, alpha: 1).cgColor, #colorLiteral(red: 0.2078431373, green: 0.3098039216, blue: 0.5254901961, alpha: 1).cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        layer.insertSublayer(gradient, at: 0)
        clipsToBounds = true
//        layer.shadowColor = UIColor.white.cgColor
//        layer.shadowRadius = 10.0
//        layer.borderColor = UIColor.white.cgColor
//        layer.borderWidth = 1
    }
    
}

class RoundedView: UIView {
    
    override func awakeFromNib() {
        layer.cornerRadius = 10
    }
    
}

class RoundedView12: UIView {
    
    override func awakeFromNib() {
        layer.cornerRadius = 12
    }
    
}

class RoundedView8: UIView {
    
    override func awakeFromNib() {
        layer.cornerRadius = 8
    }
    
}

class RoundedShadowView2: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 15
        layer.shadowColor = #colorLiteral(red: 0.2174814343, green: 0.2681963146, blue: 0.3689454794, alpha: 1).cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 3
    }
}
