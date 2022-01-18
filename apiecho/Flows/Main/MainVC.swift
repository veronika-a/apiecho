//
//  ViewController.swift
//  apiecho
//
//  Created by Veronika Andrianova on 18.01.2022.
//

import UIKit
import SnapKit

class MainVC: UIViewController {
    private let viewModel: MainViewModel
    private var updateData: UpdateData?

    private var nameTF: UITextField?
    private var emailTF: UITextField?
    private var passTF: UITextField?

    required init(mainViewModel: MainViewModel) {
        self.viewModel = mainViewModel
        super.init(nibName: nil, bundle: nil)
      }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    @objc private func singup() {
        let parameters = ["name": nameTF?.text ?? "",
                          "email": emailTF?.text ?? "",
                          "password": passTF?.text ?? "" ]
        viewModel.singup(parameters: parameters) { [weak self] resoult in
            switch resoult {
            case .success(let info):
                guard let self = self, let info = info else {return}
                self.navigationController?.pushViewController(TableInfoVC(info: info), animated: true)
            case .failure(let error):
                print(error)
            }
        }
    }

    @objc private func login() {
        let parameters = ["email": emailTF?.text ?? "",
                          "password": passTF?.text ?? "" ]
        viewModel.login(parameters: parameters) { [weak self] resoult in
            switch resoult {
            case .success(let info):
                guard let self = self, let info = info else {return}
                self.navigationController?.pushViewController(TableInfoVC(info: info), animated: true)
            case .failure(let error):
                print(error)
            }
        }
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension MainVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return false
    }
}

private extension MainVC {
    func createView() {
        view.backgroundColor = UIColor.white
        let stackView = UIStackView()
        stackView.spacing = 24
        stackView.axis = .vertical
        view.addSubview(stackView)
        stackView.snp.makeConstraints { (make) -> Void in
            make.center.equalToSuperview()
            make.left.right.equalTo(view.safeAreaLayoutGuide).offset(24)
        }

        let text = UILabel()
        text.text = "Hello!"
        text.textColor = UIColor.black
        text.font = text.font.withSize(36)
        text.textAlignment = .center
        stackView.addArrangedSubview(text)
        text.snp.makeConstraints { (make) -> Void in
            make.left.right.equalTo(view.safeAreaLayoutGuide).inset(24)
        }

        let nameTF = createTF(stackView: stackView, text: "Name *(only for singup)")
        self.nameTF = nameTF
        nameTF.delegate = self

        let emailTF = createTF(stackView: stackView, text: "Email")
        self.emailTF = emailTF
        emailTF.delegate = self

        let passTF = createTF(stackView: stackView, text: "Password")
        self.passTF = passTF
        passTF.delegate = self

        let loginButton = UIButton()
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.setTitle("Login", for: .normal)
        loginButton.layer.cornerRadius = 16
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        loginButton.backgroundColor = UIColor.gray
        stackView.addArrangedSubview(loginButton)
        loginButton.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(48)
        }

        let singupButton = UIButton()
        singupButton.setTitleColor(UIColor.white, for: .normal)
        singupButton.setTitle("SingUp", for: .normal)
        singupButton.layer.cornerRadius = 16
        singupButton.addTarget(self, action: #selector(singup), for: .touchUpInside)
        singupButton.backgroundColor = UIColor.gray
        stackView.addArrangedSubview(singupButton)
        singupButton.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(48)
        }
    }

    func createTF(stackView: UIStackView, text: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = text
        textField.layer.cornerRadius = 16
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 2
        textField.layer.backgroundColor = UIColor.white.cgColor
        textField.returnKeyType = UIReturnKeyType.done
        stackView.addArrangedSubview(textField)
        textField.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(48)
        }
        return textField
    }
}
