//
//  QuadTree.swift
//  PinClustering
//
//  Created by Norbert Agoston on 28/09/16.
//  Copyright © 2016 Norbert Agoston. All rights reserved.
//

import MapKit

class QuadTree <T> {
    
    // Typealias for an element inside the quad tree node
    typealias QuadElement = (T, MKMapPoint)
    
    // Arbitrary constant to indicate how many elements can be stored in this quad tree node
    let nodeCapacity = 4
    
    // The frame of this quad tree
    var boundary: MKMapRect
    
    //Quad Elements in this quad tree node
    var quadElements = [QuadElement]()
    
    //Children
    var northWest: QuadTree?
    var northEast: QuadTree?
    var southWest: QuadTree?
    var southEast: QuadTree?
    
    var children = [QuadTree]()
    
    var numberOfElements = 0
    
    init(boundary: MKMapRect) {
        self.boundary = boundary
    }
    
    deinit {
        print("deinit QuadTree")
    }
    
    @discardableResult
    func insert(element: T?, atPoint point: MKMapPoint?) -> Bool {
//        print("inserItem")
        guard let element = element, let point = point else {
            return false
        }
        // Ignore objects that do not belong in this quad tree
        if !MKMapRectContainsPoint(boundary, point) {
            print("not in the quad")
            return false
        }
        
        // If there is space in this quad tree, add the object here
        if quadElements.count < nodeCapacity {
            print("added")
            quadElements.append(element, point)
            return true
        }
        
        // Otherwise, subdivide and then add the object to whichever node will accept it
        if northWest == nil {
            subdivide()
        }
        
        for child in children {
            if add(element: element, toQuadTreeChild: child, atPoint: point) {
                return true
            }
        }
        
        return false
    }
    
    private func add(element: T?, toQuadTreeChild child:QuadTree?, atPoint point: MKMapPoint?) -> Bool {
        guard let child = child, let element = element, let point = point else {
            return false
        }
        
        return child.insert(element: element, atPoint: point)
    }
    
    func queryElements(insideArea area: MKMapRect) -> [QuadElement] {
        var elementsInRegion = [QuadElement]()
        
        // Automatically abort if the range does not intersect this quad
        if !MKMapRectIntersectsRect(boundary, area) {
            print("querry Fail - range does not intersect this quad")
            return elementsInRegion
        }
        
        // Check quadElements at this quad leve
        for (quadElement, point) in quadElements {
            if MKMapRectContainsPoint(area, point) {
                elementsInRegion.append(quadElement, point)
            }
        }
        
        //If there are no children, stop here
        if northWest == nil {
            print("querry - No children - return elements = \(elementsInRegion.count)")
            return elementsInRegion
        }
        
        //Otherwise add the quad elements from the children
        for (_, child) in children.enumerated() {
            elementsInRegion += child.queryElements(insideArea: area)
        }
        print("finished querry with elements = \(elementsInRegion.count)")
        return elementsInRegion
    }
    
    func subdivide() {
        let size = MKMapSize(width: boundary.size.width/2.0, height: boundary.size.height/2.0)
        print("subdivisionSize = \(size)")
        
        northWest = QuadTree(boundary: MKMapRect(origin: MKMapPoint(x: MKMapRectGetMinX(boundary), y: MKMapRectGetMinY(boundary)), size: size))
        northEast = QuadTree(boundary: MKMapRect(origin: MKMapPoint(x: MKMapRectGetMidX(boundary), y: MKMapRectGetMinY(boundary)), size: size))
        southWest = QuadTree(boundary: MKMapRect(origin: MKMapPoint(x: MKMapRectGetMinX(boundary), y: MKMapRectGetMidY(boundary)), size: size))
        southEast = QuadTree(boundary: MKMapRect(origin: MKMapPoint(x: MKMapRectGetMidX(boundary), y: MKMapRectGetMidY(boundary)), size: size))
        
        if let northWest = northWest, let northEast = northEast,
            let southWest = southWest, let southEast = southEast {
            
            children.append(northWest)
            children.append(northEast)
            children.append(southWest)
            children.append(southEast)
        }
    }
    
    func traverseQuadTree() {        
        for (location, _) in quadElements {
            print("item \(location)")
            numberOfElements += 1
        }
        
        if northWest == nil {
            return
        }
        
        for (_, child) in children.enumerated() {
            child.traverseQuadTree()
        }
        return
    }
}
