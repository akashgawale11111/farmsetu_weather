# FarmSetu Weather

A comprehensive Flutter weather application designed specifically for farmers, providing real-time weather data, location-based forecasts, and AI-powered agricultural assistance.

## 🌾 Overview

FarmSetu Weather is a mobile application that helps farmers make informed decisions by providing:

- **Real-time weather data** for current location and any searched location
- **Interactive map interface** with weather popups on location taps
- **7-day weather forecasts** with temperature, wind speed, and weather conditions
- **AI-powered farming assistant** for crop protection advice and disease identification
- **Location-based services** with automatic GPS detection and reverse geocoding

## 🚀 Features

### Weather Services
- **Current Weather**: Real-time temperature, wind speed, and weather conditions
- **7-Day Forecast**: Daily maximum/minimum temperatures and weather codes
- **Location Search**: Search for weather data by city name
- **GPS Integration**: Automatic location detection and weather display

### Map Interface
- **Interactive Google Maps**: Tap any location to view weather details
- **Weather Popups**: Quick weather summary with option to view full details
- **Location Markers**: Visual indicators for selected locations
- **Search Functionality**: Find cities and view their weather data

### AI Assistant
- **Text-based Chat**: Ask farming-related questions and get AI responses
- **Voice Assistant**: Voice input for hands-free operation (demo implementation)
- **Image Upload**: Upload crop photos for disease identification (demo implementation)
- **Agricultural Advice**: AI-powered recommendations for crop protection

### User Experience
- **Splash Screen**: Animated gradient splash with app branding
- **Bottom Navigation**: Easy switching between Map and AI Assistant
- **Custom Drawer**: Navigation menu with app branding
- **Responsive Design**: Optimized for various screen sizes

## 🛠️ Technology Stack

### Core Technologies
- **Flutter**: Cross-platform mobile development framework
- **Riverpod**: State management for reactive UI updates
- **Dio**: HTTP client for API communications

### Weather & Location Services
- **OpenWeatherMap API**: Weather data and geocoding services
- **Google Maps Flutter**: Interactive map functionality
- **Geolocator**: GPS location detection
- **Geocoding**: Address reverse lookup and city search

### UI & Animation
- **Lottie**: Animated loading indicators and splash screen
- **Flutter SpinKit**: Progress indicators
- **Cached Network Image**: Efficient image loading
- **Animated Text Kit**: Text animations

### Data Persistence
- **Shared Preferences**: Local storage for user preferences and login state

## 📁 Project Structure

```
lib/
├── main.dart                    # Application entry point
├── screens/
│   ├── splashscreen/           # Splash screen with animations
│   ├── home_screen/            # Main application screens
│   │   ├── bottom_nav.dart     # Navigation structure
│   │   ├── home_page.dart      # AI Assistant interface
│   │   ├── map_screen.dart     # Interactive map with weather
│   │   ├── weather_detail_screen.dart # Detailed weather view
│   │   └── save_data.dart      # Data persistence
│   └── utils/
│       └── custom_drover.dart  # Custom navigation drawer
└── services/
    ├── constants.dart          # API keys and configuration
    ├── weather_service.dart    # Weather API integration
    ├── geocoding_service.dart  # Location services
    ├── aiservice.dart          # AI assistant integration
    ├── provider/              # Riverpod state management
    └── model/
        └── weather_model.dart  # Weather data models
```

## 🔧 Installation & Setup

### Prerequisites
- Flutter SDK (version 3.16.0 or higher)
- Android Studio or VS Code with Flutter extension
- Valid OpenWeatherMap API key

### Setup Instructions

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/farmsetu_weather.git
   cd farmsetu_weather
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Configure API Keys:**
   - Open `lib/services/constants.dart`
   - Replace placeholder API keys with your actual keys:
     ```dart
     static const String openWeatherApiKey = 'your-openweather-api-key';
     static const String openAIApiKey = 'your-openai-api-key';
     ```

4. **Android Configuration:**
   - Ensure you have a valid Google Maps API key in `android/app/src/main/AndroidManifest.xml`
   - Configure permissions in the manifest file

5. **Run the application:**
   ```bash
   flutter run
   ```

## 📱 Screenshots

### Splash Screen
![Splash Screen](assets/screenshots/splash.png)

### Main Interface
- **Map View**: Interactive map with weather data
- **AI Assistant**: Chat interface for farming advice
- **Weather Details**: Comprehensive 7-day forecasts

## 🌐 APIs Used

### OpenWeatherMap API
- **Current Weather**: Real-time weather data
- **Forecast**: 7-day weather predictions
- **Geocoding**: City search and reverse geocoding

### Google Maps API
- **Interactive Maps**: Location-based weather viewing
- **Markers and Info Windows**: Visual location indicators

### OpenAI API (Optional)
- **AI Assistant**: Text-based farming advice
- **Image Analysis**: Crop disease identification

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **OpenWeatherMap** for providing weather data APIs
- **Google Maps** for mapping services
- **Flutter Community** for excellent packages and support
- **FarmSetu Team** for the inspiration and branding

## 📞 Support

For support and questions:
- Create an issue on GitHub
- Contact the development team
- Check the documentation

---

**FarmSetu Weather** - Empowering farmers with accurate weather information and AI-driven agricultural assistance.


