# Rewear

ReWear is a mobile application designed for buying and selling preloved clothes. It facilitates connections between buyers and sellers, making communication seamless through its integrated chat and location-sharing features. The primary goal of ReWear is to streamline the trade of preworn clothing, thereby contributing to environmental sustainability and helping users save money.

## Table of Contents
- [General Info](#general-info)
- [Technologies Used](#technologies-used)
- [Database](#database)
- [Design Patterns](#design-patterns)
- [Features](#features)
- [Structure](#structure)
- [Dependencies](#dependencies)
- [Room for Improvement](#room-for-improvement)

## General Info
ReWear offers a platform for individuals to sell and discover preloved clothing items. By providing features like chat and location sharing, the app aims to simplify the process of connecting buyers with sellers. This not only promotes the reuse of clothing but also contributes to environmental conservation efforts.

## Technologies Used
- Flutter 3.13.7
- Dart 3.1.3

## Database
Firebase

## Design Patterns
- Factory Method Pattern: Used for flexible creation of objects based on different types of input data.
- Singleton: Implemented for objects providing internal state management and user authentication.
- MVC (Model-View-Controller): FirebaseProvider acts as a Controller, managing message retrieval and manipulation (Model) while updating the UI (View).
- Component-Based Architecture: UI elements are separated into reusable components.

## Features
- Custom UI elements
- State management
- Login & Register functionalities using Firebase
- Post items for sale (including image, description, price)
- Camera integration
- Mark items as sold
- Delete posts
- User rating system
- Search functionality for items on sale
- Save favorite items
- Liking posts
- Commenting on posts
- Chat with buyer/seller
- Message notifications
- Ability to send photos in chat
- Location sharing in chat

## Structure
The `lib` folder contains `main.dart` and subfolders:
- `Model`: Models for user, post, and message
- `Providers`: Data providers
- `Resources`: Authentication and database access methods
- `Responsive`: Responsive layouts for mobile and web screens
- `Screens`: Various interactive screens
- `Service`: Services for database connection, location, notifications, and media
- `Utils`: Common utilities
- `Widgets`: Reusable widgets

## Dependencies
Dependencies listed in `pubspec.yaml`:

cloud_firestore: ^4.14.0
cupertino_icons: ^1.0.2
firebase_analytics: ^10.8.0
firebase_auth: ^4.16.0
firebase_core: ^2.24.2
firebase_messaging: ^14.7.10
firebase_storage: ^11.6.0
flutter:
sdk: flutter
flutter_local_notifications: ^16.3.2
flutter_svg: ^2.0.9
geolocator: ^10.1.0
image_picker: ^1.0.7
intl: ^0.19.0
provider: ^6.1.1
share: ^2.0.4
url_launcher: ^6.2.4
uuid: ^4.2.2

## Room for Improvement
Implementing a payment system within the app would enhance user experience by allowing seamless transactions for purchased items.



