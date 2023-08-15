import Combine

protocol APIClient {
    func getTransactions() -> AnyPublisher<[Transaction], Error>
}
