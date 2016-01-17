//
//  ViewController.swift
//  Muelle Amortiguado
//
//  Created by Carlos Guillermo Torre Barrenechea on 5/10/15.
//  Copyright © 2015 UPM. All rights reserved.
//

import UIKit

class ViewController: UIViewController, FunctionViewDataSource {

    
    @IBOutlet weak var masaSlider: UISlider!
    @IBOutlet weak var kSlider: UISlider!
    @IBOutlet weak var lambdaSlider: UISlider!
    
    @IBOutlet weak var posicionVelocidad: FunctionView!
    @IBOutlet weak var posicion: FunctionView!
    @IBOutlet weak var velocidad: FunctionView!
    
    
    
    var amortiguado: AmortiguadoClass!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        amortiguado = AmortiguadoClass(masa: Double(masaSlider.value), k: Double(kSlider.value), lambda: Double(lambdaSlider.value))
        
        posicionVelocidad.dataSource = self
        posicion.dataSource = self
        velocidad.dataSource = self
        
        masaSlider.sendActionsForControlEvents(.ValueChanged)
        lambdaSlider.sendActionsForControlEvents(.ValueChanged)
        kSlider.sendActionsForControlEvents(.ValueChanged)
        
        velocidad.escalaX = 0.1
        velocidad.escalaY = 0.15
        posicionVelocidad.escalaX = 0.06
        posicionVelocidad.escalaY = 0.15
    }
    
    @IBAction func masaChanged(sender: UISlider) {
        amortiguado.masa = Double(sender.value)
        posicion.setNeedsDisplay()
        posicionVelocidad.setNeedsDisplay()
        velocidad.setNeedsDisplay()
    }
    
    @IBAction func kChanged(sender: UISlider) {
        amortiguado.k = Double(sender.value)
        posicion.setNeedsDisplay()
        posicionVelocidad.setNeedsDisplay()
        velocidad.setNeedsDisplay()
    }
    
    @IBAction func lambdaChanged(sender: UISlider) {
        amortiguado.lambda = Double(sender.value)
        posicion.setNeedsDisplay()
        posicionVelocidad.setNeedsDisplay()
        velocidad.setNeedsDisplay()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        posicion.setNeedsDisplay()
        posicionVelocidad.setNeedsDisplay()
        velocidad.setNeedsDisplay()
    }
    
    
    func startTimeOfFunctionView(functionView: FunctionView) -> Double {
        return 0
    }
    
    func endTimeOfFunctionView(functionView: FunctionView) -> Double {
        return 10.0
    }
    
    func pointOfFunctionView(functionView: FunctionView,
        atTime time: Double) -> Posicion {
            switch functionView {
            case posicion:
                let y = amortiguado.positionAtTime(time)
                return Posicion(x: time,y: y)
            case velocidad:
                let y = amortiguado.velocidadAtTime(time)
                return Posicion(x: time, y: y)
            case posicionVelocidad:
                let x = amortiguado.positionAtTime(time)
                let y = amortiguado.velocidadAtTime(time)
                return Posicion(x: x, y: y)
            default:
                return Posicion(x: 0, y: 0)
            }
    }
}


