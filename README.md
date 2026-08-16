<a name="readme-top"></a>

<!-- PROJECT SHIELDS -->
<div align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart">
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS-brightgreen?style=for-the-badge" alt="Platform">
  <img src="https://img.shields.io/badge/Status-Active-success?style=for-the-badge" alt="Status">
  <img src="https://img.shields.io/badge/License-MIT-blue?style=for-the-badge" alt="License">
</div>

<br />
<div align="center">
  <h1 align="center">🏠 Domotics — Smart Home Automation</h1>

  <p align="center">
    A premium, feature-rich Smart Home Automation application built with Flutter.
    <br />
    Glassmorphism UI • 7 Device Types • BLE Scanner • Energy Analytics • Scenes & Routines
    <br />
    <br />
    <a href="#-features"><strong>Explore Features »</strong></a>
    <br />
    <br />
    <a href="#-screens-overview">View Screens</a>
    ·
    <a href="https://github.com/Choudhary-Khuzaim/Domotics/issues">Report Bug</a>
    ·
    <a href="https://github.com/Choudhary-Khuzaim/Domotics/issues">Request Feature</a>
  </p>
</div>

---

<details>
  <summary>📋 Table of Contents</summary>
  <ol>
    <li><a href="#-about-the-project">About The Project</a></li>
    <li><a href="#-features">Features</a></li>
    <li><a href="#-screens-overview">Screens Overview</a></li>
    <li><a href="#-built-with">Built With</a></li>
    <li><a href="#-architecture">Architecture</a></li>
    <li><a href="#-getting-started">Getting Started</a></li>
    <li><a href="#-folder-structure">Folder Structure</a></li>
    <li><a href="#-device-types">Device Types</a></li>
    <li><a href="#-contributing">Contributing</a></li>
    <li><a href="#-license">License</a></li>
    <li><a href="#-contact">Contact</a></li>
  </ol>
</details>

---

## 📖 About The Project

**Domotics** is a cutting-edge Smart Home application designed to provide users with seamless control over their entire home ecosystem. Built with Flutter, it showcases a **stunning glassmorphism design language** with dynamic gradients, smooth micro-animations, and a premium user experience across both dark and light themes.

The app simulates a fully functional smart home environment — from controlling individual devices like lights, ACs, fans, locks, TVs, cameras, and speakers, to setting up automated scenes and scheduled routines. It includes a simulated BLE device scanner, real-time energy analytics, and comprehensive settings management.

> **Note:** This is a UI/UX showcase application. All data is simulated locally using Provider state management. No backend or real IoT hardware is required.

### Key Highlights

| Feature | Description |
|---------|-------------|
| 🎨 **Glassmorphism UI** | Frosted glass cards, backdrop blur, and semi-transparent surfaces |
| 🌗 **Dark & Light Themes** | Complete dual-theme support with curated color palettes |
| 📱 **7 Device Types** | Lights, ACs, Fans, Locks, TVs, Cameras, Speakers |
| 🎭 **4 Preset Scenes** | Good Night, Movie Time, Away Mode, Good Morning |
| 📊 **Energy Analytics** | Daily/Weekly/Monthly charts with cost estimation |
| 📡 **BLE Scanner** | Simulated Bluetooth device discovery with radar animation |
| 🔔 **Activity Center** | Real-time notification system with categorized alerts |
| ⚡ **9 State Providers** | Clean, scalable Provider-based architecture |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## ✨ Features

### 📱 Premium UI/UX
- Stunning dark and light mode interfaces with frosted glass effects (glassmorphism)
- Dynamic gradient backgrounds and smooth micro-animations
- Custom animated bottom navigation bar with backdrop blur
- Responsive layouts optimized for all screen sizes

### 🎛️ Master Dashboard
- Time-aware greeting with user profile avatar
- Live weather widget with detailed weather sheet
- Quick scene activation cards for instant automation
- Room-by-room device status overview with active device counts
- Notification bell with unread count badge

### 💡 Comprehensive Device Control (7 Types)
- **Smart Lights:** Brightness sliders, color picker wheel, color presets (Warm, Cool, Relax, Focus, Movie)
- **Smart ACs:** Temperature +/- controls with large digit display, mode selector (Cool/Heat/Fan), quick presets (Eco/Sleep/Turbo)
- **Smart Fans:** Multi-speed control, oscillation toggle, natural/sleep mode
- **Smart Locks:** One-tap lock/unlock with animated status icon
- **Smart TVs:** Volume slider with percentage display
- **Smart Cameras:** Motion detection toggle, night vision control, recording status
- **Smart Speakers:** Play/pause, volume, track info display

### 🏠 Room Management
- Create, edit, and delete rooms with custom icon selection
- Grid layout showing device count and active count per room
- 8 room icon options (living, bedroom, kitchen, bathroom, office, garage, garden, balcony)

### 🎭 Smart Scenes
- **4 Preset Scenes:** Good Night, Movie Time, Away Mode, Good Morning
- **Create Custom Scenes:** Name, description, 12 icon options, 6 gradient style presets
- **1-Tap Execution:** Execute scenes with animated loading indicator
- **Delete Scenes:** Long-press any scene to delete
- Beautiful gradient cards with accent color glow effects

### 📅 Automated Routines
- Create scheduled routines with time picker
- Select repeat days (Mon–Sun) with animated toggles
- Optional scene linking — trigger a scene at a specific time
- Enable/disable routines with toggle switch
- Delete routines with one tap

### 📊 Energy Analytics
- **Daily/Weekly/Monthly** consumption view with interactive FL Chart bar graphs
- **Breakdown Chart:** Per-device type energy distribution (donut chart)
- **Cost Estimation:** Based on configurable energy rate per kWh
- **Trend Indicators:** Usage comparison vs previous period with ↑↓ arrows
- **High Consumer Alert:** Identifies top energy-consuming devices

### 📡 BLE Scanner
- Animated radar pulse visualization during scanning
- Simulated device discovery with 8 mock BLE devices
- Signal strength (RSSI) display per device
- Connect/disconnect/pair actions per device
- PIN-based pairing modal (default PIN: 1234)
- Back navigation with proper Scaffold wrapping

### ⚙️ Settings & Configuration
- **Profile Management:** Editable name, email, avatar with gradient ring, member since badge
- **Home Configuration:** Home name, address, manage rooms, connected devices count
- **Notifications:** Push, sound, email, security alerts, energy alerts toggles
- **Security:** Biometric lock, PIN lock toggles
- **Preferences:** Dark mode toggle, temperature unit (°C/°F), energy rate editor
- **About:** App version dialog with build info, Terms of Service, Privacy Policy, Help & Support with FAQ
- **Share Home Access:** Invite code generation with copy-to-clipboard
- **Export Home Data:** Simulated data export with success snackbar

### 🔔 Activity Center (Notifications)
- Categorized notifications: Security, Warning, Success, Info
- Color-coded icons per notification type
- Relative timestamp display (Just now, 5m ago, 2h ago)
- Clear all notifications action
- Empty state illustration

### 🚀 Splash Screen
- Animated logo reveal with scale/fade transitions
- Gradient background with smooth navigation to main app

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## 📸 Screens Overview

| Screen | Description |
|--------|-------------|
| **Splash Screen** | Animated logo with gradient background |
| **Dashboard** | Main hub with weather, scenes, rooms, and devices |
| **Device Detail** | Deep-dive controls for each device type |
| **Scenes** | Preset + custom scene management with gradient cards |
| **Routines** | Time-based automation scheduling |
| **Analytics** | Energy consumption charts and cost breakdown |
| **Settings** | Full app configuration with 5 sections |
| **Profile** | User stats, home info, and quick actions |
| **Rooms** | Grid-based room management with CRUD |
| **Add Device** | 3-step wizard (type → name/room → confirmation) |
| **BLE Scanner** | Radar animation + device discovery list |
| **Notifications** | Activity center with categorized alerts |

> **Tip:** Run the app to experience all screens interactively. Every screen supports both dark and light themes.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## 🛠 Built With

| Package | Purpose |
|---------|---------|
| [![Flutter][Flutter.dev]][Flutter-url] | UI Framework |
| [![Dart][Dart.dev]][Dart-url] | Programming Language |
| **[provider](https://pub.dev/packages/provider)** | Reactive State Management |
| **[fl_chart](https://pub.dev/packages/fl_chart)** | Energy Analytics Charts |
| **[flutter_colorpicker](https://pub.dev/packages/flutter_colorpicker)** | Smart Light Color Controls |
| **[google_fonts](https://pub.dev/packages/google_fonts)** | Typography (Inter font family) |
| **[flutter_animate](https://pub.dev/packages/flutter_animate)** | Declarative Micro-animations |
| **[percent_indicator](https://pub.dev/packages/percent_indicator)** | Circular/Linear Progress Indicators |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## 🏗 Architecture

The application follows a clean, scalable architecture using the **Provider** pattern for reactive state management. All state is centralized through `MultiProvider` in `main.dart`.

### Provider Architecture

```
main.dart (MultiProvider)
├── ThemeProvider          → Dark/Light theme toggle
├── DeviceProvider         → Smart device CRUD & state
├── RoomProvider           → Room management & icon mapping
├── SceneProvider          → Scene execution & CRUD
├── RoutineProvider        → Scheduled routine management
├── EnergyProvider         → Energy analytics computation
├── SettingsProvider       → User preferences & home config
├── NotificationProvider   → Activity logs & alert system
└── BleScanProvider        → BLE device scanning & pairing
```

### Design Patterns

| Pattern | Usage |
|---------|-------|
| **Provider (ChangeNotifier)** | All 9 providers extend `ChangeNotifier` for reactive rebuilds |
| **IndexedStack** | Main navigation preserves state across 5 tabs |
| **Glassmorphism Cards** | Reusable `GlassCard` widget with backdrop blur |
| **Animated Containers** | Smooth state transitions on toggles, selections, and theme changes |
| **Composition over Inheritance** | Device type hierarchy (`SmartDevice` → `SmartLight`, `SmartAC`, etc.) |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## 🚀 Getting Started

Follow these instructions to set up the project locally on your machine.

### Prerequisites

- **Flutter SDK**: `>=3.4.0`
- **Dart SDK**: `>=3.4.0`
- Android Studio / VS Code with Flutter extensions installed
- An Android/iOS emulator or physical device

### Installation

1.  **Clone the repository**
    ```sh
    git clone https://github.com/Choudhary-Khuzaim/Domotics.git
    cd Domotics
    ```

2.  **Install dependencies**
    ```sh
    flutter pub get
    ```

3.  **Run the application**
    ```sh
    flutter run
    ```

4.  **Run analysis (optional)**
    ```sh
    flutter analyze
    ```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## 📁 Folder Structure

```text
lib/
├── models/                  # Data models
│   ├── smart_device.dart    # SmartDevice base + 7 subtypes (Light, AC, Fan, Lock, TV, Camera, Speaker)
│   ├── room.dart            # Room entity with icon mapping
│   ├── scene.dart           # SmartScene with gradient & accent colors
│   ├── routine.dart         # Routine with time, days, scene linking
│   ├── ble_device.dart      # BLE device with RSSI & connection state
│   └── notification_model.dart # Typed notification entity
│
├── providers/               # State management (9 providers)
│   ├── device_provider.dart       # Device CRUD, toggle, brightness, temperature, volume
│   ├── room_provider.dart         # Room CRUD with icon selection
│   ├── scene_provider.dart        # Scene execution + custom scene CRUD
│   ├── routine_provider.dart      # Routine scheduling & management
│   ├── energy_provider.dart       # Energy analytics computation
│   ├── settings_provider.dart     # User preferences & home config
│   ├── theme_provider.dart        # Dark/Light theme toggle
│   ├── notification_provider.dart # Activity log system
│   └── ble_scan_provider.dart     # BLE scanning & pairing state
│
├── screens/                 # Feature screens (11 screen modules)
│   ├── splash/              # Animated startup screen
│   ├── dashboard/           # Main home hub
│   │   └── widgets/         # GreetingHeader, QuickScenes, RoomDevices, WeatherSheet
│   ├── device_detail/       # Per-device deep controls
│   │   └── widgets/         # ColorPickerWheel, FanControl, CameraControl, SpeakerControl, SchedulePicker
│   ├── scenes/              # Scene management with create/delete
│   ├── routines/            # Routine scheduling
│   ├── analytics/           # Energy charts & breakdown
│   │   └── widgets/         # BreakdownChart
│   ├── settings/            # App configuration (5 sections)
│   ├── profile/             # User stats & quick actions
│   ├── rooms/               # Room grid management
│   ├── add_device/          # 3-step add device wizard
│   └── ble_scanner/         # BLE device discovery
│       └── widgets/         # RadarAnimation, BleDeviceTile, PairingModal
│
├── services/                # Business logic services
│   └── mock_ble_service.dart # Simulated BLE scanning & pairing
│
├── widgets/                 # Reusable UI components
│   ├── glass_card.dart      # Glassmorphism card with backdrop blur
│   ├── animated_toggle.dart # Custom toggle switch
│   ├── bottom_nav_bar.dart  # Custom bottom navigation bar
│   └── notifications_sheet.dart # Activity center bottom sheet
│
├── app_theme.dart           # Centralized design system (colors, typography, themes)
└── main.dart                # App entry point with MultiProvider setup
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## 📟 Device Types

| Device | Features | Accent Color |
|--------|----------|--------------|
| 💡 **Smart Light** | Brightness slider, color wheel, 5 color presets | Amber |
| ❄️ **Smart AC** | Temperature ±, 3 modes (Cool/Heat/Fan), quick presets | Cyan |
| 🌀 **Smart Fan** | Multi-speed (1-5), oscillation, natural/sleep mode | Cyan |
| 🔒 **Smart Lock** | 1-tap lock/unlock, animated icon | Green/Rose |
| 📺 **Smart TV** | Volume slider with percentage | Indigo |
| 📹 **Smart Camera** | Motion detection, night vision, recording | Rose |
| 🔊 **Smart Speaker** | Play/pause, volume, track info | Indigo |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## 🤝 Contributing

Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## 📜 License

Distributed under the MIT License. See `LICENSE` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## 📫 Contact

**Khuzaim** — [GitHub Profile](https://github.com/Choudhary-Khuzaim)

Project Link: [https://github.com/Choudhary-Khuzaim/Domotics](https://github.com/Choudhary-Khuzaim/Domotics)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

<div align="center">
  <p>Made with ❤️ and Flutter</p>
  <p>⭐ Star this repo if you find it helpful!</p>
</div>

<!-- MARKDOWN LINKS & IMAGES -->
[Flutter.dev]: https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white
[Flutter-url]: https://flutter.dev/
[Dart.dev]: https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white
[Dart-url]: https://dart.dev/
