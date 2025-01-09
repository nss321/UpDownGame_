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
    
    lazy var target: Int = Array(1...(setNumber ?? 1)).randomElement() ?? 1
    
    var tryCount: Int = 0
    
    private let deviceWidth = UIScreen.currentDeviceWidth
    private let leftRightInset: CGFloat = 16
    private let circleSpacing: CGFloat = 4
    lazy var circleDiameter: CGFloat = (deviceWidth - circleSpacing * 4) / 6
    
    var arrayOffset = 0
    
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
        print(sender.tag)
        checkButton.isEnabled = false
        checkCorrectAnswer(select: sender.tag)
    }
    
    func checkCorrectAnswer(select: Int){
        var index = 0
        tryCount += 1
        tryLabel.text = "시도 횟수: \(tryCount)"
        if select == target {
            upDownLabel.text = "GOOD!"
//            collectionView.isUserInteractionEnabled = false
            showAlert("YOU WIN!", "메인으로 돌아가시겠어요?") { _ in
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            if select < target {
                index = upDownList.filter { $0.number <= select }.count
                upDownList.removeSubrange(0..<index)
            } else {
                index = upDownList.filter { $0.number < select}.count
                upDownList.removeSubrange(index..<upDownList.count)
            }
        }
        print(upDownList.indices)
        resetGame()
    }
    
    func resetGame() {
        for i in upDownList.indices {
            upDownList[i].isSelected = false
        }
        checkButton.tag = 0
        collectionView.reloadData()
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
//        print(#function)
        let item = upDownList[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UpDownCollectionViewCell.identifier, for: indexPath) as! UpDownCollectionViewCell
        
        cell.config(row: item)

//        print(indexPath.item, item.isSelected)
//        cell.isUserInteractionEnabled = item.isSelected ? true : false
//        // TODO: 로직 개선
//        var cnt = 0
//        upDownList.forEach {
//            if $0.isSelected {
//                cnt += 1
//            }
//        }
//        if cnt == 0 {
//            cell.isUserInteractionEnabled = true
//        }
        
        /// 모든 셀이
        if upDownList.filter({ $0.isSelected == true }).isEmpty {
            cell.isUserInteractionEnabled = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function)
        if upDownList[indexPath.item].isSelected {
            checkButton.isEnabled = false
            upDownList[indexPath.item].isSelected = false
        } else {
            checkButton.isEnabled = true
            checkButton.tag = upDownList[indexPath.item].number
            upDownList[indexPath.item].isSelected = true
        }
        print(target)
    }
    
    /// didDeselectItemAt은 대체 언제 호출되는건지,,,?
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        print(#function)
//        checkButton.isEnabled = false
//        upDownList[indexPath.item].isSelected.toggle()
//    }
    
    
    
    func disabledEveryCellExceptFor(cell: Int) {
        
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
