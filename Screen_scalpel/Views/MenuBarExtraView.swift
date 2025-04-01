//
//  MenuBarExtraView.swift
//  Screen_scalpel
//
//  Created by Jaromir Jagieluk on 19/02/2025.
//

import SwiftUI

struct MenuBarExtraView: View {
    @EnvironmentObject private var screenCaptureEngine: MainEngine
    
    var body: some View {
        VStack(alignment: .center) {
            HStack{
                CaptureSelectionButton(fontSize: .title3, buttonSize: .small)
                CaptureWindowButton(fontSize: .title3, buttonSize: .small)
                CaptureScreenButton(fontSize: .title3, buttonSize: .small)
                CaptureFromiPhoneButton(fontSize: .title3, buttonSize: .small)
            }
            .frame(maxHeight: 30)
            ScrollView{
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 60, maximum: 100))]) {
                    ScreenshotsListView()
                }
            }
            .frame(maxWidth: 370, maxHeight: 200)
        }
        .padding(5)
    }
}

#Preview {
    MenuBarExtraView()
        .environmentObject(MainEngine())
}
