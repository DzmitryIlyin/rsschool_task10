//
//  NewGameViewController.swift
//  rsschool_task10
//
//  Created by dzmitry ilyin on 8/25/21.
//

import UIKit

class NewGameViewController: UIViewController {
    
    var initialPlayerData = ["One", "Two"]
    
    private var tableView: UITableView?
    private var newPlayer: PlayerEntry?
    
    func setPlayer(player: PlayerEntry) {
        newPlayer = player
    }

    private lazy var cancelButton: UIButton = {
      UIButton.makeNavigationButton(title: "Cancel", fontSize: 17)
    }()
    
    private lazy var themeLabel: UILabel = {
        UILabel.makeThemeLabelWith(text: "Game Counter")
    }()
    
    private lazy var startGameButton: UIButton = {
        let button = UIButton.makeStartGameButton()
        button.addTarget(self, action: #selector(handleStartGameSegue), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBarButton()
        self.view.backgroundColor = UIColor(named: "background_black")
        addSubviews()
        setupTableView()
        setupConstraints()
    }
    
    private func setupBarButton() {
        if GameState.sharedInstance.gameCondition == .inProgress {
            let height: CGFloat = 75
            let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height))
            navigationBar.barTintColor = UIColor(named: "background_black")
            navigationBar.isTranslucent = false
            navigationBar.setValue(true, forKey: "hidesShadow")
            
            let navigationItem = UINavigationItem()
            let leftBarButton = AppUIBarButtonItem(title: "Cancel", target: self, selector: #selector(cancelNewGameController))
            navigationItem.leftBarButtonItem = leftBarButton
            
            navigationBar.items = [navigationItem]
            
            self.view.addSubview(navigationBar)
            
            self.view?.frame = CGRect(x: 0, y: height, width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height - height))
        }
    }
    
    @objc private func cancelNewGameController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func addSubviews() {
        self.view.addSubview(self.themeLabel)
        self.view.addSubview(self.startGameButton)
    }
    
    private func setupTableView() {
        self.tableView = UITableView(frame: .zero, style: .plain)
        self.tableView?.translatesAutoresizingMaskIntoConstraints = false
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.register(PlayerTableViewCell.self, forCellReuseIdentifier: "playerTableCell")
        self.tableView!.setEditing(true, animated: true)
        self.tableView?.allowsSelectionDuringEditing = true
        self.tableView!.backgroundColor = UIColor(named: "background_gray")
        
        self.tableView?.layer.cornerRadius = 15
        self.tableView?.separatorColor = .white
        self.tableView?.tableFooterView = UIView(frame: CGRect(x: 0, y: -1, width: self.tableView!.frame.size.width, height: 1))
        
        self.view.addSubview(self.tableView!)
        
    }
    
//    private func setupStartGameButton() {
//        self.button = UIButton()
//        startGameButton.setTitle("Start game", for: .normal)
//        startGameButton.titleLabel?.font = UIFont(name: "Nunito-ExtraBold", size: 24)
//        startGameButton.titleLabel?.textColor = .white
//
////        startGameButton.layer.masksToBounds = true
////        startGameButton.layer.shadowColor = UIColor.red.cgColor
////        startGameButton.layer.shadowOpacity = 1
////        startGameButton.layer.shadowOffset = CGSize(width: 0, height: 5)
////        startGameButton.layer.shadowRadius = 20
//
//        startGameButton.layer.cornerRadius = 35
//        startGameButton.backgroundColor = UIColor(named: "task_green_color")
//        startGameButton.translatesAutoresizingMaskIntoConstraints = false
//
//        startGameButton.addTarget(self, action: #selector(handleStartGameSegue), for: .touchUpInside)
//
//        self.view.addSubview(startGameButton)
//    }
    
    private func setupConstraints() {
        let constraint = self.tableView!.bottomAnchor.constraint(greaterThanOrEqualTo: startGameButton.topAnchor, constant: -100)
            constraint.priority = UILayoutPriority(999)
        
        let topConstraint = GameState.sharedInstance.gameCondition == .inProgress ? 75 : 10
        
        NSLayoutConstraint.activate([
            
            self.themeLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.themeLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: CGFloat(topConstraint)),
            self.themeLabel.widthAnchor.constraint(equalTo: self.tableView!.widthAnchor),
            
            self.tableView!.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,constant: 20),
            self.tableView!.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            self.tableView!.topAnchor.constraint(equalTo: self.themeLabel.bottomAnchor, constant: 25),
            constraint,
            
            startGameButton.heightAnchor.constraint(equalToConstant: self.view.frame.size.height / 13.8),
            startGameButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            startGameButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            startGameButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -65),
        ])
    }
}

extension NewGameViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        initialPlayerData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerTableCell", for: indexPath) as! PlayerTableViewCell
        cell.playerName = initialPlayerData[indexPath.row]
        return cell
    }
    
//    MARK: handle delete/insert cell actions
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
       true
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        "Remove"
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if (indexPath.row == initialPlayerData.count - 1) {
            return .insert
        }
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .insert {
            self.handleAddPlayerSegue()
        } else if editingStyle == .delete {
            print("DELETE")
            self.initialPlayerData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        let cell = tableView.cellForRow(at: indexPath)
        cell?.setNeedsLayout()
    }
    
//    MARK: handle row moving
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToSwap = self.initialPlayerData[sourceIndexPath.row]
        self.initialPlayerData.remove(at: sourceIndexPath.row)
        self.initialPlayerData.insert(itemToSwap, at: destinationIndexPath.row)
    }
    
//    MARK:make last row constant
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row == initialPlayerData.count - 1 ? false : true
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        
        if proposedDestinationIndexPath.row == initialPlayerData.count - 1 {
            return IndexPath(row: 0, section: sourceIndexPath.section)
        }
        return proposedDestinationIndexPath
    }
    
//    MARK: handle rows selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let currentCell = tableView.cellForRow(at: indexPath) {
            if currentCell.isSelected {
                self.tableView?.deselectRow(at: indexPath, animated: true)
            }
        }

        if indexPath.row == initialPlayerData.count - 1 {
            self.handleAddPlayerSegue()
        }
    }
    
//    MARK: setup header
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let labelView: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        labelView.textLabel?.font = UIFont(name: "Nunito-SemiBold", size: 16)
        labelView.textLabel?.textColor = UIColor(red: 0.922, green: 0.922, blue: 0.961, alpha: 0.6)
        labelView.contentView.backgroundColor = UIColor(named: "background_gray")
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let labelView = UITableViewHeaderFooterView()
        labelView.textLabel?.text = "Players"
        return labelView
    }
    
}

extension NewGameViewController: AddPlayerDelegate {
    
//    MARK: handle Add Player controller appearance
    func handleAddPlayerSegue() {
        let addPlayerVC = AddPlayerViewController()
        addPlayerVC.delegate = self
        self.navigationController?.pushViewController(addPlayerVC, animated: false)
    }
    
    @objc func handleStartGameSegue() {
        let gameVC = GameViewController()
        gameVC.playersData = initialPlayerData.map{PlayerCard(name: $0, score: "0")}
        GameState.sharedInstance.gameCondition = .new
        GameState.sharedInstance.savedCardIndex = 0
        if let navController = self.presentingViewController as? UINavigationController {
            let presentingVC = navController.viewControllers.first!
            if presentingVC is GameViewController {
                self.dismiss(animated: false) {
                    navController.setViewControllers([gameVC], animated: true)
                }
            }
        } else {
            self.navigationController?.pushViewController(gameVC, animated: false)
        }
    }
    
//    MARK: handle table update with new player
    func addPlayer(player: PlayerEntry) {
        self.initialPlayerData.insert(player.name, at: self.initialPlayerData.count - 1)
        self.tableView!.reloadData()
    }
}

