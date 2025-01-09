//
//  UpDownCollectionViewCell.swift
//  UpDownGame
//
//  Created by BAE on 1/9/25.
//

import UIKit

class UpDownCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "UpDownCollectionViewCell"
    
    @IBOutlet var numLabel: UILabel!
    
//    override var isSelected: Bool {
//        didSet {
//            print("didset")
//            backgroundColor = isSelected ? .white : .black
//            numLabel.textColor = isSelected ? .black : .white
//        }
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .white
    }
    
    func config(row: UpDown) {
        numLabel.text = "\(row.number)"
        numLabel.textColor = row.isSelected ? .white : .black
        backgroundColor = row.isSelected ? .black : .white
        clipsToBounds = true
        layer.cornerRadius = row.cornerRadius
    }
}
