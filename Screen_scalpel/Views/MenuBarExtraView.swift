//
//  MenuBarExtraView.swift
//  Screen_scalpel
//
//  Created by Jaromir Jagieluk on 19/02/2025.
//

import SwiftUI

struct MenuBarExtraView: View {
    
    @ObservedObject var screenCaptureModel: MainEngine
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            HStack{
                Button(action: {    //Capture seleceted part of the screen
                    screenCaptureModel.takeScreenshot(of: .selection)
                }, label: { Label("Capture selected screen part", systemImage: "crop")
                        .labelStyle(.iconOnly)
                })
                
                Button {    //Capture selected window
                    screenCaptureModel.takeScreenshot(of: .window)
                } label: {
                    Label("Capture entire screen", systemImage: "macwindow")
                        .labelStyle(.iconOnly)
                }
                
                Button {    //Capture entire screen
                    screenCaptureModel.takeScreenshot(of: .screen)
                } label: {
                    Label("Capture entire screen", systemImage: "inset.filled.rectangle")
                        .labelStyle(.iconOnly)
                }
            }
            ScrollView{
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 50, maximum: 100))]) {
                    ForEach(screenCaptureModel.images, id: \.self) {image in
                        Image(nsImage: image)
                            .resizable()
                            .scaledToFit()
                            .onDrag {
                                NSItemProvider(object: image)
                            }
                    }
                }
            }
//            .contentMargins(20)
            .frame(maxWidth: 200, maxHeight: 150)
        }
        .padding(10)
    }
}

#Preview {
    MenuBarExtraView(screenCaptureModel: MainEngine())
}
