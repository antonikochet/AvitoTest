//
//  NetworkService.swift
//  AvitoTest
//
//  Created by Антон Кочетков on 06.12.2021.
//

import Foundation

class NetworkService {
    static func fetchData(completion: @escaping (Result<ParseModel, Error>) -> Void) {
        
        guard let url = URL(string: "https://run.mocky.io/v3/1d1cb4ec-73db-4762-8c4b-0b8aa3cecd4c") else { return }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            if let data = data,
               let parseModel = try? JSONDecoder().decode(ParseModel.self, from: data) {
                completion(.success(parseModel))
            }
        }
        
        task.resume()
    }
}
