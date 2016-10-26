//
//  ClusteringManager.swift
//  PinClustering
//
//  Created by Norbert Agoston on 16/09/16.
//  Copyright © 2016 Norbert Agoston. All rights reserved.
//

import MapKit

class ClusteringManager {
    
    var quadTree: QuadTree<Location> = QuadTree(boundary: MKMapRect())
    
    func clusteredAnnotations(withinMapView mapView:MKMapView, withZoomScale zoomScale: Double) -> [Location]? {
        let mapRect = mapView.visibleMapRect
        
        quadTree.boundary = mapRect
        let cellSize = calculateCellSize(forZoomScale: zoomScale)
        let scaleFactor =  zoomScale / cellSize
        
        let minX = Int(floor(MKMapRectGetMinX(mapRect) * scaleFactor))
        let maxX = Int(floor(MKMapRectGetMaxX(mapRect) * scaleFactor))
        let minY = Int(floor(MKMapRectGetMinY(mapRect) * scaleFactor))
        let maxY = Int(floor(MKMapRectGetMaxY(mapRect) * scaleFactor))
        
//        print("minX = \(minX) maxX = \(maxX) minY = \(minY) maxY = \(maxY) visibleMapRect = \(mapRect)")
        
        var clusteredAnnotations = [Location]()
        for x in minX...maxX {
            for y in minY...maxY {
                let rect = MKMapRectMake(Double(x) / scaleFactor, Double(y) / scaleFactor, 1.0 / scaleFactor, 1.0 / scaleFactor)
                
                print("queryRect = \(rect) \n visibleRect = \(mapRect)")
                //test
//                let topLeft = MKCoordinateForMapPoint(rect.origin)
//                let botRight = MKCoordinateForMapPoint(MKMapPointMake(MKMapRectGetMaxX(rect), MKMapRectGetMaxY(rect)))
//                
//                let minLat = botRight.latitude;
//                let maxLat = topLeft.latitude;
//                
//                let minLon = topLeft.longitude;
//                let maxLon = botRight.longitude;
                //endtest
                
                let quadElements = quadTree.queryElements(insideArea: rect)
                let count = Double(quadElements.count)
                
                print("----------\(count) elements found in Area \(rect)------")
                
//                let (totalX, totalY) = quadElements.reduce((0.0,0.0), { (acc: (Double,Double), obj: (Location, MKMapPoint)) -> (Double,Double) in
//                    let (_, position): (Location, MKMapPoint) = obj
//                    return (acc.0 + Double(position.x), acc.1 + Double(position.y))
//                })
                
                if count > 1 {
//                    let coordinate = CLLocationCoordinate2DMake(totalX / count, totalY / count)
                    let clusterAnnotation = Location(title: "\(count)", subtitle: "", coordinate: (quadElements.first?.0.coordinate)!)
                    print("clustered Annotation: \(quadElements.first?.0.coordinate)")
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
        print("Zoom Level = \(zoomLevel)")
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
    
    func load(locations:[Location]?) {
        guard let locations = locations else {
            return
        }
        print("locations Count = \(locations.count)")
        for location in locations {
            print("originalLocation = \(location.coordinate)")
            quadTree.insert(element: location, atPoint: MKMapPointForCoordinate(location.coordinate))
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

