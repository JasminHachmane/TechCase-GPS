//
//  ContentView.swift
//  GPSVoiceApp
//
//  Created by Jasmin Hachmane on 27/03/2025.
//

import SwiftUI
import MapKit

// Main structure of the SwiftUI view
struct ContentView: View {
    // Create an instance of LocationManager to handle location updates
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        VStack {
            // Show a map with the user's location
            Map(coordinateRegion: $locationManager.region, showsUserLocation: true)
                .edgesIgnoringSafeArea(.all)
                .frame(height: 700)
                .padding(.bottom, 50)
            
            // Show the total distance traveled in meters
            Text("Afgelegde afstand: \(Int(locationManager.totalDistance)) meters")
                .font(.system(size: 22, weight: .bold, design: .default))
                .foregroundColor(.blue)
                .padding(.bottom, 50)
        }
    }
}


#Preview {
    ContentView()
}

