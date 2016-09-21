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
//    var clusteredAnnotations: [AnyObject] = []
    
    var annotationsToRemove: [AnyObject] = []
    var annotationsToDisplay: [AnyObject] = []
    
//    func cluster(annotations:[AnyObject]?) -> [AnyObject]? {
//        guard let currentAnnotations = annotations , currentAnnotations.count > 1 else {
//            return annotations
//        }
//        
//        clusteredAnnotations.removeAll()
//        
//        for i in 0...currentAnnotations.count - 2 {
//            if clusteredAnnotations.contains(where: { (annotationToRemove) -> Bool in
//                currentAnnotations[i].isEqual(annotationToRemove)
//            }) {
//                print("------ pin already removed ------")
//            } else {
//                for j in i+1...currentAnnotations.count - 1 {
//                    
//                    let rectSize = MKMapSize(width: 100000, height: 100000)
//                    guard let annotaion1 = currentAnnotations[i] as? MKAnnotation, let annotation2 = currentAnnotations[j] as? MKAnnotation else {
//                        return nil
//                    }
//                    
//                    let rect1 = MKMapRect(origin: MKMapPointForCoordinate(annotaion1.coordinate), size: rectSize)
//                    let rect2 = MKMapRect(origin: MKMapPointForCoordinate(annotation2.coordinate), size: rectSize)
//                    
//                    if MKMapRectIntersectsRect(rect1, rect2) {
//                        clusteredAnnotations.append(currentAnnotations[j])
//                    }
//                }
//            }
//        }
//        print("===== remove annotations = \(clusteredAnnotations.count)")
//        return clusteredAnnotations
//    }
    func cluster(annotations:[AnyObject]?, fromMap map:MKMapView) -> ([AnyObject]?,[AnyObject]?) {
        guard let currentAnnotations = annotations , currentAnnotations.count > 1 else {
            return (annotations,nil)
        }
        
        annotationsToRemove.removeAll()
        annotationsToDisplay.removeAll()
        
        for (_, annotation) in currentAnnotations.enumerated() {
            if annotationsToRemove.contains(where: { (annotationToRemove) -> Bool in
                annotation.isEqual(annotationToRemove)
            }) {
                print("------ pin already removed ------")
                continue
            } else {
                
                let rectSize = MKMapSize(width: 1000, height: 1000)
                guard let annotaion1 = annotation as? MKAnnotation else {
                    return (nil,nil)
                }
                
                let rect1 = MKMapRect(origin: MKMapPointForCoordinate(annotaion1.coordinate), size: rectSize)
                let clusteredAnnotations = map.annotations(in: rect1)
                annotationsToRemove.append(clusteredAnnotations as AnyObject)
                annotationsToDisplay.append(annotation)
            }
        }
        
        print("===== remove annotations = \(annotationsToRemove.count) annotations to display = \(annotationsToDisplay.count)")
        return (annotationsToDisplay,annotationsToRemove)
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

