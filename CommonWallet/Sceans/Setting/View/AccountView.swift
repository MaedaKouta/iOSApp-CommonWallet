//
//  AccountView.swift
//  CommonWallet
//

import SwiftUI

struct AccountView: View {

    @StateObject var viewModel: AccountViewModel

    @AppStorage(UserDefaultsKey().userName) private var userName = String()
    @AppStorage(UserDefaultsKey().myIconData) private var myIconData = Data()

    @State private var imageNameProperty = ImageNameProperty()
    @State private var selectedAccountImage: UIImage?

    // Alert
    @State private var isAccountDeleteAlert = false
    @State private var isAccountImageDialog = false
    // ImagePicker
    @State private var isImagePickerFromLibrary = false
    @State private var isImagePickerFromCamera = false
    // PKHUD
    @State private var isPKHUDProgress = false
    @State private var isPKHUDSuccess = false
    @State private var isPKHUDError = false

    // TODO: あとで削除
    let authManager = AuthManager()

    var body: some View {
        List {
            myIconSection()
            myUserNameSection()
            accountResetSection()
        }
        .scrollContentBackground(.visible)
        .navigationTitle("アカウント")
        .PKHUD(isPresented: $isPKHUDProgress, HUDContent: .progress, delay: .infinity)
        .PKHUD(isPresented: $isPKHUDSuccess, HUDContent: .success, delay: 1.0)
        .PKHUD(isPresented: $isPKHUDError, HUDContent: .error, delay: 1.0)
        .sheet(isPresented: $isImagePickerFromLibrary) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $selectedAccountImage)
        }
        .sheet(isPresented: $isImagePickerFromCamera) {
            ImagePicker(sourceType: .camera, selectedImage: $selectedAccountImage)
        }
        .confirmationDialog("", isPresented: $isAccountImageDialog, titleVisibility: .hidden) {
            Button("写真を撮る") {
                isImagePickerFromCamera = true
            }
            Button("写真を選択") {
                isImagePickerFromLibrary = true
            }
        }
        .onChange(of: selectedAccountImage) { _ in
            Task {
                await self.uploadIconImage()
            }
        }
        .alert("リセット", isPresented: $isAccountDeleteAlert){
            Button("リセット", role: .destructive){
                Task {
                    do {
                        try await authManager.deleteUser()
                    } catch {
                        print("アカウント削除", error)
                    }
                }
            }
        } message: {
            Text("アカウントをリセットしますか？全てのデータが削除され、復元できません。")
        }
    }

    // MARK: - Section

    /**
     アイコンを表示するView, タップでアイコン変更
     - Returns: View(Section)
     */
    private func myIconSection() -> some View {
        Section {
            HStack {
                Spacer()
                Button(action: {
                    isAccountImageDialog = true
                }, label: {
                    Image(uiImage: UIImage(data: myIconData) ?? UIImage(named: imageNameProperty.iconNotFound)!)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .cornerRadius(75)
                        .overlay(RoundedRectangle(cornerRadius: 75).stroke(Color.gray, lineWidth: 1))
                        .animation(.default)
                })
                Spacer()
            }
            .listRowBackground(Color.clear)
        }
        .listRowSeparator(.hidden)
        .buttonStyle(BorderlessButtonStyle())
    }

    /**
     MyUserNameを表示するView, タップでMyUserName変更
     - Returns: View(Section)
     */
    private func myUserNameSection() -> some View {
        Section {
            HStack {
                Text("ユーザー名")

                NavigationLink(destination: {
                    MyNameEditView(viewModel: MyNameEditViewModel())
                }, label: {
                    Text(userName)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                })
            }
        }
    }

    /**
     アカウントリセットするView, タップでカウントリセットアラート表示
     - Returns: View(Section)
     */
    private func accountResetSection() -> some View {
        Section {
            Button(action: {
                isAccountDeleteAlert = true
            }) {
                Text("アカウントリセット")
                    .foregroundColor(.red)
            }
        } footer: {
            Text("全データが削除され、現在の共有番号も無効化されます。")
        }
    }


    // MARK: - Logic

    /**
     アイコンをアップロードする非同期処理.
     処理中はインジケータを出し, 結果によって成功/失敗PKHUDを表示
     - Returns: View(Section)
     */
    private func uploadIconImage() async {
        guard let accountImage = self.selectedAccountImage else {
            isPKHUDError = true
            return
        }
        isPKHUDProgress = true
        viewModel.uploadIconImage(image: accountImage, completion: { isSuccess, error in
            if isSuccess {
                self.isPKHUDProgress = false
                isPKHUDSuccess = true
            } else {
                self.isPKHUDProgress = false
                isPKHUDError = true
            }
        })
    }

}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(viewModel: AccountViewModel(userDefaultsManager: UserDefaultsManager(), storageManager: StorageManager()))
    }
}
