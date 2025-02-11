//
//  SearchVC.swift
//  EasyBuy
//
//  Created by mruss on 2/10/25.
//

import UIKit

class SearchVC: UIViewController {
    
    var products: [Product] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let apiClient = APIClient()
                
        Task {
            do {
                products = try await apiClient.getProductList()
                print(products)
            } catch {
                print("Error")
            }
        }
    }

}
