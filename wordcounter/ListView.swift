//
//  ListViewTemplate.swift
//  wordcounter
//
//  Created by 최명근 on 2023/03/18.
//

import SwiftUI
import UIKit

struct ListCell: View {
    let writing: FetchedResults<Writing>.Element
    
    var body: some View {
        VStack {
            if let text = writing.text {
                Text(text)
                    .foregroundColor(Color("ColorTextPrimary"))
                    .lineLimit(2)
            } else {
                Text("list_empty_writing")
                    .font(.caption.italic())
                    .foregroundColor(Color("ColorTextTertiary"))
            }
        }
        .padding(4)
    }
}

struct ListView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    // MARK: Fetch Request
    @FetchRequest(
        entity: Writing.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Writing.timestamp, ascending: false)
        ]) var writings: FetchedResults<Writing>
    
    @Binding var selected: FetchedResults<Writing>.Element?
    @State private var activeNewCounter: Bool = false
    
    var body: some View {
        ZStack {
            Color("ColorBgSecondary")
                .edgesIgnoringSafeArea(.all)
            
            if writings.count > 0 {
                // MARK: 저장된 항목
                List(selection: $selected) {
                    Section {
                        ForEach(writings) { writing in
                            NavigationLink(value: writing) {
                                ListCell(writing: writing)
                                    .onTapGesture {
                                        self.selected = writing
                                    }
                            }
                        }
                    } header: {
                        Text("list_saved")
                    }
                }
                .padding([.bottom], 100)
            } else {
                // MARK: 저장된 항목 없음
                VStack(spacing: 24) {
                    Image(uiImage: UIImage(named: "ic_no_content")!)
                        .resizable()
                        .aspectRatio(1.56, contentMode: .fit)
                        .frame(maxWidth: 256)
                    
                    Text("list_empty_list")
                        .font(SwiftUI.Font.headline)
                        .foregroundColor(Color("ColorTextTertiary"))
                    
                    Button {
                        newCounter()
                    } label: {
                        HStack {
                            Image(systemName: "plus")
                            Text("list_new")
                        }
                    }
                    .buttonStyle(.bordered)

                    Spacer()
                        .frame(height: 60)
                }
                .padding(16)
            }
            
            // MARK: - 새 카운터 액션 버튼
            VStack(alignment: .leading) {
                Spacer()
                HStack {
                    Button {
                        newCounter()
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .resizable()
                    }
                    .foregroundColor(Color("ColorPrimary"))
                    .padding(20)
                    .frame(width: 64, height: 64)
                    .background(
                        Rectangle()
                            .fill(Color("ColorBgPrimary"))
                            .cornerRadius(32)
                            .shadow(
                                color: Color.black.opacity(0.1),
                                radius: 8,
                                y: 4)
                    )
                    Spacer()
                }
                .padding(20)
            }
        }
        .navigationTitle("list_title")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            // MARK: Information Toolbar Item
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    // TODO: Action
                } label: {
                    Image(systemName: "info.circle")
                }
            }
            
            // MARK: Setting Toolbar Item
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    // TODO: Action
                } label: {
                    Image(systemName: "gearshape")
                }
            }
        }
        .navigationDestination(isPresented: $activeNewCounter) {
            CounterView(writing: $selected)
        }
    }
    
    private func newCounter() {
        activeNewCounter = true
    }
}
