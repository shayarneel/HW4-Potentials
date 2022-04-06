//
//  PlotClass.swift
//  HW4-Potentials
//
//  Created by Shayarneel Kundu on 2/28/22.
//

import Foundation

class PlotClass: ObservableObject {
    
    @Published var plotArray: [PlotDataClass]
    
    @MainActor init() {
        self.plotArray = [PlotDataClass.init(fromLine: true)]
        self.plotArray.append(contentsOf: [PlotDataClass.init(fromLine: true)])
            
        }
 
}

