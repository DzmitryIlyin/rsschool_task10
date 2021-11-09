//
//  AddPlayerViewController.swift
//  rsschool_task10
//
//  Created by dzmitry ilyin on 8/28/21.
//

import UIKit

protocol AddPlayerDelegate {
    func addPlayer(player: PlayerEntry)
}

class AddPlayerViewController: UIViewController {
    
    var delegate: AddPlayerDelegate?
    private var themeLabel: UILabel?
    private var textField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "background_black")
        setupBarButton()
        setupLabel()
        setupTextField()
        setupConstraints()
    }

    private func setupLabel() {
        self.themeLabel = ThemeUILabel(text: "Add Player")
        self.view.addSubview(self.themeLabel!)
    }
    
    private func setupTextField() {
        self.textField = UITextField()
        self.textField!.translatesAutoresizingMaskIntoConstraints = false
        self.textField!.textColor = .white
        self.textField!.font = UIFont(name: "Nunito-ExtraBold", size: 20)
        self.textField!.attributedPlaceholder = NSAttributedString(string: "Player Name", attributes:
                                                                    [NSAttributedString.Key.foregroundColor: UIColor(named: "placeholder_gray")!,
                                                                     NSAttributedString.Key.font : UIFont(name: "Nunito-ExtraBold", size: 20)!])
        self.textField!.backgroundColor = UIColor(named: "background_gray")
        self.textField!.setLeftPaddingPoints(24)
        
        self.view.addSubview(self.textField!)
        self.textField!.becomeFirstResponder()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            self.themeLabel!.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            self.themeLabel!.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 20),
            self.themeLabel!.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 12),
            self.themeLabel!.bottomAnchor.constraint(equalTo: self.textField!.topAnchor, constant: -25),
            
            self.textField!.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.textField!.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.textField!.heightAnchor.constraint(equalToConstant: self.view.frame.size.height / 15)
        ])
    }
    
    private func setupBarButton() {
        let addButtonItem = AppUIBarButtonItem(title: "Add", target: self, selector: #selector(handleAdd(sender:)))
        self.navigationItem.rightBarButtonItem = addButtonItem
    }
    
    @objc func handleAdd(sender: UIBarButtonItem) {
        guard let playerName = self.textField!.text, self.textField!.hasText else {
            return
        }
        
        let player = PlayerEntry(name: playerName)
        
        delegate?.addPlayer(player: player)
        self.navigationController?.popToRootViewController(animated: true)
    }

}

//TODO: move to appropriate place
extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
