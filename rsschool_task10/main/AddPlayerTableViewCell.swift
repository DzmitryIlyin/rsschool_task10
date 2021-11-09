//
//  AddPlayerTableViewCell.swift
//  rsschool_task10
//
//  Created by dzmitry ilyin on 8/25/21.
//

import UIKit

class AddPlayerTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupAddPlayerCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupAddPlayerCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    private func setupAddPlayerCell() {
        self.textLabel?.text = "Add player"
//        let insertButton = UIButton(type: UIButton.ButtonType.custom)
        let insertButton = UIButton(type: UIButton.ButtonType.contactAdd)
//        insertButton.setBackgroundImage(UIImage(named: "plus.circle.fill"), for: .normal)
        insertButton.frame = CGRect(x: 10, y: 10, width: 50, height: 50)
//        self.addSubview(insertButton)
        self.accessoryView = insertButton
    }

}
