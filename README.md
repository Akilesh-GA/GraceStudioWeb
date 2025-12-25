# Grace Studio - Booking & Payment App

Grace Studio is a Flutter-based cross-platform application for booking photography, videography, and related services. It provides a seamless experience for users to select services, book slots, make payments, and track their bookings. The application is integrated with **Razorpay** for secure online payments and includes a modern, responsive UI optimized for both mobile and web platforms.

---

## Table of Contents
- [Features](#features)
- [Screens](#screens)
- [Installation](#installation)
- [Project Structure](#project-structure)
- [Technologies Used](#technologies-used)
- [Usage](#usage)
- [Future Enhancements](#future-enhancements)
- [License](#license)

---

## Features

### User Side
- **Service Booking:** Choose from Photography, Videography, Editing, Drone Shoot, and more.
- **Booking Form:** Enter details like name, email, phone, service, date, and additional notes.
- **Date & Time Picker:** Select preferred date for service.
- **Secure Payment Gateway:** Integrated with Razorpay for online payments.
- **Booking Confirmation:** Success dialog showing payment ID and booking summary.
- **Booking History:** Track upcoming and past bookings.
- **Profile Management:** Update personal details.
- **Notifications:** Alerts for upcoming bookings and payment status.
- **Reviews & Ratings:** Rate and review completed services.

---

## Screens

1. **Login Screen**
   - Secure login with email and password.
   - Forgot password functionality.
2. **Registration Screen**
   - Create a new account with email and password.
3. **Home Screen**
   - View available services and navigate to booking.
4. **Booking Screen**
   - Fill booking details, select service, choose date, and pay online.
5. **Payment Confirmation**
   - Shows payment success/failure status with Razorpay payment ID.
6. **Booking History**
   - Track all bookings and payment history.

---

## Installation

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK
- Google Chrome (for web)
- Firebase project (for authentication, optional)

## Project Structure

grace_studio/
├─ android/
├─ ios/
├─ lib/
│ ├─ main.dart
│ ├─ screens/
│ │ ├─ login_screen.dart
│ │ ├─ register_screen.dart
│ │ ├─ home_screen.dart
│ │ ├─ booking_screen_web.dart
│ │ ├─ booking_history.dart
│ │ ├─ profile_screen.dart
│ │ └─ firebase_screens.dart
│ ├─ widgets/
│ │ ├─ booking_input_field.dart
│ │ ├─ booking_dropdown_field.dart
│ │ └─ custom_button.dart
│ └─ services/
│ ├─ payment_service.dart
│ └─ firebase_service.dart
├─ web/
│ └─ index.html
├─ pubspec.yaml
└─ README.md

### Tech Stack

Technologies Used

Flutter & Dart: Cross-platform UI development

Firebase: Authentication & optional data storage

Razorpay: Online payment gateway integration

HTML/JS: Web payment integration for Razorpay

### Steps
1. Clone the repository:

```bash
git clone https://github.com/your-username/grace-studio.git
cd grace-studio
