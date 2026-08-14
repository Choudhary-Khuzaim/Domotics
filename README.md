<a name="readme-top"></a>

<!-- PROJECT SHIELDS -->
<div align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart">
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS-brightgreen?style=for-the-badge" alt="Platform">
  <img src="https://img.shields.io/badge/Status-Active-success?style=for-the-badge" alt="Status">
</div>

<br />
<div align="center">
  <h1 align="center">🏠 Domotics - Smart Home UI</h1>

  <p align="center">
    A premium, fully-featured Smart Home Automation application built with Flutter.
    <br />
    <br />
    <a href="#-features"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="#-screenshots">View Screenshots</a>
    ·
    <a href="#-report-bug">Report Bug</a>
    ·
    <a href="#-request-feature">Request Feature</a>
  </p>
</div>

---

<details>
  <summary>Table of Contents</summary>
  <ol>
    <li><a href="#-about-the-project">About The Project</a></li>
    <li><a href="#-features">Features</a></li>
    <li><a href="#-screenshots">Screenshots</a></li>
    <li><a href="#-built-with">Built With</a></li>
    <li><a href="#-architecture">Architecture</a></li>
    <li><a href="#-getting-started">Getting Started</a></li>
    <li><a href="#-folder-structure">Folder Structure</a></li>
    <li><a href="#-contributing">Contributing</a></li>
    <li><a href="#-license">License</a></li>
    <li><a href="#-contact">Contact</a></li>
  </ol>
</details>

---

## 📖 About The Project

Domotics is a cutting-edge Smart Home application designed to provide users with seamless control over their entire home ecosystem. Focusing on a **stunning glassmorphism design language**, the app offers dynamic gradients, smooth micro-animations, and a highly intuitive user experience. 

Whether you are managing smart lights, monitoring energy consumption, or setting up complex automated routines, Domotics makes smart living simple and elegant.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## ✨ Features

*   **📱 Premium UI/UX:** Stunning dark and light mode interfaces utilizing frosted glass effects (glassmorphism), dynamic gradients, and fluid animations.
*   **🎛️ Master Dashboard:** A centralized hub to view local weather, activate quick scenes, check room-by-room device statuses, and monitor air quality.
*   **💡 Comprehensive Device Control:** 
    *   **Smart Lights:** Color pickers, brightness sliders, and temperature rings.
    *   **Smart ACs:** Thermostat dials and mode selectors.
    *   **Smart Fans:** Speed controls and oscillation toggles.
    *   **Smart Locks & Cameras:** Security monitoring and access control.
*   **🛏️ Room Management:** Group devices intuitively. Create, edit, and delete rooms with a selection of custom icons.
*   **🎭 Scenes:** Create customized scenarios (e.g., "Movie Mode", "Good Morning") to control multiple devices with a single tap.
*   **📅 Automated Routines:** Schedule tasks based on time and specific days of the week. Link routines directly to your predefined scenes.
*   **📊 Energy Analytics:** Monitor daily, weekly, and monthly energy consumption through interactive charts. Track estimated costs and view high-consumption devices.
*   **📡 BLE Scanner Simulator:** A built-in Bluetooth Low Energy (BLE) scanner interface to discover and pair nearby smart devices.
*   **⚙️ Advanced Settings:** Manage your profile, home configuration, granular notification preferences, security settings (simulated PIN/Biometrics), and app aesthetics.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## 📸 Screenshots

<div align="center">
  <!-- Note: Replace the src URLs with actual paths or hosted image URLs of your app screenshots -->
  <img src="https://raw.githubusercontent.com/flutter/website/main/src/assets/images/docs/ui/layout/lakes.png" alt="Dashboard" width="22%">
  &nbsp;
  <img src="https://raw.githubusercontent.com/flutter/website/main/src/assets/images/docs/ui/layout/lakes.png" alt="Device Details" width="22%">
  &nbsp;
  <img src="https://raw.githubusercontent.com/flutter/website/main/src/assets/images/docs/ui/layout/lakes.png" alt="Energy Analytics" width="22%">
  &nbsp;
  <img src="https://raw.githubusercontent.com/flutter/website/main/src/assets/images/docs/ui/layout/lakes.png" alt="Settings & Profile" width="22%">
  
  <p><em>(Placeholder Images: Update with actual app screenshots)</em></p>
</div>

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## 🛠 Built With

*   [![Flutter][Flutter.dev]][Flutter-url]
*   [![Dart][Dart.dev]][Dart-url]
*   **Provider** (State Management)
*   **FL Chart** (Analytics & Graphs)
*   **Flutter Colorpicker** (Smart Light Controls)
*   **Google Fonts** (Typography - 'Inter')
*   **Flutter Animate** (Micro-animations)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## 🏗 Architecture

The application adheres to a clean, scalable architecture utilizing the **Provider** pattern for reactive state management. 

### Core Providers:
*   `DeviceProvider`: Manages state and CRUD operations for all smart devices.
*   `RoomProvider`: Manages room data and icon associations.
*   `SceneProvider`: Handles predefined and custom multi-device scenes.
*   `RoutineProvider`: Manages scheduled automation logic.
*   `EnergyProvider`: Calculates and provides energy consumption analytics.
*   `SettingsProvider`: Handles user preferences, profile data, and home configurations.
*   `ThemeProvider`: Toggles between dark and light themes globally.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## 🚀 Getting Started

Follow these instructions to set up the project locally on your machine.

### Prerequisites

*   **Flutter SDK**: `>=3.4.0`
*   **Dart SDK**
*   Android Studio / VS Code with Flutter extensions installed.

### Installation

1.  **Clone the repository**
    ```sh
    git clone https://github.com/yourusername/domotics.git
    cd domotics
    ```

2.  **Install dependencies**
    ```sh
    flutter pub get
    ```

3.  **Run the application**
    ```sh
    flutter run
    ```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## 📁 Folder Structure

```text
lib/
├── models/             # Data models (Device, Room, Scene, Routine, etc.)
├── providers/          # State management (Provider classes)
├── screens/            # UI Screens
│   ├── analytics/      # Energy consumption charts
│   ├── dashboard/      # Main home hub
│   ├── device_detail/  # Specific controls for lights, ACs, locks, etc.
│   ├── profile/        # User profile
│   ├── rooms/          # Room management
│   ├── routines/       # Automation scheduling
│   ├── scenes/         # Multi-device scenarios
│   ├── settings/       # App and home configurations
│   └── splash/         # Animated startup screen
├── widgets/            # Reusable UI components (GlassCard, NavBar, etc.)
├── app_theme.dart      # Centralized design system (Colors, Typography)
└── main.dart           # App entry point
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## 🤝 Contributing

Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## 📜 License

Distributed under the MIT License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## 📫 Contact

Your Name - [@yourtwitter](https://twitter.com/yourusername) - email@example.com

Project Link: [https://github.com/yourusername/domotics](https://github.com/yourusername/domotics)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- MARKDOWN LINKS & IMAGES -->
[Flutter.dev]: https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white
[Flutter-url]: https://flutter.dev/
[Dart.dev]: https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white
[Dart-url]: https://dart.dev/
