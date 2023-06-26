//
//  AddPaymentView.swift
//  CommonWallet
//

import SwiftUI

struct AddTransactionView: View {

    @ObservedObject var addTransactionViewModel: AddTransactionViewModel
    @ObservedObject var commonWalletViewModel: CommonWalletViewModel
    @Binding var isAddTransactionView: Bool

    @State private var selectedIndex = 0
    @State var title: String = ""
    @State var description: String = ""
    @State var amount: Int?

    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

    @AppStorage(UserDefaultsKey().userId) private var myUserId = String()
    @AppStorage(UserDefaultsKey().partnerUserId) private var partnerUserId = String()
    
    var body: some View {

        NavigationView {
            ScrollView {
                VStack(spacing: 0) {

                    VStack(alignment: .leading, spacing: 3) {
                        Text("立て替え者")
                        Picker("", selection: self.$selectedIndex) {
                            Text(addTransactionViewModel.myName)
                                .tag(0)
                            Text(addTransactionViewModel.partnerName)
                                .tag(1)
                        }
                        .padding(.horizontal)
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    .padding()


                    VStack(alignment: .leading, spacing: 3) {
                        Text("タイトル")
                        TextField("駅前の薬局", text: $title)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                    }
                    .padding()

                    VStack(alignment: .leading, spacing: 3) {
                        Text("詳細")
                        ZStack(alignment: .topLeading) {
                            TextEditor(text: $description)
                                .frame(height: 100)
                                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color(uiColor: .systemGray5), lineWidth: 1))
                            if description.isEmpty {
                                Text("帰宅時にあわてて購入した洗剤")
                                    .foregroundColor(Color(uiColor: .placeholderText))
                                    .allowsHitTesting(false)
                                    .padding(5)
                            }
                        }.padding(.horizontal)
                    }
                    .padding()

                    VStack(alignment: .leading, spacing: 3) {
                        Text("金額")
                        TextField("480円", value: $amount, format: .number)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                    }
                    .padding()

                    Button ( action: {
                        addTransaction(
                            creditorId: selectedIndex == 0 ? addTransactionViewModel.myUserId : addTransactionViewModel.partnerUserId,
                            debtorId: selectedIndex == 0 ? addTransactionViewModel.partnerUserId : addTransactionViewModel.myUserId,
                            title: title,
                            description: description,
                            amount: amount ?? 0)
                    }) {
                        HStack {
                            Text("登録")
                        }
                        .frame(width: 100.0, height: 25.0)
                        .padding(10)
                        .accentColor(Color.black)
                        .background(Color.white)
                        .cornerRadius(25)
                        .shadow(color: Color.gray, radius: 3, x: 0, y: 0)
                    }

                }
                .padding()

                .alert(isPresented: $showAlert, content: {
                    Alert(title: Text("Transaction Result"),
                          message: Text(alertMessage),
                          dismissButton: .default(Text("OK")))
                })
                .navigationTitle("追加")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    /// ナビゲーションバー左
                    ToolbarItem(placement: .navigationBarLeading){
                        Button(action: {isAddTransactionView = false}) {
                            Text("キャンセル")
                        }
                    }
                }
            } // ScrollViewここまで
        } // NavigationViewここまで

    }

    func addTransaction(creditorId: String?, debtorId: String?, title: String, description: String, amount: Int) {
        Task{

            let result = try await addTransactionViewModel.addTransaction(creditorId: creditorId, debtorId: debtorId, title: title, description: description, amount: amount)

            switch result {
            case .success:
                // 成功した場合の処理
                print("Transactionの登録成功")
                //self.fetchTransactions()
                self.alertMessage = "Transaction succeeded!"
                self.isAddTransactionView = false
                self.showAlert = true
                break
            case .failure(let error):
                // 失敗した場合の処理
                print("Transactionの登録失敗")
                self.alertMessage = "Transaction failed with error: \(error.localizedDescription)"
                self.showAlert = true
                break
            }
        }
    }

    /// 遷移元のViewのTransaction情報を更新するために、遷移元のviewModelを操作
    private func fetchTransactions() {
        Task{
            try await commonWalletViewModel.realtimeFetchTransactions(myUserId: myUserId, partnerUserId: partnerUserId)
        }
    }

}

//struct AddPaymentView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddPaymentView(isAddPaymentView: Binding<true>)
//    }
//}
