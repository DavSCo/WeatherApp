//
//  ViewController.swift
//  WeatherApp
//
//  Created by David Cohen on 27/03/2017.
//  Copyright © 2017 David Cohen. All rights reserved.
//

import UIKit
import DarkSkyKit
import ForecastIO
import Alamofire
import MapKit

class ViewController: UIViewController, UITableViewDataSource, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var timezoneLabel: UILabel!
    
    var locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        //Geolocalisation 
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        
    }
    
   
    
    
    //UITableViewDataSource => Les functions vont gerer le TableView et indiquer l'enssemble des parametre du TableView telle que le nombre de row et les donnés à inserer dans notre cas les temperature heure par heure.
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 24 // Retourne 24 pour afficher les temperatures des 24 Heures de la journée Heure par Heure
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
      
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        
        let client = DarkSkyClient(apiKey: "Votre Key")
        client.units = .si
        client.language = .french
        client.getForecast(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!) { result in
            switch result {
            case .success(let forecast, let requestMetadata):
                
                // Pour afficher la liste des temperature heure par heure dans la console.
                
                for i in 0...24 //24 = 24H de la jourée mais pour afficher toutes les valeurs remplacer => forecast.hourly!.data.count à la place de 24
                {
                    print(forecast.hourly!.data[i].temperature!)
                }
                
                
                let tempInt:Int = Int((forecast.currently?.temperature!)!)
                self.tempLabel.text = "\(tempInt)\("°C")"
                
                self.timezoneLabel.text = "\(forecast.timezone)"
        
                cell.textLabel?.numberOfLines = 4 // Affiche plusieur ligne pour chaque Cell
                cell.textLabel?.text = "\("Time:") \(forecast.hourly!.data[indexPath.row].time) \("\n") \("Temperature : ") \(forecast.hourly!.data[indexPath.row].temperature!) \(" °C")" // Le resultat de la cellule est entre "\()" car c'est un type Int et la cell attend un String.
                
                
            case .failure(let error):
                print(error)
            }
        }
        
        
        return cell
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

