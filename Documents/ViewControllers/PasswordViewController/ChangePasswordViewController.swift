//
//  ChangePasswordViewController.swift
//  Documents
//
//  Created by Ковалев Никита on 16.10.2024.
//

import Foundation
import UIKit

class ChangePasswordViewController: UIViewController {
        
    private lazy var passwordLabel: UILabel = {
        let view = UILabel()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Change password"
        view.textColor = .systemBlue
        view.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        return view
    }()
    
    private lazy var passwordField: UITextField = {
        let view = UITextField()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.placeholder = "New password"
        view.delegate = self
        view.returnKeyType = .done
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.setLeftPaddingPoints(20)
        view.layer.borderColor = UIColor.systemBlue.cgColor
        
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        layout()
        setupUI()
        
    }
    
    private func setupUI() {
        view.backgroundColor = .systemGray5
    }
    
    private func addSubviews() {
        view.addSubview(passwordField)
        view.addSubview(passwordLabel)
    }
    
    private func layout() {
        addSubviews()
        NSLayoutConstraint.activate([
        
            passwordLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 140),
            passwordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            passwordField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 50),
            passwordField.centerXAnchor.constraint(equalTo: passwordLabel.centerXAnchor),
            passwordField.widthAnchor.constraint(equalToConstant: 200),
            passwordField.heightAnchor.constraint(equalToConstant: 50),

        ])
        
    }
    
}

extension ChangePasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        passwordField.resignFirstResponder()
        let password = passwordField.text ?? ""
        PasswordManagerService().reloadPassword(password: password)
        
        dismiss(animated: true)
        
        return true
    }
}
