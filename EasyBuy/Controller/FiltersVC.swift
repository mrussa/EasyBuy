//
//  FiltersVC.swift
//  EasyBuy
//
//  Created by mruss on 2/13/25.
//

import UIKit
import SnapKit

// MARK: - FiltersVC
class FiltersVC: UIViewController {
    
    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    
    private let footerView = UIView()
    
    private let categoryStackView = UIStackView()
    private let sortByStackView = UIStackView()
    
    private let fromTextField = UITextField()
    private let toTextField = UITextField()
    
    var selectedCategory: String?
    var selectedSortOption: String?
    var priceFrom: String?
    var priceTo: String?
    
    var onApplyFilters: ((String?, String?, String?, String?) -> Void)?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Filters"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close,
                                                           target: self,
                                                           action: #selector(exitFilters))
        
        setupFooterView()
        setupScrollViewAndStackView()
        setupContent()
    }
    
    // MARK: - Setup Footer View
    private func setupFooterView() {
        footerView.backgroundColor = .white
        view.addSubview(footerView)
        footerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(80)
        }
        
        let applyButton = UIButton(type: .system)
        applyButton.setTitle("Apply Filters", for: .normal)
        applyButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        applyButton.backgroundColor = .black
        applyButton.setTitleColor(.white, for: .normal)
        applyButton.layer.cornerRadius = 10
        applyButton.addTarget(self, action: #selector(applyFilters), for: .touchUpInside)
        
        footerView.addSubview(applyButton)
        applyButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
    // MARK: - Setup ScrollView and StackView
    private func setupScrollViewAndStackView() {
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(footerView.snp.top)
        }
        
        stackView.axis = .vertical
        stackView.spacing = 12
        
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.contentLayoutGuide.snp.top)
            make.bottom.equalTo(scrollView.contentLayoutGuide.snp.bottom).offset(-20)
            make.leading.equalTo(scrollView.contentLayoutGuide.snp.leading).offset(16)
            make.trailing.equalTo(scrollView.contentLayoutGuide.snp.trailing).offset(-16)
            make.width.equalTo(scrollView.frameLayoutGuide.snp.width).offset(-32)
        }
    }
    
    // MARK: - Setup Content
    private func setupContent() {
        let titleLabel = UILabel()
        titleLabel.text = "All categories"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textAlignment = .left
        stackView.addArrangedSubview(titleLabel)
        
        categoryStackView.axis = .vertical
        categoryStackView.spacing = 8
        
        let categories = ["Clothes", "Electronics", "Furniture", "Shoes", "Miscellaneous"]
        for category in categories {
            let button = UIButton(type: .system)
            button.setTitle(category, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
            button.backgroundColor = .systemGray5
            button.setTitleColor(.black, for: .normal)
            button.layer.cornerRadius = 8
            button.addTarget(self, action: #selector(categorySelected(_:)), for: .touchUpInside)
            categoryStackView.addArrangedSubview(button)
        }
        stackView.addArrangedSubview(categoryStackView)
        
        let titleLabel2 = UILabel()
        titleLabel2.text = "Price Range"
        titleLabel2.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel2.textAlignment = .left
        stackView.addArrangedSubview(titleLabel2)
        
        let priceRangesStackView = UIStackView()
        priceRangesStackView.axis = .horizontal
        priceRangesStackView.spacing = 8
        priceRangesStackView.distribution = .fillEqually
        
        fromTextField.placeholder = "From"
        fromTextField.font = UIFont.systemFont(ofSize: 16)
        fromTextField.backgroundColor = .systemGray5
        fromTextField.layer.cornerRadius = 8
        fromTextField.textAlignment = .left
        fromTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 44))
        fromTextField.leftViewMode = .always
        fromTextField.addTarget(self, action: #selector(priceChanged(_:)), for: .editingChanged)
        
        fromTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        toTextField.placeholder = "To"
        toTextField.font = UIFont.systemFont(ofSize: 16)
        toTextField.backgroundColor = .systemGray5
        toTextField.layer.cornerRadius = 8
        toTextField.textAlignment = .left
        toTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 44))
        toTextField.leftViewMode = .always
        toTextField.addTarget(self, action: #selector(priceChanged(_:)), for: .editingChanged)
        
        toTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        priceRangesStackView.addArrangedSubview(fromTextField)
        priceRangesStackView.addArrangedSubview(toTextField)
        stackView.addArrangedSubview(priceRangesStackView)
        
        let titleLabel3 = UILabel()
        titleLabel3.text = "Sort By"
        titleLabel3.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel3.textAlignment = .left
        stackView.addArrangedSubview(titleLabel3)
        
        sortByStackView.axis = .vertical
        sortByStackView.spacing = 8
        
        let sortOptions = ["Price: Low to High", "Price: High to Low"]
        for sortBy in sortOptions {
            let button = UIButton(type: .system)
            button.setTitle(sortBy, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
            button.backgroundColor = .systemGray5
            button.setTitleColor(.black, for: .normal)
            button.layer.cornerRadius = 8
            button.addTarget(self, action: #selector(sortSelected(_:)), for: .touchUpInside)
            sortByStackView.addArrangedSubview(button)
        }
        stackView.addArrangedSubview(sortByStackView)
    }
    
    // MARK: - Actions
    @objc func categorySelected(_ sender: UIButton) {
        guard let selectedCategory = sender.titleLabel?.text else { return }
        self.selectedCategory = selectedCategory
        
        for button in categoryStackView.arrangedSubviews as! [UIButton] {
            button.backgroundColor = (button == sender) ? .black : .systemGray5
            button.setTitleColor((button == sender) ? .white : .black, for: .normal)
        }
    }
    
    @objc func sortSelected(_ sender: UIButton) {
        guard let selectedSort = sender.titleLabel?.text else { return }
        self.selectedSortOption = selectedSort
        
        for button in sortByStackView.arrangedSubviews as! [UIButton] {
            button.backgroundColor = (button == sender) ? .black : .systemGray5
            button.setTitleColor((button == sender) ? .white : .black, for: .normal)
        }
    }
    
    @objc func priceChanged(_ sender: UITextField) {
        if sender == fromTextField {
            self.priceFrom = sender.text
        } else if sender == toTextField {
            self.priceTo = sender.text
        }
    }
    
    @objc func applyFilters() {
        
        let priceFromValue = priceFrom ?? "0"
        let priceToValue = priceTo ?? "999999"
        
        if selectedSortOption == "Price: Low to High" {
            onApplyFilters?(getCategoryId(for: selectedCategory), priceFromValue, priceToValue, "asc")
        } else if selectedSortOption == "Price: High to Low" {
            onApplyFilters?(getCategoryId(for: selectedCategory), priceFromValue, priceToValue, "desc")
        } else {
            onApplyFilters?(getCategoryId(for: selectedCategory), priceFromValue, priceToValue, nil)
        }
        
        dismiss(animated: true)
    }
    
    @objc func exitFilters() {
        dismiss(animated: true)
    }
    
    
    func getCategoryId(for category: String?) -> String? {
        let categoryMapping: [String: String] = [
            "Clothes": "1",
            "Electronics": "2",
            "Furniture": "3",
            "Shoes": "4",
            "Miscellaneous": "5"
        ]
        return categoryMapping[category ?? ""]
    }
}
