import SwiftUI

@main
struct BankingApp: App {
    @StateObject var transactionListVM = TransactionListViewModel(transactionService: TransactionService())
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(transactionListVM)
        }
    }
}
