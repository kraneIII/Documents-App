
import UIKit

class SettingsViewController: UIViewController {
    
    private lazy var sortView: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitleColor(.black, for: .normal)
        view.setTitle("Edit", for: .normal)
        view.setTitleColor(.systemGray5, for: .selected)
        view.addTarget(self, action: #selector(setupMenu), for: .touchUpInside)
        
        return view
    }()
    
    private lazy var sortLabel: UILabel = {
        let view = UILabel()
        view.text = "Sort elements by alphabet"
        view.font = UIFont.systemFont(ofSize: 18)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var passwordButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("Change password", for: .normal)
        view.addTarget(self, action: #selector(changePassword), for: .touchUpInside)
        view.setTitleColor(.systemBlue, for: .normal)
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        layout()
        addSubviews()
   
    }
    
    private func addSubviews() {
        view.addSubview(passwordButton)
        view.addSubview(sortView)
        view.addSubview(sortLabel)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemGray5 
    }
    
    private func layout() {
        addSubviews()
        NSLayoutConstraint.activate([
            
            sortLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 90),
            sortLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
                    
            sortView.topAnchor.constraint(equalTo: sortLabel.topAnchor, constant: -7),
            sortView.leadingAnchor.constraint(equalTo: sortLabel.trailingAnchor, constant: 10),
            
            passwordButton.topAnchor.constraint(equalTo: sortLabel.bottomAnchor, constant: 20),
            passwordButton.leadingAnchor.constraint(equalTo: sortLabel.leadingAnchor)
            
        
        ])
    }
    
    @objc func changePassword() {
        let vc = ChangePasswordViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        
        navigationController?.present(vc, animated: true)
    }
    
    @objc func setupMenu() {
        
        let alphabet = UIAction(title: "Eneble", image: UIImage(systemName: "plus")) { _ in
            FileManagerService().userDefaults.set(true, forKey: "settings")
        }
        
        let alphabetRecerce = UIAction(title: "Diseble", image: UIImage(systemName: "minus")) { _ in
            FileManagerService().userDefaults.set(false, forKey: "settings")
        }
        
        let menu = UIMenu(title: "Menu", children: [alphabet, alphabetRecerce])
        sortView.menu = menu
        sortView.showsMenuAsPrimaryAction = true
    }
    
    
    
}
