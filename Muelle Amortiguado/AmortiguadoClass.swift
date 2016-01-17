//
//  AmortiguadoClass.swift
//  Muelle Amortiguado
//
//  Created by Carlos Guillermo Torre Barrenechea on 5/10/15.
//  Copyright © 2015 UPM. All rights reserved.
//

import Foundation

class AmortiguadoClass {
    
    var masa = 0.0 {
        didSet {
            actualizar()
        }
    }
    
    var k = 0.0 {
        didSet {
            actualizar()
        }
    }
    
    var lambda = 0.0 {
        didSet {
            actualizar()
        }
    }
    
    
    let x0 = 3.0
    
    let v0 = 0.0
    
    var velocidad = 0.0
    
    var posicion = 0.0
    
    
    private var w0 = 1.0
    private var omega = 1.0
    private var w = 1.0
    private var A = 1.0
    private var fi = 1.0
    
    
    init(masa: Double, k: Double, lambda: Double) {
        self.masa = masa
        self.k = k
        self.lambda = lambda
    }
    
    private func actualizar(){
        w0 = sqrt(k / masa)
        omega = lambda / masa / 2
        w = sqrt(w0*w0 - omega*omega)
        A = sqrt(x0*x0 + pow((v0+omega*x0)/w,2))
        fi = atan(x0*w/(v0+omega*x0))
    }
    
    func positionAtTime(time: Double) -> Double {
        return A*exp(-omega*time)*sin(w*time + fi)
    }
    
    func velocidadAtTime(time: Double) -> Double {
        let aux1 = -omega*A*exp(-omega*time)*sin(w*time + fi)
        let aux2 = A*exp(-omega*time)*w*cos(w*time + fi)
        return aux1+aux2
    }
}
