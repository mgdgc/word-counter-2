//
//  LicensesView.swift
//  wordcounter
//
//  Created by 최명근 on 11/17/23.
//

import SwiftUI

struct License: Identifiable {
    var name: String
    var license: String
    var url: String
    var id: String {
        name
    }
}

struct LicensesView: View {
    let licenses: [License] = [
        License(name: "SwiftKeychainWrapper", license: "MIT", url: "https://github.com/jrendel/SwiftKeychainWrapper")
    ]
    
    var body: some View {
        List {
            ForEach(licenses) { license in
                if let url = URL(string: license.url) {
                    ShareLink(item: url) {
                        HStack {
                            VStack {
                                HStack {
                                    Text(license.name)
                                        .font(.title2.bold())
                                    Spacer()
                                }
                                HStack {
                                    Text(license.url)
                                        .font(.caption)
                                    Spacer()
                                }
                            }
                            Spacer()
                            Text(license.license)
                        }
                    }
                }
            }
        }
        .navigationTitle("info_license")
    }
}

#Preview {
    LicensesView()
}
