# BankingApp

# Requirements:
1. Deployment Targer 16.2
2. Xcode 14.2
3. Used iPhone 14 Pro simulator for development

# Dependencies:
1. swift-collections 1.0.4
2. SwiftUICharts 2.0.0-beta.2

# Assignment:

1. Customer wants to see their monthly balance and cumulative balance
2. There is an API that is developed by another team. The API provides bank transactions which include amount transferred and date
3. Things to consider
* In this task there is no need to develop the API developed by another team
* How to design your application so that it is testable?
* If the application must be deployed to a server in remote location, how would you do it?

# Activities Completed:

1. Used SwiftUI for all the layouts
2. Used Combine framework for fetching transaction list from webservice.
3. Fetched transactions from json file located in local in case of webservice failures.
4. Displayed monthly, cumulative balance and recent transactions
5. Credits and debits were highlighted with different signs (positive and negative) and colors.
6. Created BarChart to display monthly and daily balance
7. Followed MVVM design pattern
8. Created unit tests for the view model
9. **See All** navigates to Transactions screen which lists month wise transaction with month wise balance

Screens:
![Screen1](https://github.com/karthikravikumar8/BankingApp/assets/65198640/5a4cb12b-a501-40db-88a2-9b09facc3452)
![Screen2](https://github.com/karthikravikumar8/BankingApp/assets/65198640/511fe773-eb76-4df5-86c0-1b94362d401c)
![Screen3](https://github.com/karthikravikumar8/BankingApp/assets/65198640/659b06fb-3390-45e6-9376-3ae2acec0bf9)

