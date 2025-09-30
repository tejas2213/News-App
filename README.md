# News App

A Flutter news application using Clean Architecture, Riverpod for state management.

## Features
Authentication
- User registration with email and password
- User login with email and password
- Persistent user sessions
- Secure logout functionality

News Features
- Fetch news from NewsAPI
- View article details
- Save articles for offline reading
- Search functionality
- Dark/Light theme toggle
- Pagination
- Pull-to-refresh

## Architecture

The app follows Clean Architecture with three main layers:

1. **Presentation Layer**: Contains UI components, widgets, and state management.
2. **Domain Layer**: Contains business logic, entities, and use cases.
3. **Data Layer**: Handles data sources (remote and local) and repositories.

## Setup Instructions

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Add your Firebase configuration files (google-services.json for Android, GoogleService-Info.plist for iOS)
4. Set up your NewsAPI key in environment variables or configuration
5. Run the app with `flutter run`

## Dependencies

- flutter_riverpod: State management
- http: For API calls
- sqflite: For local storage
- url_launcher: For opening URLs in browser
- go_router: For navigation
- cached_network_image: For image caching
- firebase_auth: Authentication backend
- firebase_core: Initialize Firebase
- shared_preferences: Local storage for user sessions
- fpdart: Functional programming utilities for error handling

