import Foundation
import Combine


class TransactionService: APIClient {
    func getTransactions() -> AnyPublisher<[Transaction], Error> {
        let urlString = "https://mocki.io"
        //"https://mocki.io/v1/b956988d-c524-404e-818e-b91ed1c54563"
        
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
