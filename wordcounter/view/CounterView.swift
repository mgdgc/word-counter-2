//
//  CounterViewTemplate.swift
//  wordcounter
//
//  Created by 최명근 on 2023/03/19.
//

import SwiftUI
import UIKit
import CoreData

struct CounterView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.dismiss) var dismiss
    
    @Binding var writing: Writing?
    @Binding var columnVisibility: NavigationSplitViewVisibility
    
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
                    
                    if let writing = writing {
                        edit(writing: writing, toUpdate: newValue)
                    }
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
        .onDisappear {
            if UIDevice.current.userInterfaceIdiom == .phone {
                if let writing = writing, writing.text?.isEmpty == true {
                    delete(writing: writing)
                }
            }
        }
        .id(writing?.id)
        .navigationTitle("app_name")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    save(writing: writing)
                    
                    columnVisibility = .all
                } label: {
                    Text("counter_save")
                }
                .keyboardShortcut("s")
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
    
    private func save(writing: Writing?) {
        if let writing = writing {
            if writing.text?.isEmpty == true {
                delete(writing: writing)
            } else {
                edit(writing: writing, toUpdate: text)
            }
        } else {
            insert(text: text)
        }
    }
    
    private func insert(text: String) {
        saveContext()
        
        let writing = Writing(context: managedObjectContext)
        writing.id = UUID().uuidString
        writing.text = text
        writing.timestamp = Date()
        
        saveContext()
        
        self.writing = writing
    }
    
    private func edit(writing: Writing, toUpdate text: String) {
        
        saveContext()
        
        writing.setValue(text, forKey: "text")
        writing.setValue(Date(), forKey: "timestamp")
        
        saveContext()
    }
    
    private func delete(writing: Writing) {
        managedObjectContext.delete(writing)
    }
}

struct CounterView_Previews: PreviewProvider {
    static var previews: some View {
        SplitView()
    }
}
