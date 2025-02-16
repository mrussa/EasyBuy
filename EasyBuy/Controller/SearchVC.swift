//
//  SearchVC.swift
//  EasyBuy
//
//  Created by mruss on 2/10/25.
//

import UIKit
import SnapKit

// MARK: - Section Enum
enum Section {
    case main
}

// MARK: - SearchVC
class SearchVC: UIViewController, UISearchResultsUpdating {

    // MARK: - Properties
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Product>?

    var allProducts: [Product] = []
    var filteredProducts: [Product] = []

    var lastSearchText: String = ""
    var lastFilters: (category: String?, priceFrom: String?, priceTo: String?, sort: String?) = (nil, nil, nil, nil)

    var recentSearchesTableView: UITableView!
    var recentSearches: [String] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.hidesNavigationBarDuringPresentation = false
        search.searchBar.placeholder = "Search"
        search.searchBar.backgroundColor = .systemBackground
        search.searchBar.barTintColor = .systemBackground
        search.searchBar.isTranslucent = true
        search.searchBar.delegate = self
        navigationItem.searchController = search

        let filterButton = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(openFilters))
        let shoppingListButton = UIBarButtonItem(image: UIImage(systemName: "cart"),
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(openCart))
        navigationItem.rightBarButtonItems = [shoppingListButton, filterButton]

        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 5
        let width = (UIScreen.main.bounds.width - 3 * spacing) / 2
        layout.itemSize = CGSize(width: width, height: 280)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.identifier)
        collectionView.delegate = self
        view.addSubview(collectionView)

        setupRecentSearchesTableView()
        configureDataSource()
        loadProduct()

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
    }

    
    func setupRecentSearchesTableView() {
        recentSearchesTableView = UITableView()
        recentSearchesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "RecentSearchCell")
        recentSearchesTableView.dataSource = self
        recentSearchesTableView.delegate = self
        recentSearchesTableView.isHidden = true
        view.addSubview(recentSearchesTableView)

        recentSearchesTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(200)
        }
    }

    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text else { return }

        if query.isEmpty {
            recentSearches = loadRecentSearches()
            recentSearchesTableView.reloadData()
            recentSearchesTableView.isHidden = false
            filteredProducts = allProducts
            updateSnapshot()
        } else {
            recentSearchesTableView.isHidden = true
            filteredProducts = allProducts.filter { $0.title.localizedCaseInsensitiveContains(query) }
            updateSnapshot()
        }
    }

    // MARK: - Data Loading
    func loadProduct() {
        let apiClient = APIClient()
        Task {
            do {
                allProducts = try await apiClient.getProductList()
                allProducts.sort { $0.id > $1.id }
                filteredProducts = allProducts
                updateSnapshot()
            } catch {
                print("Ошибка загрузки данных: \(error)")
            }
        }
    }

    func loadRecentSearches() -> [String] {
        return UserDefaults.standard.stringArray(forKey: "recentSearches") ?? []
    }

    func saveSearchQuery(_ query: String) {
        var searches = UserDefaults.standard.stringArray(forKey: "recentSearches") ?? []
        if !searches.contains(query) {
            searches.insert(query, at: 0)
        }
        if searches.count > 5 {
            searches.removeLast()
        }
        UserDefaults.standard.set(searches, forKey: "recentSearches")
    }

    // MARK: - Snapshot Update
    func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Product>()
        snapshot.appendSections([.main])
        snapshot.appendItems(filteredProducts, toSection: .main)

        Task { await dataSource?.apply(snapshot, animatingDifferences: true) }
    }

    // MARK: - Actions
    @objc func openCart() {
        let cartVC = CartVC()
        navigationController?.pushViewController(cartVC, animated: true)
    }

    @objc func openFilters() {
        let filtersVC = FiltersVC()
        filtersVC.onApplyFilters = { [weak self] category, priceFrom, priceTo, sort in
            self?.lastFilters = (category, priceFrom, priceTo, sort)
            self?.fetchFilteredProducts(category: category, priceFrom: priceFrom, priceTo: priceTo, sort: sort)
        }
        let navVC = UINavigationController(rootViewController: filtersVC)
        navVC.modalPresentationStyle = .automatic
        present(navVC, animated: true)
    }

    func fetchFilteredProducts(category: String?, priceFrom: String?, priceTo: String?, sort: String?) {
        let apiClient = APIClient()
        Task {
            do {
                let filteredProducts = try await apiClient.getFilteredProducts(category: category, priceFrom: priceFrom, priceTo: priceTo, sort: sort)
                DispatchQueue.main.async {
                    self.filteredProducts = filteredProducts
                    self.updateSnapshot()
                }
            } catch {
                print("Error loading filtered products: \(error)")
            }
        }
    }

    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Product>(collectionView: collectionView) {
            collectionView, indexPath, product in
            let validImages = product.images
                .map { $0.trimmingCharacters(in: CharacterSet(charactersIn: "[\"]")) }
                .filter { !$0.contains("placeimg.com") }

            let imageUrl = validImages.first ?? ""

            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ProductCell.identifier,
                for: indexPath
            ) as! ProductCell
            cell.configure(with: imageUrl, title: product.title, price: "\(product.price) $")
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate
extension SearchVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedProduct = filteredProducts[indexPath.item]
        let detailVC = ProductDetailVC(product: selectedProduct)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension SearchVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSearches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentSearchCell", for: indexPath)
        cell.textLabel?.text = recentSearches[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedQuery = recentSearches[indexPath.row]
        navigationItem.searchController?.searchBar.text = selectedQuery
        filteredProducts = allProducts.filter { $0.title.localizedCaseInsensitiveContains(selectedQuery) }
        updateSnapshot()
        recentSearchesTableView.isHidden = true
    }
}

// MARK: - UISearchBarDelegate
extension SearchVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        saveSearchQuery(text)

        searchBar.resignFirstResponder()
    }
}
