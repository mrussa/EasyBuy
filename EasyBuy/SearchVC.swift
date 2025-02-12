//
//  SearchVC.swift
//  EasyBuy
//
//  Created by mruss on 2/10/25.
//

import UIKit
import SnapKit

enum Section {
    case main
}



class SearchVC: UIViewController {
        
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Product>?
    
    
    func loadProduct() {
        var product: [Product] = []
        let apiClient = APIClient()


        Task {
            do {
                product = try await apiClient.getProductList()
                print(product)
                
                var snapshot = NSDiffableDataSourceSnapshot<Section, Product>()
                snapshot.appendSections([.main])
                snapshot.appendItems(product, toSection: .main)
                
//                let first10 = product.prefix(10).map { $0.images }
//                print("🖼 Первые 10 картинок: \(first10)")
                
                await dataSource?.apply(snapshot, animatingDifferences: true)

            } catch {
                print("Error")
            }
        }
        
            
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 5
        let width = (UIScreen.main.bounds.width - 3 * spacing) / 2
        layout.itemSize = CGSize(width: width, height: 280)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.identifier)
        view.addSubview(collectionView)
        
        configureDataSource()
        loadProduct()

        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }


    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Product>(collectionView: collectionView) { collectionView, indexPath, product in
            
            let cleanedURL = product.images.first?
                .replacingOccurrences(of: "[\"", with: "")
                .replacingOccurrences(of: "\"]", with: "")
            
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as! ProductCell
            cell.configure(with: cleanedURL ?? "", title: product.title, price: "\(product.price) $")
            return cell
        }
        
    }

}


//    var products: [Product] = []

//        let apiClient = APIClient()
//
//
//        Task {
//            do {
//                products = try await apiClient.getProductList()
//                print(products)
//            } catch {
//                print("Error")
//            }
//        }


//        let testURL = "https://plus.unsplash.com/premium_photo-1738779001459-3c2efd2f6e88?q=80&w=1770&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
//
//           let imageLoader = ImageLoader()
//           imageLoader.loadImage(from: testURL) { image in
//               if let image = image {
//                   print("✅ Изображение загружено успешно!")
//               } else {
//                   print("❌ Ошибка загрузки изображения!")
//               }
//           }
