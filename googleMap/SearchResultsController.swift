//
//  SearchResultsController.swift
//  googleMap
//
//  Created by hp ios on 3/14/18.
//  Copyright © 2018 andiosdev. All rights reserved.
//

import Foundation
import UIKit

protocol LocateOnTheMap{
    func locateWithLongitude(_ lon:Double, andLatitude lat:Double, andTitle title: String)
}
class SearchResultsController:UITableViewController
{
    
    var searchResults:[String]!
    var delegate : LocateOnTheMap!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchResults = Array()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "maptableviewcell")
    }
   
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "maptableviewcell", for: indexPath)
      cell.textLabel?.text = searchResults[indexPath.row]
      return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.dismiss(animated: true, completion: nil)
        let urlpath = "https://maps.googleapis.com/maps/api/geocode/json?address=\(self.searchResults[indexPath.row])&sensor=false".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
         let url = URL(string: urlpath!)
        
        let task = URLSession.shared.dataTask(with: (url)!)
        {
            (data, response, error) in
            
            print(data!)
            
            do
            {
               if data != nil
               {
               let dic = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! NSDictionary
                
                 let lat =   (((((dic.value(forKey: "results") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "geometry") as! NSDictionary).value(forKey: "location") as! NSDictionary).value(forKey: "lat")) as! Double
                
                let lon =   (((((dic.value(forKey: "results") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "geometry") as! NSDictionary).value(forKey: "location") as! NSDictionary).value(forKey: "lng")) as! Double
                
                 self.delegate.locateWithLongitude(lon, andLatitude: lat, andTitle: self.searchResults[indexPath.row])
               }
                
            }catch let error
            {
                print(error)
            }
            
            
        }
        task.resume()
        
    }
    func reloadDataWithArray(_ array:[String]){
        self.searchResults = array
        self.tableView.reloadData()
    }
    
    
}
