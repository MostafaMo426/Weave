# Weave 🌐
### Off-Grid Decentralized Communication System

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)
![iOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=apple&logoColor=white)

**Weave** is a mobile application designed to enable communication in "dead zones" where internet or cellular coverage is unavailable. By leveraging the **Nearby Connections API**, Weave transforms smartphones into network nodes, creating a local **Peer-to-Peer (P2P)** mesh network for secure, instant messaging.

---

## 🚀 Key Features

* **100% Offline:** No internet, SIM card, or router required.
* **Hybrid Protocol:** Uses **Bluetooth Low Energy (BLE)** for battery-efficient discovery and **Wi-Fi Direct** for high-speed data transfer.
* **Manual Discovery:** Browse available devices and choose who to connect to (prevents network congestion).
* **Bilingual Support:** Full UI localization for **English** and **Arabic (RTL)**.
* **Data Integrity:** Custom UTF-8 serialization layer to support multi-byte characters (Arabic text).
* **Real-time Logs:** Visual interface to monitor connection states (Advertising, Discovering, Handshake).

---

## 🛠️ Technical Architecture

Weave implements a **P2P Cluster Topology** using a serverless architecture:

1.  **Discovery Phase (BLE):** Devices scan for peers using low-power Bluetooth to identify the `Service-ID`.
2.  **Bandwidth Upgrade (Wi-Fi Direct):** Upon connection request, the protocol automatically upgrades the link to Wi-Fi Direct (SoftAP) to maximize throughput and range (up to 80m).
3.  **Payload Transfer:** Messages are encoded into byte arrays and transmitted via direct socket channels.

---

## 📱 Screenshots

| Home (English) | Chat (Arabic) | Discovery Mode |
|:---:|:---:|:---:|
| ![Home Screen](path/to/screenshot1.png) | ![Chat Screen](path/to/screenshot2.png) | ![Discovery](path/to/screenshot3.png) |
*(Add your screenshots here)*

---

## 🔧 Installation & Setup

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/MostafaMo426/Weave.git]
    ```
2.  **Install dependencies:**
    ```bash
    cd weave-chat
    flutter pub get
    ```
3.  **Run on Android Device:**
    * *Note: Emulators do not support Bluetooth/Wi-Fi Direct. You must use a physical device.*
    ```bash
    flutter run
    ```

### Permissions (Android)
This app requires the following permissions to function (handled at runtime):
* `ACCESS_FINE_LOCATION`
* `BLUETOOTH_SCAN` & `BLUETOOTH_ADVERTISE`
* `BLUETOOTH_CONNECT`
* `NEARBY_WIFI_DEVICES` (Android 12+)

---

## 🧩 Tech Stack

* **Framework:** Flutter (Dart)
* **Networking:** `nearby_connections` (Google Nearby Connections API)
* **State Management:** Provider
* **Permissions:** `permission_handler`

---
## 📂 Project Structure

The project follows a clean architecture separating **UI**, **Business Logic (Services)**, and **Configuration**.

```text
weave/
├── android/                   
│   └── app/src/main/AndroidManifest.xml  # Native Android permissions (Bluetooth/Location)
├── assets/                     # Images and screenshots for documentation
├── lib/
│   ├── screens/
│   │   └── chat_screen.dart    # Main UI: Handles chat view, device list, and language toggle
│   ├── services/
│   │   ├── language_service.dart   # Handles Localization (English/Arabic) & RTL support
│   │   └── nearby_service.dart     # Core P2P Logic: Advertising, Discovery, and Payload transfer
│   └── main.dart               # App Entry point & Provider setup
├── pubspec.yaml                # Project dependencies (nearby_connections, permission_handler)
└── README.md                   # Project documentation
```
---
## 🔮 Future Roadmap

* [ ] Implement **Multi-hop Routing** (Store-and-Forward) to extend range.
* [ ] Add **End-to-End Encryption** (AES).
* [ ] File and Image sharing support.

---

## 👨‍💻 Contributors

* **[Mostafa Mohamed]** - *Initial Work & Development*

## 📄 License

This project is licensed under the MIT License.