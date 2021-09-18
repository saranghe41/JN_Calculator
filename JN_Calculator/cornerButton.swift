//
//  cornerButton.swift
//  JN_Calculator
//
//  Created by 김지은 on 2021/09/16.
//

import Foundation
import UIKit

class cornerButton: UIButton {
    override func draw(_ rect: CGRect) {
        //
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.size.height / 2
    }
}
