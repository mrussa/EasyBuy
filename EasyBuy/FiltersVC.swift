import UIKit
import SnapKit

class FiltersVC: UIViewController {
    
    @objc func exitFilters() {
        dismiss(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        scrollView.addSubview(stackView)
        
        title = "Filters"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(exitFilters))
        
        let titleLabel = UILabel()
        titleLabel.text = "All categories"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textAlignment = .left
        stackView.addArrangedSubview(titleLabel)
        
        let categories = ["Clothes", "Electronics", "Furniture", "Shoes", "Miscellaneous"]
        
        let categoryStackView = UIStackView()
        categoryStackView.axis = .vertical
        categoryStackView.spacing = 8
        
        for category in categories {
            let button = UIButton()
            button.setTitle(category, for: .normal)
            button.backgroundColor = .systemGray5
            button.setTitleColor(.black, for: .normal)
            button.layer.cornerRadius = 8
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
        
        let fromTextField = UITextField()
        fromTextField.placeholder = "From"
        fromTextField.backgroundColor = .systemGray5
        fromTextField.layer.cornerRadius = 8
        fromTextField.textAlignment = .left
        fromTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 44))
        fromTextField.leftViewMode = .always
        
        let toTextField = UITextField()
        toTextField.placeholder = "To"
        toTextField.backgroundColor = .systemGray5
        toTextField.layer.cornerRadius = 8
        toTextField.textAlignment = .left
        toTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 44))
        toTextField.leftViewMode = .always
        
        priceRangesStackView.addArrangedSubview(fromTextField)
        priceRangesStackView.addArrangedSubview(toTextField)
        
        stackView.addArrangedSubview(priceRangesStackView)
        
        let titleLabel3 = UILabel()
        titleLabel3.text = "Sort By"
        titleLabel3.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel3.textAlignment = .left
        stackView.addArrangedSubview(titleLabel3)
        
        let sortOptions = ["Popularity", "Price: Low to High", "Price: High to Low", "Newest First"]
        
        let sortByStackView = UIStackView()
        sortByStackView.axis = .vertical
        sortByStackView.spacing = 8
        
        for sortBy in sortOptions {
            let button = UIButton()
            button.setTitle(sortBy, for: .normal)
            button.backgroundColor = .systemGray5
            button.setTitleColor(.black, for: .normal)
            button.layer.cornerRadius = 8
            sortByStackView.addArrangedSubview(button)
        }
        
        stackView.addArrangedSubview(sortByStackView)
        
        let titleLabel4 = UILabel()
        titleLabel4.text = "Sellers"
        titleLabel4.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel4.textAlignment = .left
        stackView.addArrangedSubview(titleLabel4)
        
        let sellersOptions = ["All sellers", "Private sellers", "Companies"]
        
        let sellersOptionsStackView = UIStackView()
        sellersOptionsStackView.axis = .vertical
        sellersOptionsStackView.spacing = 8
        
        for sellers in sellersOptions {
            let button = UIButton()
            button.setTitle(sellers, for: .normal)
            button.backgroundColor = .systemGray5
            button.setTitleColor(.black, for: .normal)
            button.layer.cornerRadius = 8
            sellersOptionsStackView.addArrangedSubview(button)
        }
        
        stackView.addArrangedSubview(sellersOptionsStackView)
        
        let footerView = UIView()
        footerView.backgroundColor = .white
        view.addSubview(footerView)
        
        let applyButton = UIButton()
        applyButton.setTitle("Apply Filters", for: .normal)
        applyButton.backgroundColor = .black
        applyButton.setTitleColor(.white, for: .normal)
        applyButton.layer.cornerRadius = 10
        footerView.addSubview(applyButton)

        scrollView.addSubview(stackView)
        
        categoryStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
        }
        
        priceRangesStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel2.snp.bottom).offset(12)
            make.height.equalTo(44)
        }

        fromTextField.snp.makeConstraints { make in
            make.width.equalToSuperview().dividedBy(2).offset(-4)
        }

        toTextField.snp.makeConstraints { make in
            make.width.equalToSuperview().dividedBy(2).offset(-4)
        }
        
        sortByStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel3.snp.bottom).offset(12)
        }

        sellersOptionsStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16) 
            make.top.equalTo(titleLabel4.snp.bottom).offset(12)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(footerView.snp.top)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        footerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(80)
        }
        
        applyButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.height.equalTo(50)
        }
    }
}
