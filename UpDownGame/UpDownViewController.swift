//
//  UpDownViewController.swift
//  UpDownGame
//
//  Created by BAE on 1/9/25.
//

import UIKit

class UpDownViewController: UIViewController {

    static let identifier = "UpDownViewController"
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var checkButton: UIButton!
    @IBOutlet var tryLabel: UILabel!
    @IBOutlet var upDownLabel: UILabel!
    
    var setNumber: Int?
//    lazy var numList: [Int] = Array(1...setNumber!)
    var numList: [Int] {
        if let setNumber {
            return Array(1...setNumber)
        } else {
            print("range 초기화 실패")
            return Array(1...30)
        }
    }
    
    lazy var upDownList: [UpDown] = numList.map { UpDown(number: $0, isSelected: false, cornerRadius: circleDiameter / 2)
    } {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var target: Int {
        if let setNumber {
            return Array(1...setNumber).randomElement() ?? 1
        } else {
            print("target 초기화 실패")
            return 1
        }
    }
    
    var tryCount: Int = 0
    
    private let deviceWidth = UIScreen.currentDeviceWidth
    private let leftRightInset: CGFloat = 16
    private let circleSpacing: CGFloat = 4
    lazy var circleDiameter: CGFloat = (deviceWidth - circleSpacing * 4) / 6
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .upDownGameBg
        configCollectionView()
        print(circleDiameter)
        configCheckButton()
    }
    
    func configCheckButton() {
        checkButton.isEnabled = false
        checkButton.setTitleColor(.white, for: .normal)
        checkButton.setTitleColor(.white, for: .disabled)
        checkButton.setBackgroundColor(.black, for: .normal)
        checkButton.setBackgroundColor(.gray, for: .disabled)
    }
    
    @IBAction func checkButtonTapped(_ sender: UIButton) {
        checkButton.isEnabled = false
        collectionView.isUserInteractionEnabled = true
        for i in 0..<upDownList.count {
            upDownList[i].isSelected = false
        }
    }

}


extension UpDownViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func configCollectionView() {
        let layout = UICollectionViewFlowLayout()
        collectionView.collectionViewLayout = layout
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.register(UINib(nibName: UpDownCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: UpDownCollectionViewCell.identifier)
    
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: circleDiameter, height: circleDiameter)
        layout.minimumLineSpacing = circleSpacing
        layout.minimumInteritemSpacing = circleSpacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: leftRightInset, bottom: 0, right: leftRightInset)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        upDownList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UpDownCollectionViewCell.identifier, for: indexPath) as! UpDownCollectionViewCell
//        
//        cell.clipsToBounds = true
//        cell.layer.cornerRadius = circleDiameter / 2
        
        cell.config(row: upDownList[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        checkButton.isEnabled = true
        collectionView.isUserInteractionEnabled = false
        tryCount += 1
        tryLabel.text = "시도 횟수: \(tryCount)"
        upDownList[indexPath.item].isSelected.toggle()
        
        if upDownList[indexPath.item].number == target {
            upDownLabel.text = "GOOD !"
            
        } else {
            
        }
        
        collectionView.reloadData()
        
        
    }
}

extension UIButton {
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1.0, height: 1.0))
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0))
        
        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
         
        self.setBackgroundImage(backgroundImage, for: state)
    }
}
