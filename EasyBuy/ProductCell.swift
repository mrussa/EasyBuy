//
//  ProductCell.swift
//  EasyBuy
//
//  Created by mruss on 2/12/25.
//

import UIKit
import SnapKit

class ProductCell: UICollectionViewCell {
    static let identifier = "ProductCell"
    
    let productImageView = UIImageView()
    let titleLabel = UILabel()
    let priceLabel = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        productImageView.contentMode = .scaleAspectFill
        productImageView.clipsToBounds = true
        contentView.addSubview(productImageView)
        
        titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.textAlignment = .left
        contentView.addSubview(titleLabel)
        
        priceLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        priceLabel.textAlignment = .left
        contentView.addSubview(priceLabel)
        
        productImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.75)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(productImageView.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(6)
            make.height.equalTo(35)
        }

        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(4) 
            make.bottom.equalToSuperview().offset(-4)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with imageURL: String, title: String, price: String) {
        
                
        titleLabel.text = title
        priceLabel.text = price
        
        let loader = ImageLoader()
        loader.loadImage(from: imageURL) { image in
            DispatchQueue.main.async {
                self.productImageView.image = image
            }
        }

    }
}
