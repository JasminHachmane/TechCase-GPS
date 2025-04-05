import Foundation
import MapKit // Map
import CoreLocation
import AVFoundation

// LocationManager handles location updates and voice feedback
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager() // This gets the device's location
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 52.3702, longitude: 4.8952), // Starting point: Amsterdam
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01) // Zoom level for the map
    )
    
    @Published var totalDistance: Double = 0.0 // Keeps track of total distance traveled
    private var previousLocation: CLLocation? // Saves the last location to measure distance
    private let speechSynthesizer = AVSpeechSynthesizer() // Used to speak messages out loud

    override init() {
        super.init()
        locationManager.delegate = self // Set this class to handle location updates
        locationManager.requestWhenInUseAuthorization() // Ask for permission to use location
        locationManager.startUpdatingLocation() // Start getting location updates
    }

    // This function runs when the location changes
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }

        let distance = previousLocation?.distance(from: newLocation) ?? 0.0
        let updatedTotalDistance = totalDistance + distance

        if updatedTotalDistance >= 5.0 { // Speak every 5 meters
            speakDistance()
            previousLocation = newLocation // Save this as the new starting point
            DispatchQueue.main.async {
                self.totalDistance = 0.0
            }
        } else {
            DispatchQueue.main.async {
                self.totalDistance = updatedTotalDistance
            }
        }

        // Update the map position
        DispatchQueue.main.async {
            self.region.center = newLocation.coordinate
        }

        previousLocation = newLocation
    }

    // This function speaks a message about the distance traveled
    private func speakDistance() {
        let message = "Je hebt 5 meter gereisd." // Message that will be spoken
        let utterance = AVSpeechUtterance(string: message)
        utterance.voice = AVSpeechSynthesisVoice(language: "nl-NL") // Use a Dutch voice
        speechSynthesizer.speak(utterance) // Speak the message
    }
}

