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
//        displayOnMap(pointsOfInterest)
        clusteringManager.load(locations: pointsOfInterest)
        clusteringManager.quadTree.traverseQuadTree()
        
    }
    
//    func displayOnMap(_ pointsOfInterest: [Location]?) {
//        if let pointsOfInterest = pointsOfInterest {
//            map.addAnnotations(pointsOfInterest)
//        }
//    }
    
    //test
//    func setZoomLevel(zoomLevel:Int, at coordinate:CLLocationCoordinate2D) {
//        setCenterCoordinate:self.centerCoordinate zoomLevel:zoomLevel animated:NO];
//    }
//    
//    func zoomLevel {
//    return log2(360 * ((self.frame.size.width/256) / self.region.span.longitudeDelta)) + 1;
//    }
//    
//    - (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
//    zoomLevel:(NSUInteger)zoomLevel animated:(BOOL)animated {
//    MKCoordinateSpan span = MKCoordinateSpanMake(0, 360/pow(2, zoomLevel)*self.frame.size.width/256);
//    [self setRegion:MKCoordinateRegionMake(centerCoordinate, span) animated:animated];
//    }
    //endTest
    
    func centerMapOnLocation(_ coordinate: CLLocationCoordinate2D) {
        let regionRadius: CLLocationDistance = 5000000
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        map.setRegion(coordinateRegion, animated: false)
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
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated: Bool) {
        print("region Did Change")

        DispatchQueue.global().async { [weak self] in
            let mapBoundsWidth = Double(mapView.bounds.size.width)
            let mapRectWidth:Double = mapView.visibleMapRect.size.width
            let scale:Double = mapBoundsWidth / mapRectWidth
            guard let clusteredAnnotations = self?.clusteringManager.clusteredAnnotations(withinMapView: mapView, withZoomScale: scale) else {
                return
            }
            self?.update(mapView: mapView, withAnnotations: clusteredAnnotations)
        }
    }
    
    func update(mapView: MKMapView?, withAnnotations annotations: [Location]?) {
        guard let annotations = annotations, let mapView = mapView, let mapViewAnnotations = mapView.annotations as? [Location] else {
            return
        }
        
        let before = Set(mapViewAnnotations)
        let after = Set(annotations)
        
        var toKeep = before
        toKeep = toKeep.intersection(after)
        
        var toAdd = after
        toAdd = toAdd.subtracting(toKeep)
        
        var toRemove = before
        toRemove = toRemove.subtracting(after)
        
        DispatchQueue.main.async {
            self.map.addAnnotations(Array(toAdd))
            self.map.removeAnnotations(Array(toRemove))
        }
    }
}
