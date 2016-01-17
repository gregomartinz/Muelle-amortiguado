//
//  FunctionView.swift
//  Muelle Amortiguado
//
//  Created by Carlos Guillermo Torre Barrenechea on 7/10/15.
//  Copyright © 2015 UPM. All rights reserved.
//


import UIKit

struct Posicion {
    var x = 0.0
    var y = 0.0
}

protocol FunctionViewDataSource: class {
    
    func startTimeOfFunctionView(functionView: FunctionView) -> Double
    func endTimeOfFunctionView(functionView: FunctionView) -> Double
    func pointOfFunctionView(functionView: FunctionView, atTime time: Double) -> Posicion
}


@IBDesignable
class FunctionView: UIView {
    
    @IBInspectable
    var lineWidth : Double = 3.0
    
    @IBInspectable
    var functionColor : UIColor = UIColor.redColor()
    
    let resolucion = 500.0
    
    var escalaX : Double = 0.05 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    var escalaY : Double = 0.05 {
        didSet{
            setNeedsDisplay()
        }
    }
    
#if TARGET_INTERFACE_BUILDER
    var dataSource: FunctionViewDataSource!
#else
    weak var dataSource: FunctionViewDataSource!
#endif
    
    override func prepareForInterfaceBuilder() {
        
        class FakeDataSource : FunctionViewDataSource {
            
            func startTimeOfFunctionView(functionView: FunctionView) -> Double  {return 0.0}
            
            func endTimeOfFunctionView(functionView: FunctionView) -> Double {return 200.0}
            
            func pointOfFunctionView(functionView: FunctionView, atTime time: Double) -> Posicion {
                return Posicion(x: time, y: time%50)
            }
        }
        
        dataSource = FakeDataSource()
    }
    
    override func drawRect(rect: CGRect) {
        drawAxis()
        drawFunction()
    }
    
    private func drawAxis(){
        let ancho = bounds.size.width
        let alto = bounds.size.height
        
        let vertical = UIBezierPath()
        vertical.moveToPoint(CGPointMake(ancho/2, 0))
        vertical.addLineToPoint(CGPointMake(ancho/2, alto))
        
        let horizontal = UIBezierPath()
        horizontal.moveToPoint(CGPointMake(0, alto/2))
        horizontal.addLineToPoint(CGPointMake(ancho, alto/2))
        
        UIColor.blackColor().setStroke()
        vertical.lineWidth = 1
        vertical.stroke()
        
        horizontal.lineWidth = 1
        horizontal.stroke()
        
    }
    
    private func drawFunction(){
        
        let startTime = dataSource.startTimeOfFunctionView(self)
        let endTime = dataSource.endTimeOfFunctionView(self)
        let incrTime = max((endTime - startTime) / resolucion , 0.005)
        
        let path = UIBezierPath()
        
        var point = dataSource.pointOfFunctionView(self, atTime: startTime)
        var px = pointForX(point.x)
        var py = pointForY(point.y)
        path.moveToPoint(CGPointMake(px, py))
        
        for var t = startTime ; t < endTime ; t += incrTime {
            point = dataSource.pointOfFunctionView(self, atTime: t)
            px = pointForX(point.x)
            py = pointForY(point.y)
            path.addLineToPoint(CGPointMake(px, py))
        }
        
        path.lineWidth = CGFloat(lineWidth)
        
        functionColor.set()
        
        path.stroke()
        
        
    }
    
    private func pointForX(abscisa: Double) -> CGFloat{
        let ancho = bounds.size.width
        return ancho/2 + CGFloat(abscisa/escalaX)
    }
    private func pointForY(ordenada: Double) -> CGFloat{
        let alto = bounds.size.height
        return alto/2 - CGFloat(ordenada/escalaY)
    }
    
    
    
}
    