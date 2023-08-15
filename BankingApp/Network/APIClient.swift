import Combine

protocol APIClient {
    func getTransactions() -> AnyPublisher<[Transaction], Error>
}

class MockAPIClient: APIClient {
    func getTransactions() -> AnyPublisher<[Transaction], Error> {
        // Simulate API response with mock data
        let transactions: [Transaction] = [
            Transaction(id: 1, date: "08/14/2023", merchant: "Food", amount: 50.0, type: "debit"),
            Transaction(id: 2, date: "08/1/2023", merchant: "Payroll", amount: 2550.0, type: "credit"),
            Transaction(id: 3, date: "07/8/2023", merchant: "Travel", amount: 150.0, type: "debit"),
            Transaction(id: 4, date: "07/8/2023", merchant: "Travel", amount: 350.0, type: "credit")
        ]
        return Just(transactions)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
