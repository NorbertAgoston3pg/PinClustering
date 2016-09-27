//
//  ClusteringManager.swift
//  PinClustering
//
//  Created by Norbert Agoston on 16/09/16.
//  Copyright © 2016 Norbert Agoston. All rights reserved.
//

import UIKit
import MapKit

class ClusteringManager: NSObject {
    
    static let sharedInstance = ClusteringManager()
    var annotationsToRemove: [Location] = []

    func cluster(annotations:[Location]?, mapZoomLevel: Double?) -> [Location]? {
        guard let currentAnnotations = annotations , currentAnnotations.count > 1, let mapZoomLevel = mapZoomLevel else {
            return annotations
        }
        
        annotationsToRemove.removeAll()
        
        for (_, annotation) in currentAnnotations.enumerated() {
            if annotationsToRemove.contains(where: { (annotationToRemove) -> Bool in
                annotation.isEqual(annotationToRemove)
            }) {
//                print("------ pin already removed ------")
                continue
            } else {
                let zoomExponent = 20 - mapZoomLevel
                let zoomScale = pow(2, zoomExponent)
                let rectSize = MKMapSize(width: 10 * zoomScale, height: 10 * zoomScale)
                print("rect size = \(rectSize) at zoomLevel = \(mapZoomLevel)")
                let rect1 = MKMapRect(origin: MKMapPointForCoordinate(annotation.coordinate), size: rectSize)
                
                let filteredArray = currentAnnotations.filter() {
                    let rect2 = MKMapRect(origin: MKMapPointForCoordinate($0.coordinate), size: rectSize)
                    return $0 !== annotation && MKMapRectIntersectsRect(rect1, rect2)
                }
                
                annotationsToRemove.append(contentsOf: filteredArray)
            }
        }
        print("===== currentAnnotations = \(currentAnnotations.count)")
        print("----- remove annotations = \(annotationsToRemove.count)")

        return currentAnnotations.filter { !annotationsToRemove.contains($0) }
    }
}

extension MKAnnotation {
    static func ==(lhs: MKAnnotation, rhs: MKAnnotation) -> Bool {
        guard let lhsTitle = lhs.title, let rhsTitle = rhs.title else {
            return false
        }
        
        return lhsTitle == rhsTitle
    }
}

