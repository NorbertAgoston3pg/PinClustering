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
    
    func setupMap(_ pointsOfInterest: [AnyObject]) {
        guard let pointOfInterest = pointsOfInterest.first as? FuelLocation else {
            return
        }
        
        centerMapOnLocation(pointOfInterest.coordinate)
        displayOnMap(pointsOfInterest)
    }
    
    func displayOnMap(_ pointsOfInterest: [AnyObject]) {
        if let pointsOfInterest = pointsOfInterest as? [FuelLocation] {
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
        print("----- View for annotation")
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
        
//        print("Zoom = \(getZoomLevel())")
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated: Bool) {
        print("region Did Change")

        let (ann1,ann2) = ClusteringManager.sharedInstance.cluster(annotations: temporaryPointsOfInterest, fromMap: map)
        guard let annotationsToDisplay = ann1 as? [MKAnnotation], let annotationsToRemove = ann2 as? [MKAnnotation] else {
            return
        }
            
            let newZoomLevel = getZoomLevel()
            if currentZoomLevel < getZoomLevel() {
                print("zoom In")
                mapView.addAnnotations(annotationsToDisplay as [MKAnnotation])
            } else {
                mapView.removeAnnotations(annotationsToRemove as [MKAnnotation])
            }
            currentZoomLevel = newZoomLevel
        
        
        print("Zoom = \(currentZoomLevel)")
    }
    
    func visibleAnnotations() -> [AnyObject]? {
        var annotations = [AnyObject]()
        for (_, value)  in pointsOfInterest.enumerated() {
            guard let annotation = value as? MKAnnotation else {
                return nil 
            }
            if MKMapRectContainsPoint(map.visibleMapRect, MKMapPointForCoordinate(annotation.coordinate)) {
               annotations.append(value)
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
//        zoomer = round(zoomer)
        return zoomer
    }
}
