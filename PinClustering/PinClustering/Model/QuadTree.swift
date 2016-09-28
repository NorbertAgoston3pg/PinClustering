//
//  QuadTree.swift
//  PinClustering
//
//  Created by Norbert Agoston on 28/09/16.
//  Copyright © 2016 Norbert Agoston. All rights reserved.
//

import UIKit

class QuadTree <T> {
    
    // Typealias for an object inside the quad tree node
    typealias Object = (T, CGPoint)
    
    // Arbitrary constant to indicate how many objects can be stored in this quad tree node
    let nodeCapacity = 4
    
    // The frame of this quad tree
    let boundary: CGRect
    
    // Objects in this quad tree node
    var objects = [Object]()
    
    //Children
    var northWest: QuadTree?
    var northEast: QuadTree?
    var southWest: QuadTree?
    var southEast: QuadTree?
    
    var children = [QuadTree]()
    
    init(boundary: CGRect) {
        self.boundary = boundary
    }
    
    func insert(object: T?, atPoint point: CGPoint?) -> Bool {
        guard let object = object, let point = point else {
            return false
        }
        // Ignore objects that do not belong in this quad tree
        if !boundary.contains(point) {
            return false
        }
        
        // If there is space in this quad tree, add the object here
        if objects.count < nodeCapacity {
            objects.append(object, point)
            return true
        }
        
        // Otherwise, subdivide and then add the object to whichever node will accept it
        if northWest == nil {
            subdivide()
        }
        
        for child in children {
            if add(object: object, toQuadTreeChild: child, atPoint: point) {
                return true
            }
        }
        
        return false
    }
    
    func queryRegion(region: CGRect) -> [T] {
        var objectsInRegion = [T]()
        
        // Automatically abort if the range does not intersect this quad
        if !boundary.intersects(region) {
            return objectsInRegion
        }
        
        // Check objects at this quad leve
        for (object, point) in objects {
            if region.contains(point) {
                objectsInRegion.append(object)
            }
        }
        
        //If there are no children, stop here
        if northWest == nil {
            return objectsInRegion
        }
        
        //Otherwise add the points from the children
        for child in children {
            objectsInRegion += child.queryRegion(region: region)
        }
        
        return objectsInRegion
    }
    
    func subdivide() {
        let size = CGSize(width: boundary.width/2.0, height: boundary.height/2.0)
        
        northWest = QuadTree(boundary: CGRect(origin: CGPoint(x: boundary.minX, y: boundary.minY), size: size))
        northEast = QuadTree(boundary: CGRect(origin: CGPoint(x: boundary.midX, y: boundary.minY), size: size))
        southWest = QuadTree(boundary: CGRect(origin: CGPoint(x: boundary.minX, y: boundary.midY), size: size))
        southEast = QuadTree(boundary: CGRect(origin: CGPoint(x: boundary.midX, y: boundary.midY), size: size))
    }
    
    func add(object: T?, toQuadTreeChild child:QuadTree?, atPoint point: CGPoint?) -> Bool {
        guard let child = child, let object = object, let point = point else {
            return false
        }
        
        return child.insert(object: object, atPoint: point)
    }
}
