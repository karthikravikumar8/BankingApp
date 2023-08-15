import Foundation
import Combine


class TransactionService: APIClient {
    func getTransactions() -> AnyPublisher<[Transaction], Error> {
        let urlString = "https://mocki.io/v1/6fc4231d-7c77-4ac6-aac0-480cd8c1c5de"
        
        let url = URL(string: urlString)!
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { (data, response) -> Data in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    dump(response)
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: [Transaction].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
