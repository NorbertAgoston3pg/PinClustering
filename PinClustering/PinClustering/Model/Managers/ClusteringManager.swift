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
    var quadTree: QuadTree<Location> = QuadTree(boundary: CGRect.zero)
    //    var annotationsToRemove: [Location] = []
//
//    func cluster(annotations:[Location]?, mapZoomLevel: Double?) -> [Location]? {
//        guard let currentAnnotations = annotations , currentAnnotations.count > 1, let mapZoomLevel = mapZoomLevel else {
//            return annotations
//        }
//        
//        annotationsToRemove.removeAll()
//        
//        for (_, annotation) in currentAnnotations.enumerated() {
//            if annotationsToRemove.contains(where: { (annotationToRemove) -> Bool in
//                annotation.isEqual(annotationToRemove)
//            }) {
////                print("------ pin already removed ------")
//                continue
//            } else {
//                let zoomExponent = 20 - mapZoomLevel
//                let zoomScale = pow(2, zoomExponent)
//                let rectSize = MKMapSize(width: 10 * zoomScale, height: 10 * zoomScale)
//                print("rect size = \(rectSize) at zoomLevel = \(mapZoomLevel)")
//                let rect1 = MKMapRect(origin: MKMapPointForCoordinate(annotation.coordinate), size: rectSize)
//                
//                let filteredArray = currentAnnotations.filter() {
//                    let rect2 = MKMapRect(origin: MKMapPointForCoordinate($0.coordinate), size: rectSize)
//                    return $0 !== annotation && MKMapRectIntersectsRect(rect1, rect2)
//                }
//                
//                annotationsToRemove.append(contentsOf: filteredArray)
//            }
//        }
//        print("===== currentAnnotations = \(currentAnnotations.count)")
//        print("----- remove annotations = \(annotationsToRemove.count)")
//
//        return currentAnnotations.filter { !annotationsToRemove.contains($0) }
//    }
    
    func clusteredAnnotations(withinMapRect mapRect:MKMapRect, withZoomScale zoomScale: Double) -> [Location]? {
        let cellSize = calculateCellSize(forZoomScale: zoomScale)
        let scaleFactor =  zoomScale / cellSize
        
        let minX = Int(floor(MKMapRectGetMinX(mapRect) * scaleFactor))
        let maxX = Int(floor(MKMapRectGetMaxX(mapRect) * scaleFactor))
        let minY = Int(floor(MKMapRectGetMinY(mapRect) * scaleFactor))
        let maxY = Int(floor(MKMapRectGetMaxY(mapRect) * scaleFactor))
        
        var clusteredAnnotations = [Location]()
        
        for x in minX...maxX {
            for y in minY...maxY {
                let mapRect = CGRect(x: Double(x) / scaleFactor, y: Double(y) / scaleFactor, width: 1.0 / scaleFactor, height: 1.0 / scaleFactor)
                
                let quadElements = quadTree.queryElements(insideArea: mapRect)
                let count = Double(quadElements.count)
                
                let (totalX, totalY) = quadElements.reduce((0.0,0.0), { (acc: (Double,Double), obj: (Location, CGPoint)) -> (Double,Double) in
                    let (_, position): (Location, CGPoint) = obj
                    return (acc.0 + Double(position.x), acc.1 + Double(position.y))
                })
                
                if count >= 1 {
                    let coordinate =  CLLocationCoordinate2D(latitude: totalX / count, longitude: totalY / count)
                    let clusterAnnotation = ClusterAnnotaion(title: "\(count)", subtitle: "", coordinate: coordinate)
                    clusteredAnnotations.append(clusterAnnotation)
                }
            }
        }
        return clusteredAnnotations
    }
    
    func zoomScaleToZoomLevel(scale: Double) -> Double {
        let totalTilesAtMaxZoom = MKMapSizeWorld.width / 256.0
        let zoomLevelAtMaxZoom = log2(totalTilesAtMaxZoom)
        let zoomLevel = max(0, zoomLevelAtMaxZoom + floor(log2(scale) + 0.5))
        return zoomLevel
    }
    
    func calculateCellSize(forZoomScale zoomScale: Double) -> Double {
        let zoomLevel = zoomScaleToZoomLevel(scale: zoomScale)
        switch zoomLevel {
        case 13, 14, 15:
            return 64
        case 16, 17, 18:
            return 32
        case 19:
            return 16
        default:
            return 88
        }
    }
    
    func load(locations:[Location]?, forMap map:MKMapView?) {
        guard let locations = locations , let map = map else {
            return
        }
        for location in locations {
            let pointOnMap = map.convert(location.coordinate, toPointTo: map)
            quadTree.insert(quadElement: location, atPoint: pointOnMap)
        }
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

