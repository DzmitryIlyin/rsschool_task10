//
//  UIBarButtonItemExtension.swift
//  rsschool_task10
//
//  Created by dzmitry ilyin on 9/7/21.
//

import UIKit

class AppUIBarButtonItem: UIBarButtonItem {
    
    convenience init(title: String, target: Any, selector: Selector) {
        let barButton = UIButton.makeNavigationButton(title: title, fontSize: 17)
        barButton.addTarget(target, action: selector, for: .touchUpInside)
        
        self.init(customView: barButton)
    }
    
    private override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

