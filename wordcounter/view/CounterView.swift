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
    
    @State private var showSaveAlert: Bool = false
    
    @FocusState private var focus: Focus?
    
    fileprivate enum Focus {
        case textEditor
    }
    
    var body: some View {
        ZStack {
            // MARK: - Text Field
#if os(iOS)
            Group {
                textField
                placeholder
                    .padding([.top], 8)
                    .padding([.horizontal], 6)
            }
            .padding([.top], 72)
            .padding([.horizontal], 20)
#elseif os(visionOS)
            Group {
                textField
                    .contentShape(.rect(cornerRadius: 8))
                placeholder
                    .padding([.top], 16)
                    .padding([.horizontal], 24)
            }
            .padding([.horizontal], 20)
#endif
            
            // MARK: - Info View
#if os(iOS)
            VStack {
                CounterInfoView(count: $count, text: $text) {
                    focus = .textEditor
                }
                Spacer()
            }
            .padding([.top], 8)
            .padding([.leading, .trailing], 20)
#endif
        }
#if os(visionOS)
        .ornament(visibility: .visible, attachmentAnchor: .scene(.bottom), contentAlignment: .center) {
            CounterInfoView(count: $count, text: $text) {
                focus = .textEditor
            }
        }
#endif
        .onAppear {
            // MARK: - 기존 데이터 fetch
            self.text = writing?.text ?? ""
        }
        .id(writing?.id)
        .navigationTitle("app_name")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if writing == nil {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        save(writing: writing)
                        
                        columnVisibility = .all
                    } label: {
                        Text("counter_save")
                    }
                    .keyboardShortcut("s")
                }
            } else {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("counter_save", systemImage: "checkmark.circle") {
                        showSaveAlert = true
                    }
                    .alert("counter_save_alert_title", isPresented: $showSaveAlert) {
                        Button("confirm", role: .cancel) {
                            showSaveAlert = false
                        }
                    } message: {
                        Text("counter_save_alert_message")
                    }
                    
                }
            }
        }
    }
    
    var textField: some View {
        TextEditor(text: $text)
            .font(.body)
            .addViewModifier { view in
                if #available(iOS 17, *) {
                    view.onChange(of: text) { _, newValue in
                        count = Count(text: newValue, spaceType: .includeBoth)
                        
                        if let writing = writing {
                            edit(writing: writing, toUpdate: newValue)
                        }
                    }
                } else {
                    view.onChange(of: text) { newValue in
                        count = Count(text: newValue, spaceType: .includeBoth)
                        
                        if let writing = writing {
                            edit(writing: writing, toUpdate: newValue)
                        }
                    }
                }
            }
            .focused($focus, equals: Focus.textEditor)
    }
    
    var placeholder: some View {
        ZStack {
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
