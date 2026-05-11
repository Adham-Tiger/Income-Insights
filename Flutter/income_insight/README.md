# 📱 Income-Insights (Mobile Application)

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![Clean Architecture](https://img.shields.io/badge/Architecture-Clean-success)

This is the mobile frontend for the **Income-Insights** project, built entirely with Flutter. The application provides a seamless, cross-platform user interface to predict if an individual's income exceeds $50K/year. 

Its standout feature is **100% On-Device Offline Inference**. The app does not rely on backend servers or cloud APIs; instead, it runs the machine learning model locally on the user's device, ensuring zero latency and absolute data privacy.

---

## ✨ Key Features
* **Offline AI Inference:** Executes complex machine learning predictions locally using an embedded AI model.
* **Reactive UI:** A smooth, responsive user interface that instantly updates based on user inputs.
* **On-Device Data Processing:** The app handles all necessary data scaling, encoding, and tensor shaping internally before feeding it to the AI model.
* **Robust Error Handling:** Utilizes functional programming concepts to gracefully manage exceptions and edge cases without crashing.

---

## 🏗️ Architecture & Tech Stack

This project strictly adheres to **Clean Architecture** principles, ensuring the codebase is scalable, testable, and easy to maintain. The separation of concerns is explicitly divided into Presentation, Domain, and Data layers.

### Core Packages & Tools
* **`get_it`**: Used as a Service Locator for robust Dependency Injection (DI). Ensures classes are loosely coupled.
* **`dartz`**: Brings functional programming capabilities to Dart. Extensively used for error handling via `Either<Failure, Success>` types, entirely eliminating raw `try-catch` blocks in the UI layer.
* **Callable UseCases**: Business logic (like executing the AI prediction) is encapsulated in strictly typed `UseCase` classes within the Domain layer.

---

## 📂 Folder Structure

The `lib/` directory is structured to reflect the Clean Architecture approach:

```text
lib/
│
├── core/                   # App-wide configurations, constants, and error handling (Failures)
│   ├── errors/             # Custom exception and failure classes
│   └── di/                 # Dependency Injection setup (get_it locator)
│
├── domain/                 # The inner-most layer (Business Logic)
│   ├── entities/           # Core data structures (User inputs)
│   ├── repositories/       # Abstract repository interfaces
│   └── usecases/           # Callable classes (e.g., PredictIncomeUseCase)
│
├── data/                   # Data retrieval and AI model execution
│   ├── models/             # Data transfer objects
│   ├── repositories/       # Implementation of Domain repositories
│   └── datasources/        # Local AI session, feature scaling, and tensor manipulation
│
└── presentation/           # UI Layer
    ├── screens/            # Application pages
    ├── widgets/            # Reusable UI components
    └── state_management/   # State controllers