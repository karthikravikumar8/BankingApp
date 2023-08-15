import Foundation
import Combine


class TransactionService: APIClient {
    func getTransactions() -> AnyPublisher<[Transaction], Error> {
        let urlString = "https://mocki.io/v1/4fba0c16-a2b8-4b56-8c1f-cda2a0840a96"
        
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
