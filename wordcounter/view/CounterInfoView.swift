//
//  CounterInfoView.swift
//  wordcounter
//
//  Created by 최명근 on 11/18/23.
//

import Foundation
import SwiftUI
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
