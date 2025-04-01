//
//  LocationManager.swift
//  GPSVoiceApp Techcase
//
//  Created by Jasmin Hachmane on 01/04/2025.
//

import Foundation
import MapKit
import CoreLocation
import AVFoundation

// LocationManager beheert de locatie-updates en spraakfeedback
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager() // Instantie van CLLocationManager voor locatie-updates
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 52.3702, longitude: 4.8952), // Amsterdam als startpunt
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01) // Zoomniveau van de kaart
    )
    
    @Published var totalDistance: Double = 0.0 // Houdt de totaal afgelegde afstand bij
    private var previousLocation: CLLocation? // Slaat de vorige locatie op om afstand te berekenen
    private let speechSynthesizer = AVSpeechSynthesizer() // Spraakondersteuning voor feedback

    override init() {
        super.init()
        locationManager.delegate = self // Stel deze klasse in als de delegate
        locationManager.requestWhenInUseAuthorization() // Vraag toestemming voor locatietoegang
        locationManager.startUpdatingLocation() // Start het volgen van locatie-updates
    }

    // Functie die wordt aangeroepen wanneer de locatie verandert
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return } // Zorg ervoor dat er een nieuwe locatie is

        DispatchQueue.main.async {
            self.region.center = newLocation.coordinate // Update de kaartpositie met de nieuwe locatie
        }

        // Bereken de afgelegde afstand sinds de vorige locatie
        if let previousLocation = previousLocation {
            let distance = newLocation.distance(from: previousLocation) // Bereken de afstand in meters
            totalDistance += distance // Voeg de afstand toe aan het totaal
            
            if self.totalDistance >= 5.0 { // Controleer of er minstens 5 meter is afgelegd
                self.speakDistance() // Spreek de afstand uit via spraak
                self.totalDistance = 0.0 // Reset de teller na het uitspreken
            }
        }

        previousLocation = newLocation // Sla de nieuwe locatie op als de vorige locatie voor de volgende meting
    }

    // Functie om de gebruiker spraakfeedback te geven over de afgelegde afstand
    private func speakDistance() {
        let message = "Je hebt 5 meter gereisd." // Bericht dat wordt uitgesproken
        let utterance = AVSpeechUtterance(string: message)
        utterance.voice = AVSpeechSynthesisVoice(language: "nl-NL") // Gebruik een Nederlandse stem
        speechSynthesizer.speak(utterance) // Start de spraakuitvoer
    }
}
