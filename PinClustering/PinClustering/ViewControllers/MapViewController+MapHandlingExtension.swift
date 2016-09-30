//
//  MapViewController+MapHandlingExtension.swift
//  PinClustering
//
//  Created by Norbert Agoston on 13/09/16.
//  Copyright © 2016 Norbert Agoston. All rights reserved.
//

import Foundation
import MapKit

extension MapViewController: MKMapViewDelegate {
    
    func setupMap(_ pointsOfInterest: [Location]) {
        guard let pointOfInterest = pointsOfInterest.first else {
            return
        }
        
        centerMapOnLocation(pointOfInterest.coordinate)
        displayOnMap(pointsOfInterest)
        ClusteringManager.sharedInstance.load(locations: pointsOfInterest, forMap: map)
    }
    
    func displayOnMap(_ pointsOfInterest: [Location]?) {
        if let pointsOfInterest = pointsOfInterest {
            map.addAnnotations(pointsOfInterest)
        }
    }
    
    func centerMapOnLocation(_ coordinate: CLLocationCoordinate2D) {
        let regionRadius: CLLocationDistance = 50000
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        map.setRegion(coordinateRegion, animated: true)
        currentZoomLevel = getZoomLevel()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        print("----- View for annotation")
        guard let annotation = annotation as? FuelLocation else {
            return nil
        }
        
        let identifier = "pin"
        var view: MKPinAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type:.detailDisclosure) as UIView
        }
        
        return view
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated: Bool) {
        print("region Will Change")
        temporaryPointsOfInterest.removeAll()
        if let visibleAnnotations = visibleAnnotations() {
            temporaryPointsOfInterest = visibleAnnotations
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated: Bool) {
        print("region Did Change")
//
//        guard let clusteredAnnotations = ClusteringManager.sharedInstance.cluster(annotations: temporaryPointsOfInterest, mapZoomLevel: getZoomLevel()) else {
//            return
//        }
//        mapView.removeAnnotations(mapView.annotations)
//        print("++++ added annotations = \(clusteredAnnotations.count)")
//        mapView.addAnnotations(clusteredAnnotations)
        //test
        DispatchQueue.global().async {
            let mapBoundsWidth = Double(mapView.bounds.size.width)
            let mapRectWidth:Double = mapView.visibleMapRect.size.width
            let scale:Double = mapBoundsWidth / mapRectWidth
            guard let clusteredAnnotations = ClusteringManager.sharedInstance.clusteredAnnotations(withinMapRect: mapView.visibleMapRect, withZoomScale: scale) else {
                return
            }
            self.update(mapView: mapView, withAnnotations: clusteredAnnotations)
//            dispatch_async(dispatch_get_main_queue()) {
//                // update some UI
//            }
        }

        //endTest
    }
    
    func update(mapView: MKMapView?, withAnnotations annotations: [Location]?) {
        guard let annotations = annotations, let mapView = mapView else {
            return
        }
        let before: Set = mapView.annotations as? [Location]
    }
    
    func visibleAnnotations() -> [Location]? {
        var annotations = [Location]()
        for (_, annotation)  in pointsOfInterest.enumerated() {
            if MKMapRectContainsPoint(map.visibleMapRect, MKMapPointForCoordinate(annotation.coordinate)) {
               annotations.append(annotation)
            }
        }
        return annotations
    }
    
    func getZoomLevel() -> Double {
        let MERCATOR_RADIUS = 85445659.44705395
        let MAX_GOOGLE_LEVELS = 20.0
        let longitudeDelta = map.region.span.longitudeDelta
        let mapWidthInPixels = map.bounds.size.width
        
        let zoomScale = longitudeDelta * MERCATOR_RADIUS * M_PI / Double(180.0 * mapWidthInPixels)
        var zoomer = MAX_GOOGLE_LEVELS - log2( zoomScale )
        if zoomer < 0.0 {
            zoomer = 0
        }
        zoomer = round(zoomer)
        print("Zoom Level = \(zoomer)")
        return zoomer
    }
}
