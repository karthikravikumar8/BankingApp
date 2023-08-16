import SwiftUI
import SwiftUICharts

struct ContentView: View {
    @EnvironmentObject var transactionListVM: TransactionListViewModel
    var body: some View {
        VStack {
            NavigationView {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        let balance = transactionListVM.calculateCumulativeBalance()
                        let data = transactionListVM.accumulateTransactions()
                        Text("Overview")
                            .font(.title2)
                            .bold()
                        HStack {
                            Text("Balance")
                                .font(.title2)
                                .bold()
                            
                            Spacer()
                            
                            Text("\(balance, specifier: "%.2f €")")
                                .font(.title2)
                                .bold()
                        }

                       // Mark: Title
                       Text("Monthly Balance")
                           .font(.title2)
                           .bold()
                                               
                       if !data.isEmpty {
                           let totalExpenses = data.last?.1 ?? 0
                           
                           CardView {
                               VStack(alignment: .leading) {
                                   ChartLabel(totalExpenses.formatted(.currency(code: "EUR")), type: .title, format: "%.02f €")
                                   BarChart()
                               }
                               .background(Color.systemBackground)
                           }
                           .data(data)
                           .chartStyle(ChartStyle(backgroundColor: Color.systemBackground, foregroundColor: ColorGradient(Color.icon.opacity(0.4), Color.icon)))
                           .frame(height: 300)
                       }
                       
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
