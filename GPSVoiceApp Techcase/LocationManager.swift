import Foundation
import MapKit //Kaart
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
        guard let newLocation = locations.last else { return }

        let distance = previousLocation?.distance(from: newLocation) ?? 0.0
        let updatedTotalDistance = totalDistance + distance

        if updatedTotalDistance >= 5.0 { // Spreek elke 5 meter
            speakDistance()
            previousLocation = newLocation // Reset vorige locatie om nieuwe meting te starten
            DispatchQueue.main.async {
                self.totalDistance = 0.0
            }
        } else {
            DispatchQueue.main.async {
                self.totalDistance = updatedTotalDistance
            }
        }

        // Update kaartpositie
        DispatchQueue.main.async {
            self.region.center = newLocation.coordinate
        }

        previousLocation = newLocation
    }

    // Functie om de gebruiker spraakfeedback te geven over de afgelegde afstand
    private func speakDistance() {
        let message = "Je hebt 5 meter gereisd." // Bericht dat wordt uitgesproken
        let utterance = AVSpeechUtterance(string: message)
        utterance.voice = AVSpeechSynthesisVoice(language: "nl-NL") // Gebruik een Nederlandse stem
        speechSynthesizer.speak(utterance) // Start de spraakuitvoer
    }
}


