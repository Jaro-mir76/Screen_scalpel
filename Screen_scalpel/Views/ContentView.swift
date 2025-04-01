//
//  ContentView.swift
//  Screen_scalpel
//
//  Created by Jaromir Jagieluk on 19/02/2025.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject private var screenCaptureEngine: MainEngine
    
    var body: some View {
        VStack {
//            Text("Screen Scalpel!")
//                .padding(.top, 5)
//                .frame(width: 100)
            
            HStack{
                Button(action: {    //Capture seleceted part of the screen
                    screenCaptureEngine.takeScreenshot(of: .selection)
                }, label: { Label("Capture selected screen part", systemImage: "crop")
                        .labelStyle(.iconOnly)
                })
                
                
                Button {    //Capture selected window
                    screenCaptureEngine.takeScreenshot(of: .window)
                } label: {
                    Label("Capture entire screen", systemImage: "macwindow")
                        .labelStyle(.iconOnly)
                }
                
                Button {    //Capture entire screen
                    screenCaptureEngine.takeScreenshot(of: .screen)
                } label: {
                    Label("Capture entire screen", systemImage: "inset.filled.rectangle")
                        .labelStyle(.iconOnly)
                }
            }
            ScrollView{
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 200, maximum: 300))]) {
                    ForEach(screenCaptureEngine.images, id: \.self) {image in
                        Image(nsImage: image)
                            .resizable()
                            .scaledToFit()
                            .onDrag {
                                NSItemProvider(object: image)
                            } //preview: {
//                                <#code#>
//                            }
                    }
                }
            }
        }
        .padding()
//        .frame(width: 150, height: 120)
    }
}

#Preview {
    ContentView()
        .environmentObject(MainEngine())
        .frame(width: 150, height: 120)
}
