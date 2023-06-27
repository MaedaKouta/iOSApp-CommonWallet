//
//  LogListsView.swift
//  CommonWallet
//

import SwiftUI

struct LogListView: View {

    @ObservedObject var allLogViewModel: AllLogViewModel
    var itemIndex: Int
    // UserDefaults
    @AppStorage(UserDefaultsKey().userId) private var myUserId = String()
    @AppStorage(UserDefaultsKey().userName) private var myUserName = String()
    @AppStorage(UserDefaultsKey().myIconData) private var myIconData = Data()
    @AppStorage(UserDefaultsKey().partnerIconData) private var partnerIconData = Data()
    // 画像のSystemImage
    private let imageNameProperty = ImageNameProperty()

    var body: some View {
        VStack {
            List {
                if allLogViewModel.resolvedTransactionsByMonth[itemIndex].count == 0 {
                    VStack {
                        Image("Sample2")
                            .resizable()
                            .scaledToFill()
                            .aspectRatio(contentMode: .fit)
                            .padding(.top)
                        Text("リストが空です")
                            .foregroundColor(.gray)
                    }
                    .listRowSeparator(.hidden)
                    .padding(.top, 100)
                } else {

                    ForEach((0 ..< allLogViewModel.resolvedTransactionsByMonth[itemIndex].count).reversed(),  id: \.self) { index in

                        HStack {
                            if allLogViewModel.resolvedTransactionsByMonth[itemIndex][index].debtorId != myUserId {
                                Image(uiImage: UIImage(data: myIconData) ?? UIImage(named: imageNameProperty.iconNotFound)!)
                                    .resizable()
                                    .scaledToFill()
                                    .overlay(RoundedRectangle(cornerRadius: 56).stroke(Color.gray, lineWidth: 1))
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 28, height: 28, alignment: .center)
                                    .clipShape(Circle())
                            } else {
                                Image(uiImage: UIImage(data: partnerIconData) ?? UIImage(named: imageNameProperty.iconNotFound)!)                                    .resizable()
                                    .scaledToFill()
                                    .overlay(RoundedRectangle(cornerRadius: 56).stroke(Color.gray, lineWidth: 1))
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 28, height: 28, alignment: .center)
                                    .clipShape(Circle())
                            }

                            VStack(alignment: .leading) {
                                Text(self.dateToString(date: allLogViewModel.resolvedTransactionsByMonth[itemIndex][index].createdAt))
                                    .font(.caption)
                                    .foregroundColor(Color.gray)
                                Text(allLogViewModel.resolvedTransactionsByMonth[itemIndex][index].title)
                            }

                            Spacer()

                            VStack(alignment: .trailing) {
                                Text("¥\(allLogViewModel.resolvedTransactionsByMonth[itemIndex][index].amount)")
                            }
                        }
                        .contextMenu
                        {
                            Button(action: {print("削除")}) {
                                Label("削除", systemImage: "trash")
                            }
                        }
                        .padding(3)
                        .foregroundColor(.black)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            print(index)
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
            .onAppear {
                Task {
                    try await allLogViewModel.fetchTransactions()
                }
            }
        }
    }

    private func dateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "yyyy/MM/dd"

        return dateFormatter.string(from: date)
    }

    private func dateToDetailString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"

        return dateFormatter.string(from: date)
    }
}


//struct LogListsView_Previews: PreviewProvider {
//    static var previews: some View {
//        LogListView(allLogViewModel: <#T##AllLogViewModel#>, itemIndex: <#T##Int#>)
//    }
//}
