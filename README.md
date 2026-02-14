# Facial Recognition with PCA and Machine Learning Methods

This project implements a facial recognition system in MATLAB based on the research by **Chen and Jenkins**.
It utilizes **Principal Component Analysis (PCA)** for dimensionality reduction and **Linear Regression Classification (LRC)** for identification.

## 📋 Project Overview
* **Institution:** Universidad Rey Juan Carlos (Escuela de Ingeniería de Fuenlabrada).
* **Author:** Gonzalo Pacheco Agredano.
* **Objective:** Efficiently reduce facial image dimensionality without losing essential classification data.
* **Accuracy:** 98.25% using the Leave-One-Out (LOO) validation technique.

## ⚙️ Methodology

### 1. Database
The system uses the **ORL Face Database**:
* **Subjects:** 40 distinct individuals.
* **Samples:** 10 images per person (400 total).
* **Variations:** Includes changes in lighting, facial expressions, and accessories like glasses.

### 2. Preprocessing
[cite_start]To balance speed and precision, original images of $92 \times 112$ pixels are resized to a resolution of $20 \times 20$ pixels.

### 3. Feature Extraction (PCA)
* [cite_start]Data is centered by subtracting the average image from each sample.
* [cite_start]Eigenfaces are calculated through the covariance matrix.
* [cite_start]**50 principal components** are selected for the final projection.

### 4. Classification (LRC)
* The test image is projected onto the subspace of training images for each class.
* The system assigns the identity of the class with the **minimum reconstruction error (residue)**.

## 📊 Experimental Results
The system achieved high stability and performance:
* **Accuracy:** 98.25%.
* **Error Rate:** 1.75%.
* **Tolerance:** System remains robust up to lateral rotations of 20 degrees.

---

## 🚀 How to Run

1. ##Clone the repository:
   ```bash
   git clone [https://github.com/gonzaloop1494/facial-recognition-with-PCA.git](https://github.com/gonzaloop1494/facial-recognition-with-PCA.git)
2. ##Prepare the environment:

    Open MATLAB.

    Ensure the ORL Face Database is in your project directory.

3. ##Execution:

    Run cargarBaseDatosORL.m to load the images.

    Run main.m to perform the PCA extraction, LRC classification, and view the accuracy results.

   References

    [1] J. Chen and W. K. Jenkins, "Facial recognition with pca and machine learning methods," in 2017 IEEE 60th international Midwest symposium on circuits and systems (MWSCAS).
