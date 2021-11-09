//
//  GameViewController.swift
//  rsschool_task10
//
//  Created by dzmitry ilyin on 8/30/21.
//

import UIKit

//protocol PushDataDelegate {
//    func pushData(data:[PlayerCard])
//}

class GameViewController: UIViewController {
    
    var playersData: [PlayerCard]?
    var timer: Timer?
    var isNewGame = false
    
    private lazy var themeLabel: UILabel = {
       UILabel.makeThemeLabelWith(text: "Game")
    }()
    
    private lazy var diceView: UIImageView = {
        let diceView = UIImageView()
        diceView.image = UIImage(named: "dice_1")
        diceView.translatesAutoresizingMaskIntoConstraints = false
        return diceView
    }()
    
    private var timerLabel: UILabel?
    private lazy var actionButton: UIButton = {
        UIButton.makeButtonWith(imageName: "play")
    }()
    
//    MARK: configure cards collection view
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.backgroundColor = UIColor(named: "background_black")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = .fast
        collectionView.register(GameCollectionViewCell.self, forCellWithReuseIdentifier: "gameCell")
        return collectionView
    }()
    private lazy var needsScrolling = false
    private var startingScrollingOffset = CGPoint.zero
    private var currentCardIndex:Int {
        get {
            var lineSpacing: CGFloat = 0
            if let collectionLineSpacing = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                lineSpacing = collectionLineSpacing.minimumLineSpacing
            }
            let cellWidth = self.collectionView(self.collectionView, layout: self.collectionView.collectionViewLayout, sizeForItemAt: IndexPath(item: 0, section: 0)).width
            let proposedPage = self.collectionView.contentOffset.x / (cellWidth + lineSpacing)
            return Int(round(proposedPage))
        }
    }
    
//    MARK: configure plus one button score with navigation stackView
    private lazy var scoreNavigationStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.backgroundColor = UIColor(named: "background_black")
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private lazy var plusOneButton: UIButton = {
        let button = UIButton.makePlusOneButton()
        let topBottomInset = self.view.bounds.height * 0.03
        button.contentEdgeInsets = UIEdgeInsets(top: topBottomInset,left: 0,bottom: topBottomInset,right: 0)
        button.layer.cornerRadius = button.intrinsicContentSize.height / 2
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleAddScore(sender:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(handlePreviousButtonNavigation(sender:)), for: .touchUpInside)
        return button
    }()
    private lazy var forwardButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(handleNextButtonNavigation(sender:)), for: .touchUpInside)
        return button
    }()
    
//    MARK: configure scrore buttons stackView
    private lazy var addScoreStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.backgroundColor = UIColor(named: "background_black")
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    let scoresLabels = ["-10", "-5", "+1", "+5", "+10"]
    
//    MARK: configure bottom view: undo and names
    private lazy var undoButton: UIButton = {
        let button = UIButton.makeButtonWith(imageName: "icon_undo")
        button.addTarget(self, action: #selector(handleUndoScore(sender:)), for: .touchUpInside)
        return button
    }()
    private var addScoreHistory = [[Int:String]]()
    private lazy var namesStackView: UIStackView = {
       let stack = UIStackView()
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 5
        stack.backgroundColor = UIColor(named: "background_black")
        self.playersData?.forEach{stack.addArrangedSubview(UILabel.makeNameLabelWith(text: $0.name[0].uppercased()))}
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "background_black")
                
        NotificationCenter.default.addObserver(self, selector: #selector(saveState), name: UIApplication.willTerminateNotification, object: UIApplication.shared)
        
        if GameState.sharedInstance.gameCondition == .inProgress {
            self.loadState()
        } else {
            GameState.sharedInstance.gameCondition = .inProgress
        }
        
        
        setupBarButtons()
        
        setupTimerLabel()
        setupScoreNavigationStackView()
        setupAddScoreButtonsStackView()
        self.addSubviews()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        setupConstraints()
    }
    
    private func setupBarButtons() {
        let leftBarButtonItem = AppUIBarButtonItem(title: "New Game", target: self, selector: #selector(handleNewGameTransition))
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        let rightBarButtonItem = AppUIBarButtonItem(title: "Results", target: self, selector: #selector(handleResultsTransition))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc private func handleNewGameTransition() {
        print("handleNewGameTransition")
        let newGameVC = NewGameViewController()
        newGameVC.modalPresentationStyle = .popover
        newGameVC.modalTransitionStyle = .crossDissolve
        newGameVC.initialPlayerData = self.playersData!.map{$0.name}
        let navVC = UINavigationController(rootViewController: newGameVC)
        present(navVC, animated: true, completion: nil)
    }
    
    @objc private func handleResultsTransition() {
        print("handleResults")
    }
    
    private func loadState() {
        if (self.playersData?.isEmpty) == nil {
            self.playersData = GameState.sharedInstance.playerCards
        }
    }
    
    @objc private func saveState() {
        GameState.sharedInstance.savedCardIndex = self.currentCardIndex
        GameState.sharedInstance.playerCards = self.playersData
        GameState.sharedInstance.gameCondition = .inProgress
        if let data = try? PropertyListEncoder().encode(GameState.sharedInstance) {
                UserDefaults.standard.setValue(data, forKey: "gameState")
        }
    }
    
//    MARK: setup top items
    private func setupTimerLabel() {
        self.timerLabel = ThemeUILabel(text: "00:00")
    }
    
//    MARK: setup add score views
    private func setupScoreNavigationStackView(){
        self.scoreNavigationStackView.addArrangedSubview(backButton)
        self.scoreNavigationStackView.addArrangedSubview(self.plusOneButton)
        self.scoreNavigationStackView.addArrangedSubview(forwardButton)
        
    }
    
    private func setupAddScoreButtonsStackView() {
        self.scoresLabels.forEach{self.addScoreStackView.addArrangedSubview(self.makeAddScoreButton(title: $0))}
    }
    
    private func makeAddScoreButton(title: String) -> UIButton {
        let button = UIButton.makeAddScoreButton(title: title)
        let topBottomInset = self.view.bounds.height * 0.012
        button.contentEdgeInsets = UIEdgeInsets(top: topBottomInset,left: 0,bottom: topBottomInset,right: 0)
        button.layer.cornerRadius = button.intrinsicContentSize.height / 2
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleAddScore(sender:)), for: .touchUpInside)
        return button
    }
    
    private func addSubviews() {
        self.view.addSubview(self.themeLabel)
        self.view.addSubview(self.diceView)
        self.view.addSubview(self.timerLabel!)
        self.view.addSubview(self.actionButton)
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.scoreNavigationStackView)
        self.view.addSubview(self.addScoreStackView)
        self.view.addSubview(self.undoButton)
        self.view.addSubview(self.namesStackView)
    }
    
//    MARK: setup constaints
    private func setupConstraints() {
        self.themeLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        self.themeLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        self.timerLabel!.setContentHuggingPriority(.defaultHigh, for: .vertical)
        self.timerLabel!.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        self.addScoreStackView.arrangedSubviews.forEach{ $0.heightAnchor.constraint(equalTo: $0.widthAnchor).isActive = true }
        
        NSLayoutConstraint.activate([
            self.themeLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            self.themeLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.diceView.leadingAnchor, constant: -100),
            self.themeLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 12),
            self.themeLabel.bottomAnchor.constraint(equalTo: self.timerLabel!.topAnchor, constant: -20),
            
            self.diceView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            self.diceView.heightAnchor.constraint(equalTo: self.themeLabel.heightAnchor, multiplier: 0.6),
            self.diceView.widthAnchor.constraint(equalTo: self.themeLabel.widthAnchor, multiplier: 0.3),
            self.diceView.centerYAnchor.constraint(equalTo: self.themeLabel.centerYAnchor),
            
            self.timerLabel!.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            
            self.actionButton.leadingAnchor.constraint(equalTo: self.timerLabel!.trailingAnchor),
            self.actionButton.centerYAnchor.constraint(equalTo: self.timerLabel!.centerYAnchor),
            self.actionButton.heightAnchor.constraint(equalTo: self.timerLabel!.heightAnchor, multiplier: 0.6),
            self.actionButton.widthAnchor.constraint(equalTo: self.timerLabel!.widthAnchor, multiplier: 0.3),
            
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.collectionView.topAnchor.constraint(equalTo: self.timerLabel!.bottomAnchor, constant: 30),
            self.collectionView.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.45),
            
            self.plusOneButton.heightAnchor.constraint(equalTo: self.plusOneButton.widthAnchor, multiplier: 1),
            
            self.scoreNavigationStackView.leadingAnchor.constraint(lessThanOrEqualTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            self.scoreNavigationStackView.trailingAnchor.constraint(lessThanOrEqualTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            self.scoreNavigationStackView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            self.scoreNavigationStackView.topAnchor.constraint(equalTo: self.collectionView.bottomAnchor, constant: 28),
            
            self.addScoreStackView.leadingAnchor.constraint(lessThanOrEqualTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            self.addScoreStackView.trailingAnchor.constraint(lessThanOrEqualTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            self.addScoreStackView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            self.addScoreStackView.topAnchor.constraint(equalTo: self.scoreNavigationStackView.bottomAnchor, constant: 20),
            
            self.undoButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            self.undoButton.topAnchor.constraint(equalTo: self.addScoreStackView.bottomAnchor, constant: 20),

            self.namesStackView.centerYAnchor.constraint(equalTo: self.undoButton.centerYAnchor),
            self.namesStackView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            self.namesStackView.leadingAnchor.constraint(greaterThanOrEqualTo: self.undoButton.trailingAnchor, constant: 20),
            self.namesStackView.trailingAnchor.constraint(lessThanOrEqualTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.willTerminateNotification, object: UIApplication.shared)
        if ((self.timer?.isValid) != nil) {
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
}

extension GameViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.playersData!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gameCell", for: indexPath) as! GameCollectionViewCell
        cell.playerName = self.playersData![indexPath.item].name
        cell.playerScore = self.playersData![indexPath.item].score
        cell.playerAddedScore = self.playersData![indexPath.item].addedScore
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = collectionView.bounds.width * 0.67
        let itemHeight = collectionView.bounds.height
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: (collectionView.bounds.width * 0.15), bottom: 0, right: (collectionView.bounds.width * 0.15))
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.needsScrolling = true
        self.highlighCurrenPlayerName()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if self.needsScrolling {
            self.needsScrolling = false
            let savedCardIndex = GameState.sharedInstance.savedCardIndex
            if savedCardIndex > 0 {
                let indexPath = IndexPath(item: savedCardIndex, section: 0)
                self.collectionView.scrollToItem(at: indexPath, at: [.centeredHorizontally], animated: true)
                GameState.sharedInstance.savedCardIndex = 0
            }
            updateNavigationButtonsImage(cardIndex: savedCardIndex)
        }
    }
    
//    MARK: handle player name highlighting
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.highlighCurrenPlayerName()
        self.updateNavigationButtonsImage(cardIndex: currentCardIndex)
    }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.highlighCurrenPlayerName()
        self.updateNavigationButtonsImage(cardIndex: currentCardIndex)
    }
    
    private func highlighCurrenPlayerName() {
        self.namesStackView.arrangedSubviews.forEach{($0 as! UILabel).textColor = UIColor(named: "name_label_gray")}
        let nameLabel = self.namesStackView.arrangedSubviews[self.currentCardIndex] as! UILabel
        nameLabel.textColor = UIColor(named: "name_label_white")
    }

//    MARK: handle scroll to next item by tap on it
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        updateNavigationButtonsImage(cardIndex: indexPath.item)
    }
    
//    MARK: handle CollectionView "paging"
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
       startingScrollingOffset = scrollView.contentOffset
    }

//    https://rolandleth.medium.com/uicollectionview-snap-scrolling-and-pagination-45559e6c6e6b
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        var lineSpacing: CGFloat = 0
        if let collectionLineSpacing = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            lineSpacing = collectionLineSpacing.minimumLineSpacing
        }
        let cellWidth = self.collectionView(self.collectionView, layout: self.collectionView.collectionViewLayout, sizeForItemAt: IndexPath(item: 0, section: 0)).width + lineSpacing
        var page: CGFloat?
        let offset = scrollView.contentOffset.x + self.collectionView.contentInset.left
        let proposedPage = offset / cellWidth
        let snapPoint: CGFloat = 0.01
        let snapDelta: CGFloat = offset > startingScrollingOffset.x ? (1 - snapPoint) : snapPoint
        
        if floor(proposedPage + snapDelta) == floor(proposedPage) {
            page = floor(proposedPage)
        } else if (proposedPage + snapDelta) > CGFloat(self.collectionView.numberOfItems(inSection: 0)) {
            page = 0
        } else {
            page = floor(proposedPage + 1)
        }
        
        targetContentOffset.pointee = CGPoint(
            x: cellWidth * page!,
            y: targetContentOffset.pointee.y
        )
    }

}

extension GameViewController {
    
//    MARK: hadle add/substract score actions
    @objc private func handleAddScore(sender: UIButton) {
        let cardIndex = self.currentCardIndex
        let indexPath = IndexPath(item: cardIndex, section: 0)
        let cell = self.collectionView.cellForItem(at: indexPath) as! GameCollectionViewCell
    
        let buttonValue = sender.titleLabel?.text
        let updatedAddedScore = Int(cell.playerAddedScore!)! + Int(buttonValue!)!
        var updatedAddedScoreString: String
        if updatedAddedScore > 0 {
            updatedAddedScoreString = String("+\(updatedAddedScore)")
        } else {
            updatedAddedScoreString = String("\(updatedAddedScore)")
        }
        
        self.playersData![indexPath.item].addedScore = updatedAddedScoreString
        cell.playerAddedScore = updatedAddedScoreString
        
        self.collectionView.reloadItems(at: [indexPath])

        if ((self.timer?.isValid) != nil) {
            self.timer?.invalidate()
            self.timer = nil
        }
        
        self.timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(updatePlayerScore), userInfo: nil, repeats: false)

    }
    
    @objc private func updatePlayerScore() {
        self.timer?.invalidate()
        
        let cardIndex = self.currentCardIndex
        let indexPath = IndexPath(item: cardIndex, section: 0)
        let cell = self.collectionView.cellForItem(at: indexPath) as! GameCollectionViewCell
        
        let currentCellValueString = cell.playerScore!
        updateAddScoreHistory(cellIndex: cardIndex, score: currentCellValueString)
        var currentCellValue = Int(currentCellValueString)!
        
//        switch cell.playerAddedScore!.plusMinusSign {
//        case "+":
//            currentCellValue += Int(cell.playerAddedScore!)!
//        case "-":
//            currentCellValue -= Int(cell.playerAddedScore!)!
//        default:
//            fatalError("Unrecognized math symbol")
//        }
        
        currentCellValue += Int(cell.playerAddedScore!)!
        
        cell.playerAddedScore = "0"
        cell.playerScore = String(currentCellValue)
        
        self.playersData![indexPath.item].score = String(currentCellValue)
        self.playersData![indexPath.item].addedScore = "0"
        self.collectionView.reloadItems(at: [indexPath])
        
        let nextCardIndex = cardIndex == self.playersData!.count - 1 ? 0 : cardIndex + 1
        self.collectionView.scrollToItem(at: IndexPath(item: nextCardIndex, section: 0), at: .centeredHorizontally, animated: true)
    }
    
//    Handle score history and undo
    private func updateAddScoreHistory(cellIndex: Int, score: String) {
        self.addScoreHistory.append([cellIndex: score])
    }
    
    @objc private func handleUndoScore(sender: UIButton) {
        if !self.addScoreHistory.isEmpty {
            let lastUpdatedScore = self.addScoreHistory.popLast()
            let lastUpdatedCardIndex = lastUpdatedScore!.first!.key
            let playerScoreBeforeUpdate = lastUpdatedScore![lastUpdatedCardIndex]
            let indexPath = IndexPath(item: lastUpdatedCardIndex, section: 0)
            let prevoiusUpdatedCell = self.collectionView.cellForItem(at: indexPath) as! GameCollectionViewCell
            
            self.playersData![indexPath.item].score = playerScoreBeforeUpdate!
            prevoiusUpdatedCell.playerScore = playerScoreBeforeUpdate
            self.collectionView.reloadItems(at: [indexPath])

            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
//    MARK: handle navigation buttons
    @objc private func handlePreviousButtonNavigation(sender: UIButton) {
        let currentCardIndex = self.currentCardIndex > 0 ? self.currentCardIndex - 1 : self.playersData!.count - 1
        self.collectionView.scrollToItem(at: IndexPath(item: currentCardIndex, section: 0), at: .centeredHorizontally, animated: true)
        updateNavigationButtonsImage(cardIndex: currentCardIndex)
    }
    
    @objc private func handleNextButtonNavigation(sender: UIButton) {
        let currentCardIndex = self.currentCardIndex < playersData!.count - 1 ? self.currentCardIndex + 1 : 0
        self.collectionView.scrollToItem(at: IndexPath(item: currentCardIndex, section: 0), at: .centeredHorizontally, animated: true)
        updateNavigationButtonsImage(cardIndex: currentCardIndex)
    }
    
    private func updateNavigationButtonsImage(cardIndex: Int) {
        switch cardIndex {
        case 0:
            self.backButton.setImage(UIImage(named: "icon_previous_block"), for: .normal)
            self.forwardButton.setImage(UIImage(named: "icon_next"), for: .normal)
        case 1..<playersData!.count - 1:
            checkButtonCurrentImage(button: self.backButton, imageName: "icon_previous")
            checkButtonCurrentImage(button: self.forwardButton, imageName: "icon_next")
        case playersData!.count - 1:
            checkButtonCurrentImage(button: self.backButton, imageName: "icon_previous")
            self.forwardButton.setImage(UIImage(named: "icon_next_block"), for: .normal)
        default:
            fatalError("Oops, this should not happen")
        }
    }
    
    private func checkButtonCurrentImage(button: UIButton, imageName: String) {
        if button.currentImage != UIImage(named: imageName) {
            button.setImage(UIImage(named: imageName), for: .normal)
        }
    }
}

//TODO: move to another place
extension String {
    var numbers: String {
        return filter { "0"..."9" ~= $0 }
    }
    var plusMinusSign: String {
        return filter{Set("+-").contains($0)}
    }
}
extension String {
    subscript(idx: Int) -> String {
        String(self[index(startIndex, offsetBy: idx)])
    }
}
