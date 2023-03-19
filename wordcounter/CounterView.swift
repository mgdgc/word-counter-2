//
//  CounterViewTemplate.swift
//  wordcounter
//
//  Created by 최명근 on 2023/03/19.
//

import SwiftUI
import UIKit

struct CounterInfoView: View {
    @Binding var count: Count
    @Binding var text: String
    @State var showBytes: Bool = false
    
    private let spaceOptions: [SpaceType] = [.includeBoth, .includeSpace, .includeEnter, .neither]
    
    var body: some View {
        HStack {
            // MARK: 붙여넣기
            Button {
                let pb: UIPasteboard = UIPasteboard.general
                if let string = pb.string {
                    text = string
                }
            } label: {
                Image(systemName: "doc.on.clipboard")
            }
            
            Spacer()
            HStack {
                if count.text.isEmpty {
                    Text("counter_empty")
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
    
    @Binding var writing: FetchedResults<Writing>.Element?
    
    @State var text: String = ""
    @State var count: Count = Count(text: "", spaceType: .includeBoth)
    
    var body: some View {
        ZStack {
            
            // MARK: - Text Field
            TextEditor(text: $text)
                .font(.body)
                .padding([.top], 56)
                .padding([.trailing, .leading], 20)
                .onChange(of: text) { newValue in
                    count = Count(text: newValue, spaceType: .includeBoth)
                }
            
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
                .padding([.top], 64)
                .padding([.trailing, .leading], 26)
            }
            
            // MARK: - Info View
            VStack {
                CounterInfoView(count: $count, text: $text)
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
        let newId = UUID().uuidString
        
        let writing = Writing(context: managedObjectContext)
        writing.id = newId
        writing.text = text
        writing.timestamp = Date()
        
        saveContext()
        
        // Clear
        self.text = ""
        self.writing = nil
    }
    
    private func edit(writing: FetchedResults<Writing>.Element, toUpdate text: String) {
        writing.text = text
        writing.timestamp = Date()
        
        saveContext()
        
        managedObjectContext.refresh(writing, mergeChanges: true)
    }
}

struct CounterView_Previews: PreviewProvider {
    static var previews: some View {
        SplitView()
    }
}
