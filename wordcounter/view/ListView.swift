//
//  ListViewTemplate.swift
//  wordcounter
//
//  Created by 최명근 on 2023/03/18.
//

import SwiftUI
import UIKit
import CoreData
import UniformTypeIdentifiers

struct ListCell: View {
    let writing: FetchedResults<Writing>.Element
    
    var body: some View {
        VStack {
            if let timestamp = writing.timestamp {
                HStack {
                    Text(timestamp.fullString)
                        .font(.subheadline)
                        .foregroundColor(Color("ColorTextTertiary"))
                    Spacer()
                }
            }
            if let text = writing.text {
                HStack {
                    Text(text)
                        .font(.body)
                        .foregroundColor(Color("ColorTextPrimary"))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
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
        ]
    ) var writings: FetchedResults<Writing>
    
    private let publisher = NotificationCenter.default.publisher(for: .NSManagedObjectContextObjectsDidChange)
    @State private var renderId: UUID = UUID()
    
    // Selected Writing
    @Binding var selected: FetchedResults<Writing>.Element?
    
    // Navigation Column Visibility
    @Binding var columnVisibility: NavigationSplitViewVisibility
    
    // New Counter
    @State private var activeNewCounter: Bool = false
    
    // Info View Modal
    @State private var showInfoView: Bool = false
    
    // Setting View Modal
    @State private var showSettingView: Bool = false
    
    var body: some View {
        ZStack {
            Color("ColorBgSecondary")
                .ignoresSafeArea(.all)
            
            if writings.count > 0 {
                // MARK: 저장된 항목
                List(selection: $selected) {
                    Section {
                        ForEach(writings) { writing in
                            // NavigationLink
                            NavigationLink(value: writing) {
                                // Cell
                                ListCell(writing: writing)
                                    .onTapGesture {
                                        self.selected = writing
                                        self.columnVisibility = .detailOnly
                                    } // ListCell.onTapGesture
                                    .contextMenu {
                                        Section {
                                            // Copy Button
                                            Button(role: .none) {
                                                if let text = writing.text {
                                                    UIPasteboard.general.setValue(text, forPasteboardType: UTType.plainText.identifier)
                                                }
                                            } label : {
                                                Label("copy", systemImage: "doc.on.doc")
                                            }
                                        }
                                        
                                        Section {
                                            // Delete Button
                                            Button(role: .destructive) {
                                                managedObjectContext.delete(writing)
                                                saveContext()
                                                selected = nil
                                            } label : {
                                                Label("delete", systemImage: "trash")
                                            }
                                        }
                                        
                                    } preview: {
                                        VStack(spacing: 16) {
                                            if let text = writing.text {
                                                CounterInfoView(count: .constant(Count(text: text, spaceType: .includeBoth)), text: .constant(text))
                                                ScrollView {
                                                    Text(text)
                                                }
                                            } else {
                                                Text("unavailable")
                                            }
                                        }
                                        .padding()
                                    } // ListCell.contextMenu

                            }// NavigationLink
                            .swipeActions {
                                Button("delete", role: .destructive) {
                                    managedObjectContext.delete(writing)
                                    saveContext()
                                    selected = nil
                                }
                            }
                        }
                    } header: {
                        Text("list_saved")
                    }
                }
                .id(renderId)
                .onReceive(publisher) { output in
                    print("NSManagedObjectContextObjectsDidChange")
                    renderId = UUID()
                }
            } else {
                // MARK: 저장된 항목 없음
                VStack(spacing: 24) {
                    Image(uiImage: UIImage(named: "ic_no_content")!)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color("ColorTextTertiary"))
                        .aspectRatio(1, contentMode: .fit)
                        .frame(maxWidth: 128)
                    
                    Text("list_empty_list")
                        .font(SwiftUI.Font.headline)
                        .foregroundColor(Color("ColorTextTertiary"))

                    Spacer()
                        .frame(height: 60)
                }
                .padding(16)
            }
            
        }
        .navigationTitle("list_title")
        // MARK: - Toolbar
        .toolbar {
            // MARK: New Counter
            ToolbarItem(placement: .primaryAction) {
                Button {
                    newCounter()
                } label: {
                    Label("list_new", systemImage: "square.and.pencil")
                }
            }
            
            ToolbarItem(placement: .secondaryAction) {
                Button {
                    showSettingView = true
                } label: {
                    Label("list_settings", systemImage: "gearshape")
                }
            }
        }
        // MARK: - New Counter Navigation
        .navigationDestination(isPresented: $activeNewCounter) {
            CounterView(writing: $selected, columnVisibility: $columnVisibility)
        }
        // MARK: - Settings View Sheet
        .sheet(isPresented: $showSettingView) {
            NavigationStack {
                SettingsView()
            }
        }
        // MARK: - Open a new counter if it's iPhone
        .onLoad {
            if UIDevice.current.userInterfaceIdiom == .phone {
                newCounter()
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
    
    private func newCounter() {
        selected = nil
        activeNewCounter = true
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        SplitView()
    }
}
