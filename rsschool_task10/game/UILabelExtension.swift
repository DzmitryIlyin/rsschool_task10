//
//  UILabelExtension.swift
//  rsschool_task10
//
//  Created by dzmitry ilyin on 8/31/21.
//

import UIKit

extension UILabel {
    
    static func makeThemeLabelWith(text: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont(name: "Nunito-ExtraBold", size: 36)
        label.text = text
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    static func makeNameLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont(name: "Nunito-ExtraBold", size: 28)
        label.textColor = UIColor(red: 0.922, green: 0.682, blue: 0.408, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    static func makeScoreLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont(name: "Nunito-Bold", size: 100)
        label.textColor = UIColor(red: 1, green: 0.992, blue: 0.992, alpha: 1)
        label.textAlignment = .center
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
//    static func makeAddScoreLabel() -> UILabel {
//        let label = UILabel()
//        label.font = UIFont(name: "Nunito-Bold", size: 30)
//        label.backgroundColor = UIColor(named: "background_black")
//        label.textColor = UIColor(red: 1, green: 0.992, blue: 0.992, alpha: 1)
////        label.textAlignment = .center
//        label.clipsToBounds = true
//        label.isHidden = true
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }
    
    static func makeNameLabelWith(text: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont(name: "Nunito-ExtraBold", size: 20)
        label.text = text
        label.textColor = UIColor(named: "name_label_gray")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
}
