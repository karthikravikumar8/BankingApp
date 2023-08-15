import Foundation
import Combine

final class TransactionListViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    private var cancellables = Set<AnyCancellable>()
    
    private let transactionService: APIClient
    
    init(transactionService: APIClient) {
        self.transactionService = transactionService
        getTransactions()
    }
    
    func getTransactions() {
        transactionService.getTransactions().sink { completion in
            switch completion {
            case .failure(let error):
                print("Error fetching transactions:", error.localizedDescription)
            case .finished:
                print("Finished fetching transactions")
            }
        } receiveValue: { [weak self] result in
            self?.transactions = result
            //dump(self?.transactions)
        }
        .store(in: &cancellables)
    }
}
