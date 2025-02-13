//
//  FiltersVC.swift
//  EasyBuy
//
//  Created by mruss on 2/13/25.
//

import UIKit

class FiltersVC: UIViewController {
    
    @objc func exitFilters() {
        dismiss(animated: true)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        title = "Filters"
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(exitFilters))
        
        let titleLabel = UILabel()
        titleLabel.text = "All categories"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
            
        }
        
        let categories = ["Clothes", "Electronics", "Furniture", "Shoes", "Miscellaneous"]
        
        let categoryStackView = UIStackView()
        categoryStackView.axis = .vertical
        categoryStackView.spacing = 8
        categoryStackView.distribution = .fillEqually
        categoryStackView.alignment = .fill
        
        for category in categories {
            let button = UIButton()
            button.setTitle(category, for: .normal)
            button.backgroundColor = .systemGray5
            button.setTitleColor(.black, for: .normal)
            button.layer.cornerRadius = 8

            var config = UIButton.Configuration.filled()
            config.baseBackgroundColor = .systemGray6
            config.baseForegroundColor = .black
            config.cornerStyle = .medium
            config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
            button.configuration = config
            
            categoryStackView.addArrangedSubview(button)
        }
        
        view.addSubview(categoryStackView)
        categoryStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            
            
            
            
            
        }
        
    }


}
