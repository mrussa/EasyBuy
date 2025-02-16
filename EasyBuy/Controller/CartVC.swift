//
//  CartVC.swift
//  EasyBuy
//
//  Created by mruss on 2/15/25.
//


import UIKit
import SnapKit

// MARK: - CartVC
class CartVC: UIViewController {
    
    // MARK: - UI Elements
    private var tableView: UITableView!
    
    // MARK: - Properties
    private var cartItems: [CartItem] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Shopping List"
        view.backgroundColor = .systemBackground
        
        setupNavigationBar()
        setupTableView()
        
        loadCartItems()
        
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCartItems()
    }
    // MARK: - Setup Functions
    private func setupNavigationBar() {
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action,
                                          target: self,
                                          action: #selector(shareCart))
        
        let clearButton = UIBarButtonItem(title: "Clear",
                                          style: .plain,
                                          target: self,
                                          action: #selector(clearCart))
        
        navigationItem.rightBarButtonItems = [shareButton, clearButton]
    }
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.register(CartItemCell.self, forCellReuseIdentifier: "CartItemCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Data Loading
    private func loadCartItems() {
        cartItems = CartManager.shared.items
        tableView.reloadData()
    }
    
    // MARK: - Actions
    @objc private func shareCart() {
        if cartItems.isEmpty {
            let alert = UIAlertController(title: "Cart is empty",
                                          message: "No items to share",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        var shareText = "Shopping List:\n"
        for item in cartItems {
            shareText += "• \(item.product.title) — \(item.quantity) pcs at \(item.product.price)$\n"
        }
        
        let activityVC = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        present(activityVC, animated: true)
    }
    
    @objc private func clearCart() {
        let alert = UIAlertController(title: "Clear cart?",
                                      message: "All items will be removed",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Clear", style: .destructive, handler: { _ in
            CartManager.shared.clear()
            self.loadCartItems()
        }))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension CartVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartItemCell", for: indexPath) as! CartItemCell
        let item = cartItems[indexPath.row]
        cell.configure(with: item)
        
        cell.onQuantityChange = { [weak self] newQuantity in
            CartManager.shared.updateQuantity(for: item.product, quantity: newQuantity)
            self?.loadCartItems()
        }
        cell.onDelete = { [weak self] in
            CartManager.shared.remove(product: item.product)
            self?.loadCartItems()
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CartVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = cartItems[indexPath.row]
        let detailVC = ProductDetailVC(product: item.product)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
