//
//  ViewController.swift
//  UpDownGame
//
//  Created by BAE on 1/9/25.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .upDownGameBg
        textField.keyboardType = .numberPad
        textField.delegate = self
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        // Do any additional setup after loading the view.
    }

    @IBAction func textFieldReturnTapped(_ sender: UITextField) {
        pushGameViewController()
    }
    @IBAction func startButtonTapped(_ sender: UIButton) {
        pushGameViewController()
    }
    
    func showAlert(_ title: String, _ message: String, handler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default, handler: handler)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    func pushGameViewController() {
        let vc = storyboard?.instantiateViewController(withIdentifier: UpDownViewController.identifier) as! UpDownViewController
    
        if let text = textField.text, let number = Int(text)  {
            vc.setNumber = number
        } else {
            showAlert("🚨🚨 경고 🚨🚨", "숫자를 입력해주세요!") { _ in
                self.textField.text = ""
            }
        }

        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = ""
    }
}
