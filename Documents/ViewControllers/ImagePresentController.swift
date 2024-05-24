//
//  ImagePresentController.swift
//  Documents
//
//  Created by Ковалев Никита on 24.05.2024.
//

import UIKit

class ImagePresentController: UIViewController {
    
    var imageView = UIImageView()
    private var image: UIImage
    
    init(image: UIImage) {
        self.image = image
        imageView.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        setupUI()
        layout()
        
    }
    
    private func setupUI() {
        view.backgroundColor = #colorLiteral(red: 0.8370831609, green: 0.8501555324, blue: 0.8472587466, alpha: 0.8470588235)
    }
    
    private func layout() {
        let safeArea = view.safeAreaLayoutGuide
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
        
            imageView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 150),
            imageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 45),
            imageView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -45),
            imageView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -150)
            
        ])
    }
    
}
