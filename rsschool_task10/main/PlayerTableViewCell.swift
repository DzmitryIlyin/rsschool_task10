//
//  PlayerTableViewCell.swift
//  rsschool_task10
//
//  Created by dzmitry ilyin on 8/25/21.
//

import UIKit

class PlayerTableViewCell: UITableViewCell {
    
    var playerName: String? {
        didSet {
            self.textLabel?.text = playerName
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupPlayerCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupPlayerCell() {
        self.backgroundColor = UIColor(named: "background_gray")
        self.selectionStyle = .none
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setCustomControlImages()
        setTextStyle()
    }
    
    private func setCustomControlImages() {
        if self.editingStyle == .delete {
            self.subviews
                .filter { $0.isMember(of: NSClassFromString("UITableViewCellEditControl")!) }
                .compactMap { $0.value(forKey: "imageView") as? UIImageView }
                .forEach { $0.image = UIImage(named: "icon_Delete") }
        } else {
            self.subviews
                .filter { $0.isMember(of: NSClassFromString("UITableViewCellEditControl")!) }
                .compactMap { $0.value(forKey: "imageView") as? UIImageView }
                .forEach { $0.image = UIImage(named: "icon_Add") }
        }
        
        self.subviews
            .filter { $0.isMember(of: NSClassFromString("UITableViewCellReorderControl")!) }
            .compactMap { $0.value(forKey: "imageView") as? UIImageView }
            .forEach { $0.image = UIImage(named: "icon_Sort") }

    }
    
    private func setTextStyle() {
        if self.editingStyle == .delete {
            self.textLabel?.font = UIFont(name: "Nunito-ExtraBold", size: 20)
            self.textLabel?.textColor = .white
        } else if self.editingStyle == .insert {
            self.textLabel?.font = UIFont(name: "Nunito-ExtraBold", size: 16)
            self.textLabel?.textColor = UIColor(named: "task_green_color")
        }
    }

}
