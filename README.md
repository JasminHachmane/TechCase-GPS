# GPSVoiceApp

GPSVoiceApp is an iOS app that tracks the user's location and gives voice feedback every time the user walks 5 meters. 
The goal is to help users keep track of how far they’ve walked in a fun and easy way.

## Features

- **Map view**: Shows the user's current location on an interactive map.
- **Distance tracker**: Calculates and shows the total distance walked.
- **Voice feedback**: Gives a voice message every time the user walks 5 meters.

## Technologies

- **SwiftUI** for the user interface
- **CoreLocation** for GPS functionality
- **AVFoundation** for voice feedback
- **Xcode** for app development

## Installation

1. Clone the project to your local machine:

   ```bash
   git clone https://github.com/JasminHachmane/TechCase-GPS.git
2. Open the project in Xcode.
3. Make sure you are testing on a real iPhone, as GPS functionality does not work in the simulator.

## How to use
1. Open the app and grant location access when prompted.
2. The app will display a map with your current location.
3. Every time you walk 5 meters, the app will give you a spoken message saying that you've walked that distance.
