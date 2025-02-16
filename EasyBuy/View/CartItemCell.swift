import UIKit
import SnapKit

// MARK: - CartItemCell
class CartItemCell: UITableViewCell {
    
    let productImageView = UIImageView()
    
    let mainStackView = UIStackView()
    
    let infoStackView = UIStackView()
    
    let titleLabel = UILabel()
    let priceLabel = UILabel()
    
    let quantityContainer = UIView()
    let minusButton = UIButton(type: .system)
    let quantityLabel = UILabel()
    let plusButton = UIButton(type: .system)
    
    let deleteButton = UIButton(type: .system)
    
    // MARK: - Callbacks
    var onQuantityChange: ((Int) -> Void)?
    var onDelete: (() -> Void)?
    
    // MARK: - Properties
    private var currentQuantity: Int = 1
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        backgroundColor = .white
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    func setupUI() {
        
        productImageView.contentMode = .scaleAspectFill
        productImageView.clipsToBounds = true
        productImageView.layer.cornerRadius = 12
        
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        priceLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        
        quantityContainer.backgroundColor = .systemGray5
        quantityContainer.layer.cornerRadius = 8
        
        minusButton.setTitle("-", for: .normal)
        minusButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        minusButton.tintColor = .label
        
        quantityLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        quantityLabel.textAlignment = .center
        
        plusButton.setTitle("+", for: .normal)
        plusButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        plusButton.tintColor = .label
        
        let trashImage = UIImage(systemName: "trash")
        deleteButton.setImage(trashImage, for: .normal)
        deleteButton.tintColor = .systemRed
        
        minusButton.addTarget(self, action: #selector(didTapMinus), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(didTapPlus), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(didTapDelete), for: .touchUpInside)
        
        // MARK: - Setup Stack Views
        mainStackView.axis = .horizontal
        mainStackView.alignment = .center
        mainStackView.spacing = 12
        
        contentView.addSubview(mainStackView)
        
        
        infoStackView.axis = .vertical
        infoStackView.alignment = .leading
        infoStackView.spacing = 4
        
        mainStackView.addArrangedSubview(productImageView)
        mainStackView.addArrangedSubview(infoStackView)
        mainStackView.addArrangedSubview(deleteButton)
        
        infoStackView.addArrangedSubview(titleLabel)
        infoStackView.addArrangedSubview(priceLabel)
        infoStackView.addArrangedSubview(quantityContainer)
        
        
        mainStackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
        
        productImageView.snp.makeConstraints { make in
            make.width.height.equalTo(70)
        }
        
        quantityContainer.addSubview(minusButton)
        quantityContainer.addSubview(quantityLabel)
        quantityContainer.addSubview(plusButton)
        
        minusButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(30)
        }
        
        quantityLabel.snp.makeConstraints { make in
            make.leading.equalTo(minusButton.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
            make.width.equalTo(30)
        }
        
        plusButton.snp.makeConstraints { make in
            make.leading.equalTo(quantityLabel.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(30)
            make.trailing.equalToSuperview().offset(-8)
        }
        
        quantityContainer.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
    }
    
    // MARK: - Configuration
    func configure(with item: CartItem) {
        titleLabel.text = item.product.title
        priceLabel.text = "\(item.product.price) $"
        
        currentQuantity = item.quantity
        quantityLabel.text = "\(currentQuantity)"
        
        if let imageUrl = item.product.images.first {
            ImageLoader().loadImage(from: imageUrl) { [weak self] image in
                DispatchQueue.main.async {
                    self?.productImageView.image = image ?? UIImage(named: "placeholder")
                }
            }
        } else {
            productImageView.image = UIImage(named: "placeholder")
        }
    }
    
    // MARK: - Actions
    @objc func didTapMinus() {
        if currentQuantity > 1 {
            currentQuantity -= 1
            quantityLabel.text = "\(currentQuantity)"
            onQuantityChange?(currentQuantity)
        }
    }
    
    @objc func didTapPlus() {
        currentQuantity += 1
        quantityLabel.text = "\(currentQuantity)"
        onQuantityChange?(currentQuantity)
    }
    
    @objc func didTapDelete() {
        onDelete?()
    }
}
