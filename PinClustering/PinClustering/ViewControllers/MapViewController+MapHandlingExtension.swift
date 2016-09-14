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
    
    func setupMap(pointsOfInterest: [AnyObject]) {
        guard let pointOfInterest = pointsOfInterest.first as? FuelLocation else {
            return
        }
        
        centerMapOnLocation(pointOfInterest.coordinate)
        displayOnMap(pointsOfInterest)
    }
    
    func displayOnMap(pointsOfInterest: [AnyObject]) {
        if let pointsOfInterest = pointsOfInterest as? [FuelLocation] {
            map.addAnnotations(pointsOfInterest)
        }
    }
    
    func centerMapOnLocation(coordinate: CLLocationCoordinate2D) {
        let regionRadius: CLLocationDistance = 50000
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        map.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? FuelLocation {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type:.DetailDisclosure) as UIView
            }
            return view
        }
        return nil
    }
}