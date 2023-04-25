//
//  ListViewTemplate.swift
//  wordcounter
//
//  Created by 최명근 on 2023/03/18.
//

import SwiftUI
import UIKit
import CoreData

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
        ]
    ) var writings: FetchedResults<Writing>
    
    private let publisher = NotificationCenter.default.publisher(for: .NSManagedObjectContextObjectsDidChange)
    @State private var renderId: UUID = UUID()
    
    // Selected Writing
    @Binding var selected: FetchedResults<Writing>.Element?
    
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
                            NavigationLink(value: writing) {
                                ListCell(writing: writing)
                                    .onTapGesture {
                                        self.selected = writing
                                    }
                            }
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
                        .aspectRatio(1.56, contentMode: .fit)
                        .frame(maxWidth: 256)
                    
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
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    newCounter()
                } label: {
                    Image(systemName: "square.and.pencil")
                }
            }
        }
        // MARK: - New Counter Navigation
        .navigationDestination(isPresented: $activeNewCounter) {
            CounterView(writing: $selected)
        }
        // MARK: - Info View Sheet
        .sheet(isPresented: $showInfoView) {
            InfoView()
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
