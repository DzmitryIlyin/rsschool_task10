//
//  UIButtonExtension.swift
//  rsschool_task10
//
//  Created by dzmitry ilyin on 9/1/21.
//

import UIKit

extension UIButton {
    
    static func makePlusOneButton() -> UIButton {
        let button = UIButton()
        button.setTitle("+1", for: .normal)
        button.titleLabel?.font = UIFont(name: "Nunito-ExtraBold", size: 40)
        button.titleLabel?.textColor = UIColor(red: 1, green: 0.992, blue: 0.992, alpha: 1)
        button.backgroundColor = UIColor(named: "task_green_color")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    static func makeAddScoreButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont(name: "Nunito-ExtraBold", size: 25)
        button.titleLabel?.textColor = UIColor(red: 1, green: 0.992, blue: 0.992, alpha: 1)
        button.backgroundColor = UIColor(named: "task_green_color")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    static func makeButtonWith(imageName: String) -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(named: imageName), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    static func makeAddScoreLabel() -> UIButton {
        let button = UIButton()
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.titleLabel!.font = UIFont(name: "Nunito-SemiBold", size: 20)
        button.backgroundColor = UIColor(named: "background_black")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFit
        button.clipsToBounds = true
        button.isUserInteractionEnabled = false
        button.isHidden = true
        return button
    }
    
    static func makeNavigationButton(title: String, fontSize: CGFloat) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor(named: "task_green_color"), for: .normal)
        button.setTitleColor(UIColor(named: "task_green_color"), for: .highlighted)
        button.titleLabel?.font = UIFont(name: "Nunito-ExtraBold", size: fontSize)
        return button
    }
    
    static func makeStartGameButton() -> UIButton {
        let button = UIButton()
        button.setTitle("Start game", for: .normal)
        button.titleLabel?.font = UIFont(name: "Nunito-ExtraBold", size: 24)
        button.titleLabel?.textColor = .white
        button.layer.cornerRadius = 35
        button.backgroundColor = UIColor(named: "task_green_color")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
}
