import Foundation
import UIKit

class DocumentsViewController: UIViewController {
    
    var name: String = "nk"
    
    let fileManager = FileManagerService()
    
    private lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.title = "Please choose an image"
        picker.sourceType = .photoLibrary
        picker.mediaTypes = ["public.image"]
        picker.allowsEditing = true
        
        return picker
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(
            frame: .zero , style: .insetGrouped
        )
        tableView.backgroundColor = .systemBlue
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private enum CellReuseID: String {
        case document = "DocumentTableViewCell_ReuseID"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        setupUI()
        tableViewConfigure()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    private func pickImage() {
        navigationController?.present(imagePicker, animated: true, completion: nil)
    }
    
    private func setupUI() {
        title = "Documents"
        view.backgroundColor = .systemGray5
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.down.on.square.fill"), style: .plain, target: self, action: #selector(createFiles))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "photo.badge.plus"), style: .plain, target: self, action: #selector(createPhotos))
        navigationController?.navigationBar.backgroundColor = .systemGray5
        
        tabBarController?.tabBar.isHidden = false
        
    }
    
    private func addSubViews() {
        view.addSubview(tableView)
    }
    
    private func layout() {
        addSubViews()
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            tableView.leftAnchor.constraint(equalTo: safeArea.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: safeArea.rightAnchor),
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
    }
    
    private func tableViewConfigure() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "defaultTableCellIndentifier")
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func photoAlertVC() {
        //
        let alert = UIAlertController(title: "Name of photo", message: "Enter photo name", preferredStyle: .alert)
        alert.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Write something"
            textField.keyboardType = .default
            textField.textColor = .systemBlue
        }
        //
        let alertButton = UIAlertAction(title: "Ok", style: .default){ [ weak self ] (alertAction) in
            guard let self else { return }
            self.tableView.reloadData()
        }
        
        alert.addAction(alertButton)
        self.present(alert, animated: true)
    }
    
    private func fileAlertVC() {
        
        let alert = UIAlertController(title: "Name of the folder", message: "Enter file name", preferredStyle: .alert)
        alert.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Write something"
            textField.keyboardType = .default
            textField.textColor = .systemBlue
        }
        let alertButton = UIAlertAction(title: "Ok", style: .default){ [ weak self ] (alertAction) in
            guard let self else { return }
            self.fileManager.createFolder(name: alert.textFields?.first?.text ?? "")
            self.tableView.reloadData()
            
        }
        alert.addAction(alertButton)
        self.present(alert, animated: true)
    }
    
    @objc func createFiles() {
        fileAlertVC()
    }
    
    @objc func createPhotos() {
        pickImage()
    }
}


extension DocumentsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fileManager.item.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultTableCellIndentifier", for: indexPath)
        cell.textLabel?.text = fileManager.files()[indexPath.row]
        var configuration = UIListContentConfiguration.cell()
        configuration.text = fileManager.files()[indexPath.row]
        configuration.secondaryText = fileManager.isFolder(atIndex: indexPath.row) ? "Folder" : "Image"
        if let image = UIImage(contentsOfFile: fileManager.urls()[indexPath.row].path()) {
            configuration.image = image
            configuration.text = fileManager.files()[indexPath.row]
        }
        
        cell.contentConfiguration = configuration
        
        cell.layer.cornerRadius = cell.frame.height / 2
        cell.backgroundColor = .systemGray5
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 0.1
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            fileManager.deleteFile(atIndex: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        else if editingStyle == .insert {
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if fileManager.isFolder(atIndex: indexPath.row) != true {
            if indexPath.row != -1 {
                let imagePresent = ImagePresentController(image: fileManager.catchImage(fileName: fileManager.files()[indexPath.row]))
                imagePresent.title = fileManager.item[indexPath.row].description
                imagePresent.modalPresentationStyle = .formSheet
                imagePresent.modalTransitionStyle = .coverVertical
                
                present(imagePresent, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension DocumentsViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            fileManager.createFile(photo: pickedImage, content: name)
        }
        
        self.dismiss(animated: true) { [ weak self ] in
            guard let self else { return }
            self.tableView.reloadData()
        }
    }
}
