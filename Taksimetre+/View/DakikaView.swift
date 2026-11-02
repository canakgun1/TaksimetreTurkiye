//
//  DakikaView.swift
//  GitmeZamani
//
//  Created by CAN AKGUN on 26.05.2021.
//

import UIKit
import MapKit

class DakikaView: UIView {

    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var centerConstraint: NSLayoutConstraint!
    override init(frame: CGRect) {
        super.init(frame: frame)
//        image.image = nil
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    func commonInit() {
        
        let view = Bundle.main.loadNibNamed("DakikaView", owner: self, options: nil)![0] as! UIView
        view.frame = self.bounds
        addSubview(view)
        
        
    }
    
    
    

}

class DakikaAnnotation: MKPointAnnotation {
    
    var routeID: Int!
    
}
