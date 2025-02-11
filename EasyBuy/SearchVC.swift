//
//  SearchVC.swift
//  EasyBuy
//
//  Created by mruss on 2/10/25.
//

import UIKit
import SnapKit


class SearchVC: UIViewController {
    
//    var products: [Product] = []
    
    var collectionView: UICollectionView!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        
//        let apiClient = APIClient()
//                
//        Task {
//            do {
//                products = try await apiClient.getProductList()
//                print(products)
//            } catch {
//                print("Error")
//            }
//        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }


    }
    
    
    
    

}
