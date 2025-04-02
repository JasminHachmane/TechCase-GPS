//
//  ContentView.swift
//  GPSVoiceApp
//
//  Created by Jasmin Hachmane on 27/03/2025.
//

import SwiftUI
import MapKit

// Hoofdstructuur van de SwiftUI-weergave
struct ContentView: View {
    // Maak een instantie van LocationManager om locatie-updates te beheren
    @StateObject private var locationManager = LocationManager()
    
    var body: some View { 
        VStack {
            // Toon een kaart met de locatie van de gebruiker
            Map(coordinateRegion: $locationManager.region, showsUserLocation: true)
                .edgesIgnoringSafeArea(.all) // Zorgt ervoor dat de kaart de volledige breedte gebruikt
                .frame(height: 700)
                .padding(.bottom, 50)
            
            // Toon de totaal afgelegde afstand in meters
            Text("Afgelegde afstand: \(Int(locationManager.totalDistance)) meter")
                .font(.system(size: 22, weight: .bold, design: .default))
                .foregroundColor(.blue)
                .padding(.bottom, 50)
        }
    }
}


#Preview {
    ContentView()
}

