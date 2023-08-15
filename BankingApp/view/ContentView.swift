import SwiftUI

struct ContentView: View {
    //@EnvironmentObject var transactionListVM: TransactionListViewModel
    var body: some View {
        VStack {
            NavigationView {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        Text("Overview")
                            .font(.title2)
                            .bold()
                        RecentTransactionList()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                }
                .background(Color.background)
                .navigationBarTitleDisplayMode(.inline)
            }
            .navigationViewStyle(.stack)
            .accentColor(.primary)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static let transactionListVM: TransactionListViewModel = {
        let transactionListVM = TransactionListViewModel(transactionService: TransactionService())
        transactionListVM.transactions = transactionListPreviewData
        return transactionListVM
    }()
    static var previews: some View {
        Group {
            ContentView()
            ContentView()
                .preferredColorScheme(.dark)
        }
        .environmentObject(transactionListVM)
        
    }
}