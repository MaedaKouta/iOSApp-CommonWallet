//
//  LogListsView.swift
//  CommonWallet
//

import SwiftUI
import PKHUD

struct LogListView: View {

    @ObservedObject var viewModel: LogListsViewModel
    @EnvironmentObject var transactionData: TransactionData
    // 選択されてる月のインデックス
    var itemIndex: Int
    // アラート
    @State var isCancelResolvedAlert: Bool = false
    @State var isDeleteTransactionAlert: Bool = false
    @State var isTransactionDescriptionAlert: Bool = false
    // PKHUD
    @State private var isPKHUDProgress = false
    @State private var isPKHUDSuccess = false
    @State private var isPKHUDError = false
    // セルの選択
    @State var selectedTransactionIndex = 0
    @State var selectedCancelTransactionIndex = 0
    @State var selectedDeleteTransactionIndex = 0
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
                if transactionData.resolvedTransactionsByMonth[itemIndex].count == 0 {
                    unResolvedListIsNullView()
                } else {
                    resolvedListView()
                }
            }
            .listStyle(PlainListStyle())
        }
        .PKHUD(isPresented: $isPKHUDProgress, HUDContent: .progress, delay: .infinity)
        .PKHUD(isPresented: $isPKHUDSuccess, HUDContent: .success, delay: 0.7)
        .PKHUD(isPresented: $isPKHUDError, HUDContent: .labeledError(title: nil, subtitle: "エラー"), delay: 0.7)
        .onAppear {
            HUD.hide()
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
        ForEach((0 ..< transactionData.resolvedTransactionsByMonth[itemIndex].count).reversed(),  id: \.self) { index in

            HStack {
                // もし自分が立替者だったら、自分のアイコンを表示
                if transactionData.resolvedTransactionsByMonth[itemIndex][index].creditorId == myUserId {
                    Image(uiImage: UIImage(data: myIconData) ?? UIImage(named: imageNameProperty.iconNotFound)!)
                        .resizable()
                        .scaledToFill()
                        .overlay(RoundedRectangle(cornerRadius: 56).stroke(Color.gray, lineWidth: 1))
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 28, height: 28, alignment: .center)
                        .clipShape(Circle())
                // もしパートナーが立替者だったら、パートナーのアイコンを表示
                } else {
                    Image(uiImage: UIImage(data: partnerIconData) ?? UIImage(named: imageNameProperty.iconNotFound)!)
                        .resizable()
                        .scaledToFill()
                        .overlay(RoundedRectangle(cornerRadius: 56).stroke(Color.gray, lineWidth: 1))
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 28, height: 28, alignment: .center)
                        .clipShape(Circle())
                }

                VStack(alignment: .leading) {
                    Text(self.dateToString(date: transactionData.resolvedTransactionsByMonth[itemIndex][index].createdAt))
                        .font(.caption)
                        .foregroundColor(Color.gray)
                    Text(transactionData.resolvedTransactionsByMonth[itemIndex][index].title)
                }

                Spacer()

                VStack(alignment: .trailing) {
                    Text("¥\(transactionData.resolvedTransactionsByMonth[itemIndex][index].amount)")
                }
            }
            .onTapGesture {
                self.selectedTransactionIndex = index
                self.isTransactionDescriptionAlert = true
            }
            .contextMenu {
                Button() {
                    self.selectedCancelTransactionIndex = index
                    self.isCancelResolvedAlert = true
                } label: {
                    Label("未清算に戻す", systemImage: imageNameProperty.arrowUturnBackwardCircleSystemImage)
                }

                Button() {
                    self.selectedDeleteTransactionIndex = index
                    self.isDeleteTransactionAlert = true
                } label: {
                    Label("削除", systemImage: imageNameProperty.trashFillSystemImage)
                }
            }
            .alert("注意", isPresented: $isDeleteTransactionAlert){
                Button("キャンセル") {
                }
                Button("OK") {
                    self.deleteTransaction(transactionId: transactionData.resolvedTransactionsByMonth[itemIndex][self.selectedDeleteTransactionIndex].id)
                }
            } message: {
                Text("「\(transactionData.resolvedTransactionsByMonth[itemIndex][self.selectedDeleteTransactionIndex].title)」を本当に削除してもよろしいですか？")
            } // alertここまで
            .alert("戻す", isPresented: $isCancelResolvedAlert){
                Button("キャンセル") {
                }
                Button("OK") {
                    self.cancelResolvedTransaction(transactionId: transactionData.resolvedTransactionsByMonth[itemIndex][self.selectedCancelTransactionIndex].id)
                }
            } message: {
                Text("「\(transactionData.resolvedTransactionsByMonth[itemIndex][self.selectedCancelTransactionIndex].title)」を未清算に戻してもよろしいですか？")
            } // alertここまで
            .padding(3)
            .foregroundColor(.black)
            .contentShape(Rectangle())
            .onTapGesture {
                print(index)
            }
        }
    }

    /**
     指定したトランザクションの削除
     - parameter transactionId: 削除するトランザクションのID
     */
    private func deleteTransaction(transactionId: String) {
        Task{
            do {
                isPKHUDProgress = true
                // ここでindexを0にしないと、out of range になる
                self.selectedDeleteTransactionIndex = 0
                self.selectedTransactionIndex = 0
                try await viewModel.deleteTransaction(transactionId: transactionId)
                isPKHUDProgress = false
                isPKHUDSuccess = true
            } catch {
                print("transactionの削除に失敗：", error)
                isPKHUDProgress = false
                isPKHUDError = true
            }
        }
    }

    /**
     指定したトランザクションの精算を未清算に戻す
     - parameter transactionId: 未清算に戻すトランザクションのID
     */
    private func cancelResolvedTransaction(transactionId: String) {
        Task{
            do {
                isPKHUDProgress = true
                // ここでindexを0にしないと、out of range になる
                self.selectedCancelTransactionIndex = 0
                self.selectedTransactionIndex = 0
                try await viewModel.updateCancelResolvedAt(transactionId: transactionId)
                isPKHUDProgress = false
                isPKHUDSuccess = true
            } catch {
                print("transactionの精算を未清算に戻すことに失敗：", error)
                isPKHUDProgress = false
                isPKHUDError = true
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
