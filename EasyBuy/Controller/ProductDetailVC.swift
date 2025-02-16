//
//  ProductDetailVC.swift
//  EasyBuy
//
//  Created by mruss on 2/15/25.
//

import UIKit
import SnapKit

// MARK: - ProductDetailVC
class ProductDetailVC: UIViewController {
    
    // MARK: - Properties
    var product: Product
    
    // MARK: - UI Elements
    let productImageView = UIImageView()
    let priceLabel = UILabel()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    
    let buyButton = UIButton(type: .system)
    
    // MARK: - Initialization
    init(product: Product) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupNavigationBar()
        setupUI()
        configureUI()
    }
    
    // MARK: - Setup Methods
    func setupNavigationBar() {
        
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareProduct))
        navigationItem.rightBarButtonItem = shareButton
    }
    
    func setupUI() {
        productImageView.contentMode = .scaleAspectFill
        productImageView.clipsToBounds = true
        
        priceLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        priceLabel.textColor = .label
        
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 0
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 0
        
        view.addSubview(productImageView)
        view.addSubview(priceLabel)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        
        productImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(productImageView.snp.width) 
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(productImageView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        buyButton.setTitle("Buy", for: .normal)
        buyButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        buyButton.setTitleColor(.white, for: .normal)
        buyButton.backgroundColor = .systemPurple
        buyButton.layer.cornerRadius = 8
        
        buyButton.addTarget(self, action: #selector(didTapBuy), for: .touchUpInside)
        
        view.addSubview(buyButton)
        
        buyButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.height.equalTo(50)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.bottom.lessThanOrEqualTo(buyButton.snp.top).offset(-16)
        }
    }
    
    // MARK: - Configuration
    func configureUI() {
        priceLabel.text = "\(product.price) $"
        titleLabel.text = product.title
        descriptionLabel.text = product.description
        
        if let imageUrlString = product.images.first {
            ImageLoader().loadImage(from: imageUrlString) { [weak self] image in
                DispatchQueue.main.async {
                    if let image = image {
                        self?.productImageView.image = image
                    } else {
                        self?.productImageView.image = UIImage(named: "placeholder")
                    }
                }
            }
        } else {
            productImageView.image = UIImage(named: "placeholder")
        }
    }
    
    // MARK: - Actions
    @objc func shareProduct() {
        let shareText = """
        \(product.title)

        \(product.description)

        Price: \(product.price) $
        """
        let activityVC = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        present(activityVC, animated: true)
    }
    
    
    @objc func didTapBuy() {
        CartManager.shared.add(product: product, quantity: 1)
            
        let alert = UIAlertController(title: "Added to cart",
                                         message: "\(product.title)",
                                         preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default))
           present(alert, animated: true)
            
    }
}
