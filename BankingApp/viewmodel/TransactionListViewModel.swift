import Foundation
import Combine
import Collections

typealias TransactionGroup = OrderedDictionary<String, [Transaction]>

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
    
    func groupTransactionsByMonth() -> TransactionGroup {
        guard !transactions.isEmpty else { return [:] }
        
        let groupedTransactions = TransactionGroup(grouping: transactions) { $0.month }
        
        //print(groupedTransactions)
        
        return groupedTransactions
    }
    
    func calculateCumulativeBalance(transaction: [Transaction]) -> Double {
        
        guard !transaction.isEmpty else { return 0.0 }
        
        return transaction.reduce(0.0) {$0 + $1.signedAmount}
    }
}
