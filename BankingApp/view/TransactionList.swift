import SwiftUI

struct TransactionList: View {
    @EnvironmentObject var transactionListVM: TransactionListViewModel
    
    var body: some View {
        VStack {
            List {
                ForEach(Array(transactionListVM.groupTransactionsByMonth()), id: \.key) { month, transactions in
                    let monthlyBalance = transactionListVM.calculateMonthlyBalance(transactions: transactions)
                    Section {
                        ForEach(transactions) { transaction in
                            TransactionRow(transation: transaction)
                        }
                    } header: {
                        HStack {
                            Text(month)
                                .font(.title3)
                                .bold()
                            Spacer()
                            Text("\(monthlyBalance, specifier: "%.2f €")")
                                .font(.title3)
                                .bold()
                        }
                    }
                    .listSectionSeparator(.hidden)
                }
            }
            .listStyle(.plain)
        }
        .navigationTitle("Transactions")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct TransactionList_Previews: PreviewProvider {
    static let transactionListVM: TransactionListViewModel = {
        let transactionListVM = TransactionListViewModel(transactionService: TransactionService())
        transactionListVM.transactions = transactionListPreviewData
        return transactionListVM
    }()
    
    static var previews: some View {
        
        Group {
            NavigationView {
                TransactionList()
            }
            NavigationView {
                TransactionList()
            }
        }
        .environmentObject(transactionListVM)
    }
}
