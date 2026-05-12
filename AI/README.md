#  Income-Insights: Machine Learning Pipeline

![Python](https://img.shields.io/badge/Python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54)
![scikit-learn](https://img.shields.io/badge/scikit--learn-%23F7931E.svg?style=for-the-badge&logo=scikit-learn&logoColor=white)
![XGBoost](https://img.shields.io/badge/XGBoost-1D9D58?style=for-the-badge&logo=xgboost&logoColor=white)
![Pandas](https://img.shields.io/badge/pandas-%23150458.svg?style=for-the-badge&logo=pandas&logoColor=white)

This directory contains the complete Data Science and Machine Learning workflow for the **Income-Insights** project. The primary objective of this pipeline is to process raw demographic and employment data to predict whether an individual earns more than $50K annually (`>50K` or `<=50K`).

---

##  Data Science Workflow

The pipeline is designed with a strong emphasis on data quality, robust feature extraction, and rigorous model evaluation to ensure high accuracy and generalization.

### 1. Data Cleaning & Preprocessing
* **Missing Values:** Identified and handled hidden missing values (represented as `?` in the dataset) by replacing them with `NaN` and utilizing appropriate imputation strategies.
* **Duplicate Removal:** Cleaned the dataset from exact duplicate rows to prevent data leakage and overfitting.

### 2. Advanced Feature Engineering
To maximize the predictive power of the models, several new features and interaction terms were mathematically and logically derived from the raw data:
* **Mathematical Transformations:** Created `edu_hours` (Education Num × Hours per week) and `capital-net` (Capital Gain - Capital Loss).
* **Logical Flags:** Engineered binary flags such as `has_capital_activity`, `is_high_salary_job`, and `has-investments`.
* **Interaction Features:** Combined existing columns to capture complex relationships, e.g., `work_edu_interaction` (Work class + Education), and `rich_country_hard_worker` (Specific native countries + Above-average working hours).
* **Binning:** Grouped continuous variables into categories (e.g., `age_group`, `work-intensity`).
* **Log Transformation:** Applied `np.log1p` to skewed numerical features like capital gains/losses.

### 3. Data Transformation & Scaling
* **Target Encoding:** Used `TargetEncoder` from `category_encoders` for high-cardinality categorical features (like Work Class, Marital Status, etc.) to capture their relationship with the target variable.
* **Robust Scaling:** Applied `RobustScaler` to numerical columns to mitigate the negative impact of outliers.

### 4. Handling Class Imbalance
The dataset exhibited a significant class imbalance (the majority earning `<=50K`). To prevent the models from becoming biased, we applied **SMOTE** (Synthetic Minority Over-sampling Technique) strictly on the training set. This generated synthetic data points for the minority class, ensuring the models learned the underlying patterns of high-income earners effectively.

---

##  Model Training & Evaluation

We conducted extensive experiments using a variety of algorithms. Each model underwent hyperparameter tuning using `RandomizedSearchCV` (optimized for `F1-Score` to account for the imbalanced nature of the problem) and 3-to-5 fold Cross-Validation.

**Models Evaluated:**
1. Random Forest Classifier
2. Logistic Regression (liblinear, L1/L2 penalties)
3. Support Vector Machines (SVM - RBF & Linear kernels)
4. Decision Tree Classifier
5. XGBoost Classifier
6. **Custom Stacking Meta-Model:** A powerful ensemble model combining predictions from RF, XGB, LR, SVM, and DT, using a Logistic Regression meta-classifier.

###  Final Selection: XGBoost
After comparing the performance across all algorithms on an isolated Test Set, the **XGBoost Classifier** was selected as the optimal model. It provided the best balance between high predictive accuracy (Accuracy & F1-Score) and inference speed (which is critical for the final mobile deployment).

---

##  Exported Artifacts

For production and deployment purposes, the finalized data processors and the trained model were serialized using `pickle` (or `joblib`). These artifacts ensure that the exact training environment is replicated during inference:

* `best_xgb_model.pkl`: The optimized XGBoost classifier.
* `target_encoder.pkl`: The fitted categorical target encoder.
* `scaler.pkl`: The fitted robust scaler for numerical data.

---

##  How to Use (Local Setup)

1. **Install Dependencies:**
   Ensure you have Python 3.8+ installed. Install the required libraries via:
   ```bash
   pip install pandas numpy scikit-learn matplotlib seaborn xgboost category_encoders imbalanced-learn missingno