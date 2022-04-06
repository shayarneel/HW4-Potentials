//
//  HW4_PotentialsApp.swift
//  Shared
//
//  Created by Shayarneel Kundu on 2/18/22.
//

import SwiftUI

@main
struct HW4_PotentialsApp: App {
    
    @StateObject var plotData = PlotClass()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(plotData)
        }
    }
}
