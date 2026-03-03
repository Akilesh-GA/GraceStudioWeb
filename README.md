# 📸 Grace Studio | Professional Media Booking App

[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=flat&logo=Flutter&logoColor=white)](https://flutter.dev)
[![Razorpay](https://img.shields.io/badge/Razorpay-02042B?style=flat&logo=razorpay&logoColor=3399FF)](https://razorpay.com)
[![Firebase](https://img.shields.io/badge/Firebase-039BE5?style=flat&logo=Firebase&logoColor=white)](https://firebase.google.com)

**Grace Studio** is a premium, Flutter-powered cross-platform solution designed to bridge the gap between world-class media services and clients. Whether it's photography, videography, or drone cinematography, Grace Studio offers a high-performance interface for seamless scheduling and secure financial transactions.

## ✨ Key Features

### 💎 The Client Experience
* **Intuitive Service Suite:** Browse and select from high-end services like Editing, Drone Shoots, and Portraiture.
* **Dynamic Booking Engine:** A streamlined flow with integrated date/time pickers and custom requirement fields.
* **Secure Financials:** Fully integrated with **Razorpay** for industry-standard encryption and diverse payment methods.
* **Real-time Tracking:** Dedicated dashboard for booking status, payment history, and past project summaries.
* **Post-Service Engagement:** Built-in review and rating system to ensure quality control.

### 🛠 Technical Excellence
* **Cross-Platform Harmony:** Optimized for pixel-perfect performance on Android, iOS, and Web.
* **Role-Based Logic:** Secure user authentication and data privacy via Firebase.
* **Modern UI/UX:** Responsive layouts featuring smooth transitions and a minimalist design aesthetic.

### 📷 Prototype

<div align="center">
  <img src="pages/welcome_user.png" alt="User Dashboard" style="width: 90%; height: auto; margin-bottom: 20px; border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);">
  <img src="pages/welcome_admin.png" alt="Admin Panel" style="width: 90%; height: auto; margin-bottom: 20px; border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);">
  <img src="pages/booking.png" alt="Booking Interface" style="width: 90%; height: auto; margin-bottom: 20px; border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);">
  <img src="pages/payments.png" alt="Payment Gateway" style="width: 90%; height: auto; margin-bottom: 20px; border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);">
</div>

## 📱 App Walkthrough

1.  **Login & Identity:** Secure Firebase-backed authentication with email/password and recovery options.
2.  **Service Discovery:** A clean, visual interface to explore available photography and videography packages.
3.  **Booking Flow:** Select preferred dates, provide project notes, and proceed to checkout.
4.  **Payment Confirmation:** Instant feedback with Razorpay Payment IDs and success dialogs.
5.  **History & Profiles:** Comprehensive logs of all past bookings, upcoming schedules, and personal profile management.


## 🚀 Tech Stack

| Technology | Purpose |
| :--- | :--- |
| **Flutter & Dart** | UI Development & Business Logic |
| **Firebase** | Authentication & Cloud Data Storage |
| **Razorpay SDK** | Secure Payment Processing |


## 🛠 Installation & Setup

### Prerequisites
* **Flutter SDK** (v3.0.0 or higher)
* **Dart SDK**
* **Firebase Account** (for authentication)
* **Razorpay API Keys**

### Getting Started

1.  **Clone the Repository:**
    ```bash
    git clone [https://github.com/Akilesh-GA/GraceStudioWeb.git](https://github.com/Akilesh-GA/GraceStudioWeb.git)
    cd GraceStudioWeb
    ```

2.  **Install Dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Configure Environment:**
    * Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) to their respective directories.
    * Initialize your Razorpay API keys in your configuration file.

4.  **Launch the App:**
    ```bash
    # For Web
    flutter run -d chrome  

    # For Mobile
    flutter run           
    ```

## 📅 Future Roadmap
* [ ] **AI Scheduling:** Automated slot suggestions based on photographer availability.
* [ ] **Client Gallery:** In-app digital delivery of high-resolution media.
* [ ] **Push Notifications:** SMS and Email alerts via Twilio/SendGrid integration.
