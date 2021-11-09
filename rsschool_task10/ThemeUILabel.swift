//
//  ThemeUILabel.swift
//  rsschool_task10
//
//  Created by dzmitry ilyin on 8/30/21.
//

import UIKit

class ThemeUILabel: UILabel {

    convenience init(text: String) {
        self.init(frame: .zero)
        self.font = UIFont(name: "Nunito-ExtraBold", size: 36)
        self.text = text
        self.textColor = .white
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
}
