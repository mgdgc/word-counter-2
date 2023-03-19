//
//  InfoView.swift
//  wordcounter
//
//  Created by 최명근 on 2023/03/19.
//

import SwiftUI
import UIKit

struct InfoView: View {
    
    @State var version: String = "v2.0"
    @State var build: String = "2023031800"
    
    var body: some View {
        ZStack {
            Color("ColorBgTertiary")
                .edgesIgnoringSafeArea(.all)
            
            // MARK: - Application Info
            VStack {
                Image(uiImage: UIImage(named: "ic_symbol")!)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(maxWidth: 256, maxHeight: 128)
                Text("app_name")
                    .font(.title2)
                    .bold()
                    .foregroundColor(Color("ColorTextTertiary"))
                Spacer()
                    .frame(height: 20)
                Text(version)
                    .font(.caption)
                    .foregroundColor(Color("ColorTextTertiary"))
                Text(build)
                    .font(.caption)
                    .foregroundColor(Color("ColorTextTertiary"))
            }
            
            // MARK: - Developer
            VStack {
                Spacer()
                Link(destination: URL(string: "https://mgchoi.com")!) {
                    HStack {
                        Image(systemName: "wrench.and.screwdriver.fill")
                        Text("MG Choi")
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

