//
//  LogListsView.swift
//  CommonWallet
//

import SwiftUI

struct LogListView: View {

    @ObservedObject var viewModel: LogListsViewModel
    // 選択されてる月のインデックス
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
                if viewModel.resolvedTransactionsByMonth[itemIndex].count == 0 {
                    unResolvedListIsNullView()
                } else {
                    resolvedListView()
                }
            }
            .listStyle(PlainListStyle())
            .onAppear {
                Task {
                    await viewModel.fetchTransactions()
                }
            }
        }
    }

    // MARK: - Views
    /**
     リストが空の際に表示する画像と文言
     */
    private func unResolvedListIsNullView() -> some View {
        VStack {
            Image(imageNameProperty.sittingCatDark)
                .resizable()
                .scaledToFill()
                .aspectRatio(contentMode: .fit)
                .padding(.top)
                .transition(.opacity)

            Text("リストが空です")
                .foregroundColor(.gray)
        }
        .listRowSeparator(.hidden)
        .padding(.top, 100)
    }

    /**
     精算リストのView
     */
    private func resolvedListView() -> some View {
        ForEach((0 ..< viewModel.resolvedTransactionsByMonth[itemIndex].count).reversed(),  id: \.self) { index in

            HStack {
                if viewModel.resolvedTransactionsByMonth[itemIndex][index].debtorId != myUserId {
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
                    Text(self.dateToString(date: viewModel.resolvedTransactionsByMonth[itemIndex][index].createdAt))
                        .font(.caption)
                        .foregroundColor(Color.gray)
                    Text(viewModel.resolvedTransactionsByMonth[itemIndex][index].title)
                }

                Spacer()

                VStack(alignment: .trailing) {
                    Text("¥\(viewModel.resolvedTransactionsByMonth[itemIndex][index].amount)")
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

    // MARK: - Logics
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
//        LogListView(viewModel: <#T##AllLogViewModel#>, itemIndex: <#T##Int#>)
//    }
//}
