#  Income-Insights: Offline AI Prediction App

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54)
![scikit-learn](https://img.shields.io/badge/scikit--learn-%23F7931E.svg?style=for-the-badge&logo=scikit-learn&logoColor=white)
![XGBoost](https://img.shields.io/badge/XGBoost-1D9D58?style=for-the-badge&logo=xgboost&logoColor=white)

An end-to-end Machine Learning project deployed as a cross-platform Flutter application. **Income-Insights** predicts whether an individual's income exceeds $50K/year based on demographic and employment data. The defining feature of this project is its **100% offline inference capability**, seamlessly integrating a highly optimized AI model directly into the mobile device.

---

##  Machine Learning Pipeline

The core of this project is a rigorous Data Science pipeline developed in Python, focusing on feature extraction, handling data imbalance, and extensive model evaluation.

### 1. Advanced Feature Engineering & Preprocessing
To maximize the predictive power of the dataset, several transformations were applied:
* **Custom Features:** Engineered highly correlated features such as `edu_hours` (Education × Hours per week), `capital-net`, and interaction terms (`work_edu_interaction`, `relation-position`).
* **Categorical Encoding:** Utilized `TargetEncoder` for high-cardinality categorical variables to capture the target variable's distribution within categories.
* **Numerical Scaling:** Applied `RobustScaler` to numerical columns to handle outliers effectively.
* **Log Transformations:** Applied `np.log1p` to skewed features like `capital-gain` and `capital-loss`.

### 2. Handling Class Imbalance
The initial dataset was highly skewed towards the `<=50K` class. We utilized **SMOTE** (Synthetic Minority Over-sampling Technique) strictly on the training set to generate synthetic samples, ensuring the model does not become biased toward the majority class.

### 3. Model Training & Selection
Multiple algorithms were trained, tuned using `RandomizedSearchCV`, and rigorously evaluated against a separate validation/test set. The evaluated models included:
* **Random Forest** (with class-weight balancing)
* **Logistic Regression** (L1/L2 penalties, liblinear solver)
* **Support Vector Machines (SVM)**
* **Decision Trees**
* **Custom Stacking Classifier** (Meta-model utilizing predictions from all the above)

** Winning Model:Custom Stacking Classifier**
After extensive hyperparameter tuning (learning rate, max depth, subsample, etc.), the `Custom Stacking Classifier` proved to be the most efficient and accurate for our specific use case, balancing inference speed and high F1-Score.

---

##   Mobile Architecture (Flutter)

To make the AI accessible, we built a Flutter frontend that runs the exported model natively on the device, ensuring privacy and zero latency.

### Offline Inference
The final XGBoost model, along with the `TargetEncoder` and `RobustScaler` configurations, was exported and integrated into the Flutter application. 
* The app captures user input and locally reconstructs the necessary tensors.
* It performs the mathematical scaling and encoding on-device.
* Feeds the processed data into the offline ML runtime to instantly generate the >$50K or <=$50K prediction.

### Clean Architecture
The codebase strictly adheres to **Clean Architecture** principles to ensure maintainability and separation of concerns:
* **Presentation Layer:** Reactive UI handling user inputs.
* **Domain Layer:** Contains core business logic. We utilize **Callable `UseCase` classes** to execute the ML predictions cleanly.
* **Data Layer:** Handles the local AI session and tensor manipulations.
* **State Management & Error Handling:** Utilizes `get_it` for Dependency Injection and `dartz` for functional error handling (Either types), ensuring that edge cases during model inference are handled gracefully.

---

##  Repository Structure
```text
Income-Insights/
│
├── AI_Model/                   # Data Science Workspace
│   ├── Notebook/              # EDA, Training, and Evaluation scripts
│   └── Exported Models/        # stacked_model artifacts
│
├── Flutter_App/                # Mobile Source Code
│   ├── lib/
│   │   ├── core/               # Error handling (dartz), DI (get_it)
│   │   ├── domain/             # Entities and ML UseCases
│   │   ├── data/               # On-device inference repositories
│   │   └── presentation/       # UI Components
│   |   └── assets/                 # Embedded ML models
│
└── README.md
