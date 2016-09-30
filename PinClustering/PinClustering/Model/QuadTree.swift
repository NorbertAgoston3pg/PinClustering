//
//  QuadTree.swift
//  PinClustering
//
//  Created by Norbert Agoston on 28/09/16.
//  Copyright © 2016 Norbert Agoston. All rights reserved.
//

import UIKit

class QuadTree <T> {
    
    // Typealias for an element inside the quad tree node
    typealias QuadElement = (T, CGPoint)
    
    // Arbitrary constant to indicate how many elements can be stored in this quad tree node
    let nodeCapacity = 4
    
    // The frame of this quad tree
    let boundary: CGRect
    
    // Elements in this quad tree node
    var quadElements = [QuadElement]()
    
    //Children
    var northWest: QuadTree?
    var northEast: QuadTree?
    var southWest: QuadTree?
    var southEast: QuadTree?
    
    var children = [QuadTree]()
    
    init(boundary: CGRect) {
        self.boundary = boundary
    }
    
    @discardableResult
    func insert(quadElement: T?, atPoint point: CGPoint?) -> Bool {
        guard let quadElement = quadElement, let point = point else {
            return false
        }
        // Ignore objects that do not belong in this quad tree
        if !boundary.contains(point) {
            return false
        }
        
        // If there is space in this quad tree, add the object here
        if quadElements.count < nodeCapacity {
            quadElements.append(quadElement, point)
            return true
        }
        
        // Otherwise, subdivide and then add the object to whichever node will accept it
        if northWest == nil {
            subdivide()
        }
        
        for child in children {
            if add(quadElement: quadElement, toQuadTreeChild: child, atPoint: point) {
                return true
            }
        }
        
        return false
    }
    
//    func queryElements(insideArea area: CGRect) -> [T] {
    func queryElements(insideArea area: CGRect) -> [QuadElement] {
//        var elementsInRegion = [T]()
        var elementsInRegion = [QuadElement]()
        
        // Automatically abort if the range does not intersect this quad
        if !boundary.intersects(area) {
            return elementsInRegion
        }
        
        // Check quadElements at this quad leve
        for (quadElement, point) in quadElements {
            if area.contains(point) {
                elementsInRegion.append(quadElement, point)
            }
        }
        
        //If there are no children, stop here
        if northWest == nil {
            return elementsInRegion
        }
        
        //Otherwise add the quad elements from the children
        for child in children {
            elementsInRegion += child.queryElements(insideArea: area)
        }
        
        return elementsInRegion
    }
    
    func subdivide() {
        let size = CGSize(width: boundary.width/2.0, height: boundary.height/2.0)
        
        northWest = QuadTree(boundary: CGRect(origin: CGPoint(x: boundary.minX, y: boundary.minY), size: size))
        northEast = QuadTree(boundary: CGRect(origin: CGPoint(x: boundary.midX, y: boundary.minY), size: size))
        southWest = QuadTree(boundary: CGRect(origin: CGPoint(x: boundary.minX, y: boundary.midY), size: size))
        southEast = QuadTree(boundary: CGRect(origin: CGPoint(x: boundary.midX, y: boundary.midY), size: size))
        
        if let northWest = northWest, let northEast = northEast,
            let southWest = southWest, let southEast = southEast {
            
            children.append(northWest)
            children.append(northEast)
            children.append(southWest)
            children.append(southEast)
        }
    }
    
    private func add(quadElement: T?, toQuadTreeChild child:QuadTree?, atPoint point: CGPoint?) -> Bool {
        guard let child = child, let quadElement = quadElement, let point = point else {
            return false
        }
        
        return child.insert(quadElement: quadElement, atPoint: point)
    }
}
