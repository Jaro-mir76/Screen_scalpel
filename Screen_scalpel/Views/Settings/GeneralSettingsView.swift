//
//  GeneralSettingsView.swift
//  Screen_scalpel
//
//  Created by Jaromir Jagieluk on 19/02/2025.
//

import SwiftUI

struct GeneralSettingsView: View {
    
    @AppStorage("menuBarExtraIsVisible") var menuBarExtraIsVisible: Bool = true
    
    var body: some View {
        Form {
            VStack(alignment: .center) {
                    Toggle("Show menu bar Extra", isOn: $menuBarExtraIsVisible)
                Divider()
                    .padding(5)
                ScreenshotsHomeFolderSettingView()
            }
        }
        .padding()
    }
}

#Preview {
    GeneralSettingsView()
}
