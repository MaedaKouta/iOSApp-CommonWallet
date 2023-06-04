//
//  AccountView.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/01/23.
//

import SwiftUI

struct AccountView: View {

    @StateObject var viewModel: AccountViewModel

    let authManager = AuthManager()
    @State var fireStoreUserManager = FireStoreUserManager()

    @State private var accountImage: UIImage?
    @State var isAccountDeleteAlert = false
    @State var isAccountImageDialog = false
    @State var isImagePickerFromLibrary = false
    @State var isImagePickerFromCamera = false
    @State var isPKHUDProgress = false
    @State var isPKHUDSuccess = false
    @State var isPKHUDError = false

    var body: some View {
        VStack {

            List {

                Section {
                    HStack {
                        Spacer()
                        Button(action: {
                            isAccountImageDialog = true
                        }, label: {
                            Image("SampleIcon")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .cornerRadius(75)
                                .overlay(RoundedRectangle(cornerRadius: 75).stroke(Color.gray, lineWidth: 1))
                        })
                        Spacer()
                    }
                    .listRowBackground(Color.clear)
                }
                .listRowSeparator(.hidden)
                .buttonStyle(BorderlessButtonStyle())

                Section {

                    HStack {
                        Text("ユーザー名")

                        NavigationLink(destination: {
                            // TODO: 今はとりあえずContentView
                            ContentView()
                        }, label: {
                            Text(viewModel.userName)
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        })
                    }

                    HStack {
                        Button(action: {
                            Task {
                                await self.uploadIconImage()
                            }
                        }, label: {
                           Text("aaa")
                        })
                    }

                }

                Section {
                    Button(action: {
                        isAccountDeleteAlert = true
                    }) {
                        Text("アカウントリセット")
                            .foregroundColor(.red)
                    }
                } footer: {
                    Text("登録した全データが削除され、現在の共有番号も無効化されます。")
                }

            }// Listここまで
            .scrollContentBackground(.visible)
            .navigationTitle("アカウント")
        }
        .PKHUD(isPresented: $isPKHUDProgress, HUDContent: .progress, delay: .infinity)
        .PKHUD(isPresented: $isPKHUDSuccess, HUDContent: .success, delay: 1.0)
        .PKHUD(isPresented: $isPKHUDError, HUDContent: .error, delay: 1.0)
        .sheet(isPresented: $isImagePickerFromLibrary) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $accountImage)
        }
        .sheet(isPresented: $isImagePickerFromCamera) {
            ImagePicker(sourceType: .camera, selectedImage: $accountImage)
        }
        .confirmationDialog("", isPresented: $isAccountImageDialog, titleVisibility: .hidden) {
            Button("写真を撮る") {
                isImagePickerFromCamera = true
            }
            Button("写真を選択") {
                isImagePickerFromLibrary = true
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

    func uploadIconImage() async {
        guard let accountImage = self.accountImage else {
            return
        }
        await viewModel.uploadIconImage(image: accountImage)
    }

}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(viewModel: AccountViewModel())
    }
}
