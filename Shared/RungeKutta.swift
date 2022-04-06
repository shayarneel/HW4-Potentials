//
//  RungeKutta.swift
//  HW4-Potentials
//
//  Created by Shayarneel Kundu on 2/25/22.
//

import Foundation
import SwiftUI

class RungeKutta: NSObject, ObservableObject{
    
    @Published var psiPlot: [plotDataType] = []
    @Published var psiPlots: [[plotDataType]] = []
    @Published var psiArray: [Double] = []    //psi: the wavefunction
    @Published var psipArray: [Double] = []   //psip: the derivative of the wavefunction
    @Published var potentialList = PotentialList()
    
    
    func energySolver(Potential: String, xStep: Double, eMin: Double, eMax: Double, xMin: Double, xMax: Double, mass: Double){
        //Precision to which we want to check the energies
        let precision = 1e-4
        //energy step size must be close to whatever the precision is to avoid issues
        let eStep = 0.001
        
        //Things we need to generate the energy functional, to find the eigenvalues
        var energyEigenvalue : [[Double]] = []
        var energyFunctional : [(psi: Double, energy: Double)] = []
        
        var prevEnergy: Double = 0.0
        var prevPsi: Double = 0.0
        
        //To check for sign change on the last value of psi, store the last point
        for energy in stride(from: eMin, through: eMax, by: eStep){
            
            let lastPoint : (psi: Double, psip: Double, wavefunc: [plotDataType]) = rk4(Potential: Potential, xStep: xStep, xMin: xMin, xMax: xMax, mass: mass, energy: energy)
            
            energyFunctional.append((psi: lastPoint.0, energy: energy))
            
            var j = energyFunctional.count - 1
            
            var curPsi = energyFunctional[j].psi
            var curEnergy = energyFunctional[j].energy
            
            if (prevPsi * curPsi < 0 ){
                 if (abs(curPsi) < precision){
                     psiPlots.append(lastPoint.wavefunc)
                     energyEigenvalue.append([energy])
                }
                
            } else {
                prevEnergy = curEnergy
                prevPsi = curPsi
            }
   
        }
           
    }
    
    
    //First, attempt all of this using Euler Method or RK0
    //
    ///func: rk0 (Euler Method)
    ///
    /// - Parameters:
    ///  - xStep: Step zise for Runge Kutta (same as step size for defining Potentials)
    ///  - xMin: Minimum x Value for the Potential Box
    ///  - xMax: Mamimum x Value for the Potential Box
    ///  - Potential: y-values of the Potential array generated in PotentialList
    ///
    /// - returns: an array that gives psi and psip

//    func rk0(xStep: Double, xMin: Double, xMax: Double, mass: Double, eMin:Double, eMax:Double) {
//
//        //This sets up the initial condition, hard coded to be 0.0
//        let initialPsiVal = 0.0
//        let initialPsipVal = 1.0
//
//        psipArray.append(initialPsiVal)
//        psiArray.append(initialPsipVal)
//
//        potentialList.getPotential(potentialType: "Square Well", xMin: xMin, xMax: xMax, xStep: xStep)
//
//        var currentPsi = initialPsiVal
//        var currentPsip = initialPsipVal
//
//
//        //Here, there are nested loops. This "outer loop" deal with the energy functional
//        //keeping only the values that vanish at the boundary of the potential.
//        //for energyval in stride(from: eMin, through: eMax, by: 0.1){
//
//            var num = 0
//            var loopPsiArray: [Double] = [initialPsiVal]
//            var loopPsipArray: [Double] = [initialPsipVal]
//            psiPlot.append([.X: xMin, .Y: initialPsiVal])
//
//            //This "inner loop" numerically estimates the wavefunction at different steps
//            // amd stores the values.
//            for x in stride(from: xMin+xStep, through: xMax, by: xStep) {
//                currentPsi =  currentPsi + xStep * currentPsip
//                currentPsip = currentPsip + xStep * EnergyTerm(mass: mass, energy: 4.93, potential: potentialList.oneDPotentialYArray[num]) * currentPsi
//
//                loopPsiArray.append(currentPsi)
//                loopPsipArray.append(currentPsip)
//
//                psiPlot.append([.X: x, .Y: currentPsi])
//
//                num += 1
//            }
//
//    }
    
    ///func: rk4 (Runge-Kutta Method)
    ///
    /// - Parameters:
    ///  - xStep: Step zise for Runge Kutta (same as step size for defining Potentials)
    ///  - xMin: Minimum x Value for the Potential Box
    ///  - xMax: Mamimum x Value for the Potential Box
    ///  - Potential: y-values of the Potential array generated in PotentialList
    ///
    /// - returns: an array that gives psi and psip
    func rk4(Potential: String, xStep: Double, xMin: Double, xMax: Double, mass: Double, energy: Double) -> (psi: Double, psip: Double, wavefunc: [plotDataType]) {
        
        //This sets up the initial condition, hard coded to be 0.0
        let initialPsiVal = 0.0
        let initialPsipVal = 1.0
        var localPsiPlot : [plotDataType] = []
        
        psiArray.append(initialPsiVal)
        psipArray.append(initialPsipVal)
        
        potentialList.getPotential(potentialType: Potential, xMin: xMin, xMax: xMax, xStep: xStep)
        
        var currentPsi = initialPsiVal
        var currentPsip = initialPsipVal
        var num = 0
        var loopPsiArray: [Double] = [initialPsiVal]
        var loopPsipArray: [Double] = [initialPsipVal]
        localPsiPlot.append([.X: xMin, .Y: initialPsiVal])
            
        //This loop numerically estimates the wavefunction using rk4 and stores the values
        for x in stride(from: xMin+xStep, through: xMax, by: xStep) {
            let k0 = xStep * currentPsip
            let l0 = xStep * EnergyTerm(mass: mass, energy: energy, potential: potentialList.oneDPotentialYArray[num]) * currentPsi
                
            let k1 = xStep * (currentPsip + l0/2.0)
            let l1 = xStep * EnergyTerm(mass: mass, energy: energy, potential: potentialList.oneDPotentialYArray[num]) * (currentPsi + k0/2.0)
                
            let k2 = xStep * (currentPsip + l1/2.0)
            let l2 = xStep * EnergyTerm(mass: mass, energy: energy, potential: potentialList.oneDPotentialYArray[num]) * (currentPsi + k1/2.0)
                
            let k3 = xStep * (currentPsip + l2)
            let l3 = xStep * EnergyTerm(mass: mass, energy: energy, potential: potentialList.oneDPotentialYArray[num]) * (currentPsi + k2)
                
            currentPsi =  currentPsi + (k0 + 2.0*k1 + 2.0*k2 + k3)/6.0
            currentPsip = currentPsip + (l0 + 2.0*l1 + 2.0*l2 + l3)/6.0
                
            loopPsiArray.append(currentPsi)
            loopPsipArray.append(currentPsip)
                
            localPsiPlot.append([.X: x, .Y: currentPsi])
                
            num += 1
        }
        
        return (currentPsi, currentPsip, localPsiPlot)
    }

//    /// Normalize wavefunciton using average value theorem
//    func normalize(function: [Double], xMin: Double, xMax: Double) -> [Double]{
//        
//        let n = function.count
//        let length = abs(xMax - xMin)
//        var sum = 0.0
//        
//        var normalizedArray: [Double] = [0.0]
//        
//        for item in function {
//            sum += item
//        }
//        
//        let avg = (abs(sum/Double(n))) * length
//        
//        for item in function {
//            normalizedArray.append(item/avg)
//        }
//        
//        return normalizedArray
//    }

    /// func: EnergyTerm (This is the Energy Term that is on the RHS of the SWE)
    ///
    /// - Parameters:
    ///  - mass: Mass of particle
    ///  - Energy: Energy eigenvlaue of the Particle
    ///  - Potential: input form the Potential Fiele
    ///
    ///  - returns: value on the RHS of SWE when it is made dimensionless
    func EnergyTerm(mass: Double, energy: Double, potential: Double) -> Double {
        
        let hbar = 1.0 //Working in natural units
        let numerator = (potential - energy) * 2.0 * mass
        let denominator = pow(hbar,2.0)
        
        return numerator/denominator
    }
    
    
}
