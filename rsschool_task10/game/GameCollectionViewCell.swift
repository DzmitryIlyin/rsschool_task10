//
//  GameCollectionViewCell.swift
//  rsschool_task10
//
//  Created by dzmitry ilyin on 8/30/21.
//

import UIKit

class GameCollectionViewCell: UICollectionViewCell {
    
    var playerName: String? {
        didSet {
            self.nameLabel.text = playerName
        }
    }
    var playerScore: String? {
        didSet {
            self.scoreLabel.text = playerScore
        }
    }

    var playerAddedScore: String? {
        didSet {
            self.addedScoreLabel.setTitle(playerAddedScore, for: .normal)
            
            if Int(playerAddedScore!)! != 0 {
                self.addedScoreLabel.isHidden = false
            } else {
                self.addedScoreLabel.isHidden = true
            }
        }
    }

    private lazy var nameLabel: UILabel = {
        UILabel.makeNameLabel()
    }()
    
    private lazy var scoreLabel: UILabel = {
        UILabel.makeScoreLabel()
    }()
    
    private lazy var addedScoreLabel: UIButton = {
        UIButton.makeAddScoreLabel()
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()

        if Int(playerAddedScore!)! != 0 {
//            TODO: maybe move to UIButton ancestor
            self.addedScoreLabel.layer.cornerRadius = self.addedScoreLabel.bounds.height / 2
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = UIColor(named: "background_gray")
        self.contentView.layer.cornerRadius = 15
        
        setupCell()
        setupConstaints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(scoreLabel)
        self.contentView.addSubview(addedScoreLabel)
    }
    
    private func setupConstaints() {
        
        NSLayoutConstraint.activate([
            self.nameLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.nameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: self.contentView.bounds.height*0.08),
            
            self.scoreLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.scoreLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            
            self.addedScoreLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.addedScoreLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.scoreLabel.trailingAnchor, constant: 20),
            self.addedScoreLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -2),
            self.addedScoreLabel.widthAnchor.constraint(equalTo: self.addedScoreLabel.heightAnchor, constant: 1)
        ])
    }

}
