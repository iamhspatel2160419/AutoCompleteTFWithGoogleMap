//
//  ViewController.swift
//  googleMap
//
//  Created by hp ios on 3/14/18.
//  Copyright © 2018 andiosdev. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
class ViewController: UIViewController,UISearchBarDelegate,LocateOnTheMap,GMSAutocompleteFetcherDelegate {
  
   
    

    @IBOutlet weak var googleMapView: UIView!
    

    var googleMapsView: GMSMapView!
    var searchResultController: SearchResultsController!
    var resultsArray = [String]()
    var gmsFetcher: GMSAutocompleteFetcher!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        
        self.googleMapsView = GMSMapView(frame: self.googleMapView.frame)
        self.googleMapView.addSubview(googleMapsView)
        
        searchResultController = SearchResultsController()
        searchResultController.delegate = self
        
        gmsFetcher = GMSAutocompleteFetcher()
        gmsFetcher.delegate = self
        
        
    }
    /**
     action for search location by address
     
     - parameter sender: button search location
     */
    @IBAction func searchVC(_ sender: Any)
    {
        let searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchBar.delegate = self
        self.present(searchController, animated:true, completion: nil)
        
    }
    /**
     Locate map with longitude and longitude after search location on UISearchBar
     
     - parameter lon:   longitude location
     - parameter lat:   latitude location
     - parameter title: title of address location
     */
    func locateWithLongitude(_ lon: Double, andLatitude lat: Double, andTitle title: String) {
        
        DispatchQueue.main.async {
            () -> Void in
            
            let position = CLLocationCoordinate2DMake(lat, lon)
            let marker = GMSMarker(position: position)
            
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: 10)
            self.googleMapsView.camera = camera
            
            marker.title = "Address : \(title)"
            marker.map = self.googleMapsView
            
        }
        
    }
    /**
     Searchbar when text change
     
     - parameter searchBar:  searchbar UI
     - parameter searchText: searchtext description
     */
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
         self.resultsArray.removeAll()
         gmsFetcher?.sourceTextHasChanged(searchText)
    }
    /**
     * Called when autocomplete predictions are available.
     * @param predictions an array of GMSAutocompletePrediction objects.
     */
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        
        //self.resultsArray.count + 1
        
        for prediction in predictions {
            
            if let prediction = prediction as GMSAutocompletePrediction!{
                self.resultsArray.append(prediction.attributedFullText.string)
            }
        }
        self.searchResultController.reloadDataWithArray(self.resultsArray)
        //   self.searchResultsTable.reloadDataWithArray(self.resultsArray)
        print(resultsArray)
        
    }
    /**
     * Called when an autocomplete request returns an error.
     * @param error the error that was received.
     */
    func didFailAutocompleteWithError(_ error: Error)
    {
        
    }
    
    
    
}

