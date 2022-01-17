//
//  MenuCollectionCell.swift
//  MenuDemo
//

import Foundation
import UIKit


class MenuCollectionCell: UICollectionViewCell {
    @IBOutlet weak var menuImageView: UIImageView!
    @IBOutlet weak var menuTitleLabel: UILabel!
    
    var menuButtonAction: (() -> Void)? = nil
    
    func configureCell(title: String, imageName: String) {
        menuTitleLabel.text = title
        menuImageView.image = UIImage(systemName: imageName)
    }
    
    @IBAction func menuClicked(_ sender: Any) {
        menuButtonAction?()
    }
    
}

