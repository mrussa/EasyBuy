//
//  APIClient.swift
//  EasyBuy
//
//  Created by  on 2/11/25.
//

import Foundation

enum NetworkErrors: Error {
    case encodingFailed(innerError: EncodingError)
    case decodingFailed(innerError: DecodingError)
    case invalidStatusCode(statusCode: Int)
    case requestFailed(innerError: URLError)
    case otherError(innerError: Error)
}

class APIClient {
    func getProductList() async throws -> [Product] {
        
        
        let url = URL(string: "https://api.escuelajs.co/api/v1/products")!
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode == 200 else {
            throw NetworkErrors.invalidStatusCode(statusCode: (response as? HTTPURLResponse)?.statusCode ?? -1)
        }
        
        let decoderResponse = try JSONDecoder().decode([Product].self, from: data)
        
    
        
        print("Get \(decoderResponse.count) product")
        
        return decoderResponse
        
    }

}
