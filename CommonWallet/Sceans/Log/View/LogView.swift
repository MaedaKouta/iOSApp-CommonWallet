//
//  LogView.swift
//  CommonWallet
//
//  Created by 前田航汰 on 2023/02/06.
//

import SwiftUI
import Parchment

struct LogView: View {

    @ObservedObject var logViewModel = LogViewModel()
    @State var isAllLogView = false

    var body: some View {

        NavigationView {
            List {

                VStack {
                    HeaderLogView()
                }

                Section {
                    ForEach(0 ..< logViewModel.lastResolvedTransactions.count,  id: \.self) { index in

                        HStack {
                            Text(String(logViewModel.lastResolvedTransactions[index].amount) + "円")
                            Text(logViewModel.lastResolvedTransactions[index].title)
                            Spacer()
                        }
                        .foregroundColor(.black)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            print(index)
                        }
                    }
                } header: {
                    HStack {
                        Text("前々回の精算")
                        Spacer()
                        NavigationLink(destination: AllLogView(), label: {
                            Text("取り消す")
                        })
                    }
                }
                .listRowBackground(Color.init(UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)))

                Section {
                    ForEach(0 ..< logViewModel.previousResolvedTransactions.count,  id: \.self) { index in

                        HStack {
                            Text(String(logViewModel.previousResolvedTransactions[index].amount) + "円")
                            Text(logViewModel.previousResolvedTransactions[index].title)
                            Spacer()
                        }
                        .foregroundColor(.black)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            print(index)
                        }
                    }
                } header: {
                    HStack {
                        Text("前回の精算")
                        Spacer()
                        NavigationLink(destination: AllLogView(), label: {
                            Text("取り消す")
                        })
                    }
                }
                .listRowBackground(Color.init(UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)))

                NavigationLink(destination: AllLogView(), label: {
                    Text("全履歴")
                })

            }
            .scrollContentBackground(.hidden)
            .scrollIndicators(.hidden)
        }.onAppear{
            Task {
                try await logViewModel.fetchLastResolvedAt()
                try await logViewModel.fetchPreviousResolvedAt()
                print("a",logViewModel.lastResolvedTransactions)
                print("aa", logViewModel.previousResolvedTransactions)
            }
        }
    }
}

struct LogView_Previews: PreviewProvider {
    static var previews: some View {
        LogView()
    }
}
