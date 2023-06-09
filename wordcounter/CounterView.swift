//
//  CounterViewTemplate.swift
//  wordcounter
//
//  Created by 최명근 on 2023/03/19.
//

import SwiftUI
import UIKit
import CoreData
import UniformTypeIdentifiers

struct CounterInfoView: View {
    @Binding var count: Count
    @Binding var text: String
    @State var showBytes: Bool = false
    
    @State private var textToPaste: String?
    @State private var showPasteAlert: Bool = false
    
    var onStartWritingClick: (() -> Void)?
    
    private let spaceOptions: [SpaceType] = [.includeBoth, .includeSpace, .includeEnter, .neither]
    
    var body: some View {
        HStack {
            // MARK: 복사 & 붙여넣기
            Menu {
                // 복사
                Button(role: .none) {
                    UIPasteboard.general.setValue(text, forPasteboardType: UTType.plainText.identifier)
                    
                } label: {
                    Label("copy", systemImage: "doc.on.doc")
                }
                
                // 붙여넣기
                Button(role: .none) {
                    let pb: UIPasteboard = UIPasteboard.general
                    guard let string = pb.string else {
                        return
                    }
                    
                    if text.isEmpty {
                        // 빈 텍스트이면 붙여넣기
                        text = string
                    } else {
                        // 빈 텍스트가 아니면 경고 메시지
                        textToPaste = string
                        showPasteAlert = true
                    }
                    
                } label: {
                    Label("paste", systemImage: "doc.on.clipboard")
                } // Button


            } label: {
                Image(systemName: "clipboard")
            }
            .confirmationDialog("paste_warning_title", isPresented: $showPasteAlert, presenting: textToPaste) { pasteObject in
                // Replace
                Button("paste_replace", role: .destructive) {
                    self.text = pasteObject
                }
                
                // Append
                Button("paste_append", role: .none) {
                    text.append(contentsOf: pasteObject)
                }
                
                // Cancel
                Button("cancel", role: .cancel) {
                    textToPaste = nil
                    showPasteAlert = false
                }
            } message: { _ in
                Text("paste_warning_message")
            }
            
            Spacer()
            HStack {
                if count.text.isEmpty {
                    Text("counter_empty")
                        .onTapGesture {
                            if let onStartWritingClick = onStartWritingClick {
                                onStartWritingClick()
                            }
                        }
                } else {
                    Text(showBytes ? "\("counter_bytes".localized): \(count.bytes)" : "\("counter_letters".localized): \(count.letters), \("counter_words".localized): \(count.words)")
                        .onTapGesture {
                            showBytes.toggle()
                        }
                }
            }
            Spacer()
            
            // MARK: 공백 옵션
            Menu {
                ForEach(0..<4) { i in
                    Button {
                        self.count.spaceType = spaceOptions[i]
                    } label: {
                        Text("\(spaceOptions[i].rawValue.localized)")
                    }
                }
            } label: {
                Image(systemName: "text.word.spacing")
            }
        }
        .foregroundColor(Color("ColorTextSecondary"))
        .padding(12)
        .padding([.leading, .trailing], 8)
        .frame(maxWidth: 480)
        .background(
            Rectangle()
                .fill(Color("ColorBgPrimary"))
                .cornerRadius(28)
                .shadow(
                    color: Color.black.opacity(0.1),
                    radius: 8,
                    y: 4)
        )
    }
}

struct CounterView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.dismiss) var dismiss
    
    @Binding var writing: FetchedResults<Writing>.Element?
    
    @State var text: String = ""
    @State var count: Count = Count(text: "", spaceType: .includeBoth)
    
    @FocusState private var focus: Focus?
    
    fileprivate enum Focus {
        case textEditor
    }
    
    var body: some View {
        ZStack {
            
            // MARK: - Text Field
            TextEditor(text: $text)
                .font(.body)
                .padding([.top], 72)
                .padding([.trailing, .leading], 20)
                .onChange(of: text) { newValue in
                    count = Count(text: newValue, spaceType: .includeBoth)
                }
                .focused($focus, equals: Focus.textEditor)
            
            // MARK: - Placeholder
            if text.isEmpty {
                VStack(alignment: .leading) {
                    HStack {
                        Text("counter_placeholder")
                            .font(.body)
                            .foregroundColor(Color("ColorTextTertiary"))
                        Spacer()
                    }
                    Spacer()
                }
                .padding([.top], 80)
                .padding([.trailing, .leading], 26)
            }
            
            // MARK: - Info View
            VStack {
                CounterInfoView(count: $count, text: $text) {
                    focus = .textEditor
                }
                Spacer()
            }
            .padding([.top], 8)
            .padding([.leading, .trailing], 20)
        }
        .task {
            // MARK: - 기존 데이터 fetch
            if let writing = writing {
                self.text = writing.text ?? ""
            }
        }
        .id(writing?.id)
        .navigationTitle("app_name")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    if let writing = writing {
                        edit(writing: writing, toUpdate: text)
                    } else {
                        save(text: text)
                    }
                } label: {
                    Text("counter_save")
                }
                
            }
        }
    }
    
    private func saveContext() {
      do {
        try managedObjectContext.save()
      } catch {
        print("Error saving managed object context: \(error)")
      }
    }
    
    private func save(text: String) {
        saveContext()
        
        let newId = UUID().uuidString
        
        let writing = Writing(context: managedObjectContext)
        writing.id = newId
        writing.text = text
        writing.timestamp = Date()
        
        saveContext()
        
        // Clear
        self.text = ""
        self.writing = nil
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            dismiss()
        }
    }
    
    private func edit(writing: FetchedResults<Writing>.Element, toUpdate text: String) {
        
        saveContext()
        
        writing.setValue(text, forKey: "text")
        writing.setValue(Date(), forKey: "timestamp")
        
        saveContext()
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            dismiss()
        }
    }
}

struct CounterView_Previews: PreviewProvider {
    static var previews: some View {
        SplitView()
    }
}
