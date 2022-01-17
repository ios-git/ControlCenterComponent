//
//  ViewController.swift
//  MenuDemo
//

import UIKit

protocol MenuViewProtocol: Any {
    func reloadCollectionView()
}

class MenuViewController: UIViewController {
    
    @IBOutlet weak var viewMenu: UIView!
    @IBOutlet weak var menuCollectionView: UICollectionView!
    @IBOutlet weak var viewWidth: NSLayoutConstraint!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var viewLeading: NSLayoutConstraint!
    @IBOutlet weak var viewTop: NSLayoutConstraint!
    
    @IBOutlet weak var viewCenterX: NSLayoutConstraint!
    @IBOutlet weak var viewCenterY: NSLayoutConstraint!
    
    private let sectionInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
    private let itemsPerRow: CGFloat = 2
    
    var maxWidth : CGFloat!
    var maxHeight : CGFloat!
    
    var minCollectionWidth : CGFloat!
    var minCollectionHeight : CGFloat!
    
    var maxCollectionWidth : CGFloat!
    var maxCollectionHeight : CGFloat!
    var shouldDisplayName: Bool = false
    
    lazy var viewModel = MenuViewModel(delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        viewMenu.addShadow()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        viewMenu.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.maxWidth = (self.view.frame.width - (20 + viewWidth.constant))
        self.maxHeight = (self.view.frame.height - (20 + viewHeight.constant))
        self.minCollectionHeight = self.menuCollectionView.contentSize.height
        self.minCollectionWidth = self.menuCollectionView.contentSize.width
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if !viewModel.isMenuOpen {
            viewModel.isMenuOpen  = true
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            
            viewModel.createMenu()
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                self.viewMenu.translatesAutoresizingMaskIntoConstraints = false
                
                self.viewTop.isActive = false
                self.viewLeading.isActive = false
                
                self.viewCenterX.isActive = true
                self.viewCenterY.isActive = true
                
                self.shouldDisplayName = true
                self.menuCollectionView.reloadData()

                self.maxCollectionWidth = self.menuCollectionView.contentSize.width + 45
                self.maxCollectionHeight = self.menuCollectionView.contentSize.height + 45
                
                UIView.animate(withDuration: 0.27, delay: 0.0, options: [.curveLinear], animations: { () -> Void in
                    self.viewWidth.constant = self.maxCollectionWidth
                    self.viewHeight.constant = self.maxCollectionHeight
                    self.view.layoutIfNeeded()
                }) { (animationCompleted: Bool) -> Void in
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if viewModel.isMenuOpen {
            viewModel.isMenuOpen = false
            
            viewModel.createMenu()
            
            self.viewMenu.translatesAutoresizingMaskIntoConstraints = false
            
            self.viewCenterX.isActive = false
            self.viewCenterY.isActive = false
            
            self.viewTop.isActive = true
            self.viewLeading.isActive = true
            
            self.shouldDisplayName = false
            self.menuCollectionView.reloadData()
            
            UIView.animate(withDuration: 0.27, delay: 0.0, options: [.curveLinear], animations: { () -> Void in
                self.viewWidth.constant = self.minCollectionWidth - 10
                self.viewHeight.constant = self.minCollectionHeight - 10
                self.view.layoutIfNeeded()
            }) { (animationCompleted: Bool) -> Void in
            }
        }
    }
    
}

//MARK: - CollectionViewDelegate, CollectionViewDataSource -
extension MenuViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.rows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCollectionCell", for: indexPath) as? MenuCollectionCell {
            switch viewModel.row(for: indexPath) {
                case .menu(let title, let imageName):
                    cell.configureCell(title: self.shouldDisplayName ? title : "", imageName: imageName)
                    cell.menuButtonAction = {
                        debugPrint("\(title) clicked")
                    }
            }
            return cell
        }
        return UICollectionViewCell()
    }
}

//MARK: - CollectionViewFlowLayout -
extension MenuViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        switch viewModel.row(for: indexPath) {
            case .menu(let title, _):
                if viewModel.isMenuOpen {
                    let labelHeight = title.height(withConstrainedWidth: widthPerItem, font: UIFont(name: "Arial", size: 14.0)!)
                    return CGSize(width: widthPerItem, height: widthPerItem + labelHeight)
                } else {
                    return CGSize(width: widthPerItem, height: widthPerItem)
                }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
}

extension MenuViewController: MenuViewProtocol {
    func reloadCollectionView() {
        self.menuCollectionView.reloadData()
    }
}
