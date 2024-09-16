This repo contains 2 different analysis on 2 different covid-19 dataset.
# Tableau Visualization

The first project we will be taking some of the SQL queries in CovidQuery.sql and create a visiualization resulted in Dashboard_1.pdf showing us Total Deaths Per Continent and Percent Population Infected Per Country. Guided by Alex the Anaylyst
Link to Dataset that was use in CovidQuery: https://ourworldindata.org/covid-deaths.

# Predict Covid19 Mortality Rate based on Medical history
About this project we had provide a comprehensive analysis inside Predict_Mortality_Rate_based_on_Medical_history.ipynb. But here is the workflow outlines the key steps involved in the process.

## Workflow
### 1. Data Preprocessing
   - **Objective**: Clean the raw dataset and transform it for model training.
   - **Steps**:
     - Filtered invalid or anomalous data (e.g., placeholder values like 98 or 99).
     - Converted categorical variables into binary values (e.g., gender, pneumonia, intubation).
     - Created the target variable `IS_DEAD` to represent patient mortality.
     - Applied feature engineering to generate relevant binary features for various conditions like diabetes, hypertension, and obesity.
     - Ensured proper handling of missing values and dropped unnecessary features.

### 2. Exploratory Data Analysis (EDA)
   - **Objective**: Explore and visualize the data to gain insights.
   - **Steps**:
     - Visualized data distributions for numerical features (e.g., `AGE`) and binary features using histograms and bar plots.
     - Performed correlation analysis with a Pearson correlation matrix heatmap to identify relationships between features.

### 3. Feature Engineering and Feature Selection
   - **Objective**: To create new, meaningful input variables and to select the most relevant features for predictive modeling.
   - **Steps**:
     - Transformed medical history data into binary features (e.g., IS_MALE, HAS_DIABETES, IS_ICU, IS_DEAD) to represent conditions and outcomes more clearly.Convert DATE_DIED into binary feature IS_DEAD to simplify the prediction target
     - Applied `SelectKBest` with ANOVA F-test (`f_classif`) to choose features that are most predictive of mortality.
     - Standardized the features using `StandardScaler` to ensure that continuous variables have a similar scale.

### 4. Data Splitting
   - **Objective**: Split the dataset for training and testing.
   - **Steps**:
     - Split the data into 70% training and 30% testing using `train_test_split`.
     - Ensured that both sets have similar distributions of the target variable.

### 5. Model Building
   - **Objective**: Build multiple machine learning models for mortality prediction.
   - **Models Implemented**:
     - Naive Bayes (Gaussian, Multinomial, Complement, Bernoulli)
     - Decision Tree
     - Random Forest
     - Gradient Boosting
     - Logistic Regression (using various solvers: liblinear, lbfgs, saga, etc.)
     - Feedforward Neural Network (FFNN)
     - Recurrent Neural Network (RNN)
   
### 6. Model Training
   - **Objective**: Train each model on the training data.
   - **Steps**:
     - Trained each model on the training dataset.
     - Implemented **early stopping** and **dropout layers** to prevent overfitting in neural networks.
     - Recorded model training time, accuracy, confusion matrix, and classification report for each model.

### 7. Model Evaluation
   - **Objective**: Evaluate the performance of each model on the testing set.
   - **Metrics**:
     - **Accuracy**: Percentage of correct predictions.
     - **Confusion Matrix**: Analyzed true positives, false positives, true negatives, and false negatives.
     - **Classification Report**: Evaluated precision, recall, and F1-score.
     - **ROC Curve and AUC**: Generated ROC curves and calculated AUC scores to assess the model's performance in distinguishing between classes.

### 8. Overfitting Prevention
   - **Objective**: Apply techniques to minimize overfitting in the models.
   - **Techniques Used**:
     - **Dropout layers** in neural networks to randomly drop units during training.
     - **Regularization** (L2) to add penalties to complex models and encourage generalization.
     - **Early stopping** to halt training when there is no improvement in validation accuracy.

### 9. Model Comparison
   - **Objective**: Compare the models based on their performance.
   - **Steps**:
     - Compared the accuracy, loss curves, and training time for all models.
     - Visualized and compared the training process of the FFNN and RNN using loss and accuracy curves.
     - Selected the best-performing model based on accuracy, AUC, and computational efficiency.


