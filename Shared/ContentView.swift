//
//  ContentView.swift
//  Shared
//
//  Created by Shayarneel Kundu on 2/18/22.
//

import SwiftUI
import CorePlot

typealias plotDataType = [CPTScatterPlotField : Double]

struct ContentView: View {
    
    @EnvironmentObject var plotData : PlotClass
    @ObservedObject var rk = RungeKutta()
    
    @State var xStep: Double? = 0.1
    @State var xMin: Double? = 0.0
    @State var xMax: Double? = 1.0
    @State var eMin: Double? = 0.0
    @State var eMax: Double? = 20.0
    @State var mass: Double? = 1.0
    @State var potentialString = ""
    
    var VList = ["Square Well", "Linear Well", "Parabolic Well", "Square + Linear Well"]
    
    @State var selector = 0
    
    @State var blank : [plotDataType] = []
    
    private var doubleFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.minimumSignificantDigits = 3
        f.maximumSignificantDigits = 9
        return f
    }()
    
    var body: some View {
        HStack {
            VStack {
                VStack {
                    Text("Step Size")
                    TextField("determines resolution", value: $xStep, formatter: doubleFormatter)
                        .frame(width: 100.0)
                }.padding()
                
                VStack {
                    Text("Left End")
                    TextField("min x value for potential", value: $xMin, formatter: doubleFormatter)
                        .frame(width: 100.0)
                }.padding()
                
                VStack {
                    Text("Eight End")
                    TextField("max x value for potential", value: $xMax, formatter: doubleFormatter)
                        .frame(width: 100.0)
                }.padding()
                
                VStack {
                    Text("Minimum Energy")
                    TextField("minimum energy from where we solve for states", value: $eMin, formatter: doubleFormatter)
                        .frame(width: 100.0)
                }.padding()
                
                VStack {
                    Text("Maximum Energy")
                    TextField("maximum energy till where we solve for states", value: $eMax, formatter: doubleFormatter)
                        .frame(width: 100.0)
                }.padding()
                
                VStack {
                    Text("Mass")
                    TextField("mass in natural units", value: $mass, formatter: doubleFormatter)
                        .frame(width: 100.0)
                }.padding()
                
                VStack{
                    Text("Potential")
                    Picker("", selection: $potentialString){
                            ForEach(VList, id: \.self){
                                Text($0)
                            }
                        }.frame(width: 100)
                }.padding()
                
                VStack{
                    
                    Button("Solve", action: self.calculate)
                        .frame(width: 100)
                        .padding()
                    
                    Button("Next Energy Eigenvalue", action: self.increase)
                        .frame(width: 100)
                        .padding()

                    Button("Previous Energy Eigenvalue", action: self.decrease)
                        .frame(width: 100)
                        .padding()

//                    Button("Clear", action: self.clear)
//                            .frame(width: 100)
//                            .padding()
                       
                }
                
                
            }
            
            CorePlot(dataForPlot: $rk.psiPlots.count > 0 ? $rk.psiPlots[selector] : $blank,
                     changingPlotParameters: $plotData.plotArray[0].changingPlotParameters)
                .setPlotPadding(left: 10)
                .setPlotPadding(right: 10)
                .setPlotPadding(top: 10)
                .setPlotPadding(bottom: 10)
                .padding()
        }
    }
    
    func calculate() {
        rk.energySolver(Potential: potentialString, xStep: xStep!, eMin: eMin!, eMax: eMax!, xMin: xMin!, xMax: xMax!, mass: mass!)
    }
    
     func increase() {
        if selector < rk.psiPlots.count - 1 {
               selector += 1
           } else {
               selector = 0
           }
       }
       
     func decrease() {
           if selector > 0 {
               selector -= 1
           } else {
               selector = 0
           }
       }
       
//       mutating func clear() {
//           selector = 0
//           rk.clearData()
//       }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
