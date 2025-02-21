# PetroFlow Mobile

## 🚀 Overview

PetroFlow Mobile is a feature-rich application designed to complement the PetroFlow Web platform. Built using Flutter, it enables on-the-go management of petroleum station operations, handling tasks not covered by the web application. The mobile app communicates with the same backend as the web version, ensuring seamless data synchronization.

## 🛠 Tech Stack

### **Mobile:**

- **Dart & Flutter** – Cross-platform mobile development
- **REST APIs** – Enables communication with the backend

### **Backend:**

- **Spring Boot** – Java-based backend framework
- **PostgreSQL** – Relational database for data persistence
- **Docker** – Containerization for seamless deployment

## ✨ Features

- **Sales Recording & Transactions** – Log sales and manage transactions efficiently
- **Inventory Management** – Track fuel stock levels and orders
- **Employee Operations** – Assign and monitor tasks
- **Real-time Data Sync** – Ensures consistency across web and mobile
- **Offline Mode** – Capture data even without internet and sync later

## 📦 Installation

### **1. Clone the Repository**

```sh
git clone https://github.com/Angera-Silas/petroflow-mobile.git
cd petroflow-mobile
```

### **2. Setup the Mobile Application**

```sh
flutter pub get  # Install dependencies
flutter run  # Run the app on a connected device or emulator
```

### **3. Backend Setup**

Ensure the backend is running by following the installation steps from the [PetroFlow Backend Repository](https://github.com/Angera-Silas/petroflow-backend).

## 🚀 Running the Application

- **Mobile App:** Runs on connected Android/iOS devices
- **Backend:** Runs on `http://localhost:8081`

## 📖 API Documentation

The mobile app communicates with the backend via REST APIs. View API documentation via Swagger:
`
http://localhost:8080/swagger-ui/
`

## 🤝 Contributing

Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.
1. Fork the repository
2. Create a new feature branch (`git checkout -b feature-branch`)
3. Commit your changes (`git commit -m "Added new feature"`)
4. Push to the branch (`git push origin feature-branch`)
5. Create a Pull Request

## 📝 License

This project is licensed under **MIT** – see the `LICENSE.md` file for details.

