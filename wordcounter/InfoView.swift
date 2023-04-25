//
//  InfoView.swift
//  wordcounter
//
//  Created by 최명근 on 2023/03/19.
//

import SwiftUI
import UIKit

struct InfoCell: View {
    
    var title: LocalizedStringKey
    var content: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(Color(uiColor: .label))
            Spacer()
            Text(content)
                .foregroundColor(Color(uiColor: .secondaryLabel))
        }
    }
}

struct InfoView: View {
    
    @State var version: String = "v2.0"
    @State var build: String = "2023031800"
    
    var body: some View {
        ZStack {
            List {
                Section {
                    InfoCell(title: "info_version", content: version)
                    InfoCell(title: "info_build", content: build)
                } header: {
                    Text("info_section_app")
                }
                
                Section {
                    Link(destination: URL(string: "https://mgchoi.com")!) {
                        InfoCell(title: "info_developer", content: "mgchoi")
                    }
                }
            }
        }
        .onAppear {
            // 애플리케이션 버전
            if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                self.version = version
            }
            
            // 빌드 버전
            if let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
                self.build = build
            }
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}


