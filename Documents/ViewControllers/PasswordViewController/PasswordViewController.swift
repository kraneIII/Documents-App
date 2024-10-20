
import UIKit
import KeychainSwift

extension UIStackView {
    
    func addSeparators(at positions: [Int], color: UIColor) {
        for position in positions {
            let separator = UIView()
            separator.backgroundColor = color
            
            insertArrangedSubview(separator, at: position)
            switch self.axis {
            case .horizontal:
                separator.widthAnchor.constraint(equalToConstant: 1).isActive = true
                separator.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1).isActive = true
            case .vertical:
                separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
                separator.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
            @unknown default:
                fatalError("Unknown UIStackView axis value.")
            }
        }
    }
}

enum UserState {
    case notAuthoriz
    case savedPassword
    case reloadData
}

enum ButtonState {
    case firstPassword
    case repeatPassword
}

class PasswordViewController: UIViewController, UITextFieldDelegate {
    
    var mainNavigationController: UINavigationController?
    var state: UserState?
    private var buttonState: ButtonState = .firstPassword
    private var firstPassword = ""
    private var secondPassword = ""
    
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.addArrangedSubview(passwordView)
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 15
        view.layer.borderColor = UIColor.systemGray.cgColor
        view.layer.borderWidth = 1
        
        return view
    }()
    
    private lazy var loginButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitleColor(.systemBlue, for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        view.setTitleColor(.systemGray5, for: .selected)
        view.addTarget(self, action: #selector(gotoMainController), for: .touchUpInside)
        
        return view
    }()
        
    private lazy var passwordView: UITextField = {
        let view = UITextField()
        view.placeholder = "Enter password"
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setLeftPaddingPoints(20)
        view.resignFirstResponder()
        view.delegate = self
        
        return view
    }()

    private lazy var indicator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        view.isHidden = true
        
        return view
    }()
    
    private lazy var image: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Icon")
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addSubviews()
        checkPassword()
        layout()
        checkLogin()
        
//        stackView.addSeparators(at: [1], color: .systemGray)
        
    }
    
    private func layout() {
        addSubviews()
        NSLayoutConstraint.activate([
            
            image.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            image.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            image.heightAnchor.constraint(equalToConstant: 150),
            image.widthAnchor.constraint(equalToConstant: 150),
            
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -165),
            loginButton.heightAnchor.constraint(equalToConstant: 30),
            loginButton.widthAnchor.constraint(equalToConstant: 150),
            
            indicator.bottomAnchor.constraint(equalTo: stackView.bottomAnchor,constant: -10),
            indicator.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -10),
            indicator.heightAnchor.constraint(equalToConstant: 10),
            indicator.widthAnchor.constraint(equalToConstant: 10),
            
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            stackView.widthAnchor.constraint(equalToConstant: 100),
            
            passwordView.heightAnchor.constraint(equalToConstant: 30),
            
        ])
    }
    
    private func checkLoginButton() {
        if state == .notAuthoriz {
            loginButton.setTitle("Create password", for: .normal)
        }
        if state == .savedPassword {
            loginButton.setTitle("Enter password", for: .normal)

        }
    }
    
    private func checkLogin() {
        if PasswordManagerService().startPassword() {
            state = .savedPassword
        }
        else {
            state = .notAuthoriz
        }
        checkLoginButton()
    }
    
    private func textFieldSetup() {
        if buttonState == .firstPassword {
            let password = passwordView.text ?? ""
            firstPassword = password
            clearTextField()
            passwordView.placeholder = "Repeat password"
            buttonState = .repeatPassword
        }
        else if buttonState == .repeatPassword {
            let password = passwordView.text ?? ""
            secondPassword = password
            if firstPassword == secondPassword {
                PasswordManagerService().savePassword(password: secondPassword)
                clearTextField()
                dismiss(animated: true)
                passwordView.placeholder = "Enter password"
                loginButton.setTitle("Create password", for: .normal)
                buttonState = .firstPassword
            }
            else {
                clearTextField()
                passwordView.placeholder = "Enter password"
                loginButton.setTitle("Create password", for: .normal)
                buttonState = .firstPassword
                
            }
            
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .systemGray5
        title = "LogIn"
    }
    
    private func addSubviews() {
        view.addSubview(indicator)
        view.addSubview(loginButton)
        view.addSubview(stackView)
        view.addSubview(image)
    }
    
    private func checkPassword() {
//        if passwordView.text!.count < 4 {
//            indicator.backgroundColor = .red
//            loginButton.isEnabled = false
//        }
//        else {
//            indicator.backgroundColor = .green
//            loginButton.isEnabled = true
//        }
//        view.reloadInputViews()
    }
    
    private func alert() {
        let alertAction = UIAlertAction(title: "Wrong password", style: .default)
        let alertVC = UIAlertController()
        alertVC.addAction(alertAction)
        navigationController?.present(alertVC, animated: true)
    }
    
    //MARK: - Auth
    
    private func authification() {
        let userPassword = passwordView.text ?? ""
        if PasswordManagerService().checkPassword(password: userPassword) {
            dismiss(animated: true)
        }
        else {
            alert()
        }
    }
    
    private func clearTextField() {
        passwordView.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        passwordView.resignFirstResponder()

        return true
    }
    
    @objc func gotoMainController() {
        
        if state == .notAuthoriz {
            textFieldSetup()
        }
        if state == .savedPassword {
            authification()
        }
        if state == .reloadData {
            navigationController?.dismiss(animated: true)
        }
    }
    
}

