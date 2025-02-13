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

class SearchVC: UIViewController, UISearchResultsUpdating {

    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Product>?
    
    var allProducts: [Product] = []
    var filteredProducts: [Product] = []
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text, !query.isEmpty else {
            filteredProducts = allProducts
            updateSnapshot()
            return
        }
        
        filteredProducts = allProducts.filter { $0.title.localizedCaseInsensitiveContains(query) }
        updateSnapshot()
    }

    func loadProduct() {
        let apiClient = APIClient()
        
        Task {
            do {
                allProducts = try await apiClient.getProductList()
                allProducts.sort { $0.id > $1.id }
                filteredProducts = allProducts
                updateSnapshot()
            } catch {
                print("❌ Ошибка загрузки данных")
            }
        }
    }
    
    func saveSearchQuery(_ query: String) {
        var searches = UserDefaults.standard.stringArray(forKey: "recentSearches") ?? []
        if !searches.contains(query) {
            searches.insert(query, at: 0)
        }
        if searches.count > 10 { searches.removeLast() }
        UserDefaults.standard.set(searches, forKey: "recentSearches")
    }

    func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Product>()
        snapshot.appendSections([.main])

        let validProducts = filteredProducts.filter { product in
            let validImages = product.images
                .map { $0.trimmingCharacters(in: CharacterSet(charactersIn: "[\"]")) }
                .filter { !$0.contains("placeimg.com") && !$0.isEmpty }
            
            return !validImages.isEmpty
        }
        
        snapshot.appendItems(validProducts, toSection: .main)

        Task { await dataSource?.apply(snapshot, animatingDifferences: true) }
    }

    @objc func openFilters() {
        let filtersVC = FiltersVC()
        let navVC = UINavigationController(rootViewController: filtersVC)
        navVC.modalPresentationStyle = .automatic
        present(navVC, animated: true)
    }

    @objc func openCart() {
        print(" Открыть корзину")
    }

    override var prefersStatusBarHidden: Bool {
        return false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground

        
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 5
        let width = (UIScreen.main.bounds.width - 3 * spacing) / 2
        layout.itemSize = CGSize(width: width, height: 280)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.hidesNavigationBarDuringPresentation = false
        search.searchBar.placeholder = "Search"
        search.searchBar.backgroundColor = .systemBackground
        search.searchBar.barTintColor = .systemBackground
        search.searchBar.isTranslucent = true
        navigationItem.searchController = search
            
        let filterButton = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .plain, target: self, action: #selector(openFilters))
        let shoppingListButton = UIBarButtonItem(image: UIImage(systemName: "cart"), style: .plain, target: self, action: #selector(openCart))
        navigationItem.rightBarButtonItems = [shoppingListButton, filterButton]

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
            
            let validImages = product.images
                .map { $0.trimmingCharacters(in: CharacterSet(charactersIn: "[\"]")) }
                .filter { !$0.contains("placeimg.com") }

            let imageUrl = validImages.first ?? ""

            if imageUrl.isEmpty {
                print("⚠️ Нет доступных изображений для продукта: \(product.title)")
            } else {
                print("🔄 Загружаю: \(imageUrl)")
            }

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as! ProductCell
            cell.configure(with: imageUrl, title: product.title, price: "\(product.price) $")
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
