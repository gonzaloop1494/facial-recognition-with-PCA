%% Reconocimiento Facial con PCA y LRC
% Alumno: Gonzalo Pacheco Agredano

clear all; clc; close all;

%% 1. CONFIGURACIÓN Y CARGA DE DATOS 
% Parámetros según el estudio para equilibrio velocidad/precisión 
targetSize = [20, 20]; 
numPeople = 40; 
imgsPerPerson = 10; 
totalImgs = numPeople * imgsPerPerson;

% Carga de imágenes (Debes tener la función cargarBaseDatosORL.m)
rutaBase = './orl_faces'; 
[images, labels] = cargarBaseDatosORL(rutaBase, targetSize);

%% 2. EVALUACIÓN LEAVE-ONE-OUT (LOO) 
predictedLabels = zeros(totalImgs, 1);

fprintf('Iniciando evaluación Leave-One-Out...\n');

for i = 1:totalImgs
    % Separación del conjunto de datos: 1 muestra para test, el resto para entrenamiento
    testImg = images(:, i);
    testLabel = labels(i);
    
    trainImgs = images; 
    trainImgs(:, i) = [];
    trainLabels = labels; 
    trainLabels(i) = [];
    
    %% 3. ETAPA 1: PCA (EXTRACCIÓN DE CARACTERÍSTICAS) 
    % Media y centrado de los datos 
    A = mean(trainImgs, 2); 
    Y = trainImgs - A; 
    
    % Cálculo de Eigenfaces 
    [V, D] = eigs(Y' * Y, 50); % Obtenemos los 50 autovectores principales 
    eigenfaces = Y * V; % Proyección al espacio de alta dimensión
    eigenfaces = normc(eigenfaces); % Normalización
    
    % Proyectar datos de entrenamiento y test al espacio PCA
    trainFeatures = eigenfaces' * (trainImgs - A);
    testFeatures = eigenfaces' * (testImg - A);
    
    %% 4. ETAPA 2: CLASIFICACIÓN LRC (Linear Regression Classification) 
    % El algoritmo LRC asocia el test con la clase que minimiza el error de reconstrucción.
    distances = zeros(numPeople, 1);
    
    for classIdx = 1:numPeople
        % Obtener solo las muestras de entrenamiento de la clase actual
        classMask = (trainLabels == classIdx);
        Xi = trainFeatures(:, classMask);
        
        % Resolver el problema de mínimos cuadrados: y = Xi * beta
        % beta = (Xi' * Xi)^-1 * Xi' * y
        beta = pinv(Xi) * testFeatures;
        
        % Calcular la imagen reconstruida y el error 
        reconstruction = Xi * beta;
        distances(classIdx) = norm(testFeatures - reconstruction);
    end
    
    % La predicción es la clase con el residuo mínimo
    [~, predictedLabels(i)] = min(distances);
end

%% 5. MÉTRICAS DE EVALUACIÓN Y RESULTADOS 
accuracy = sum(predictedLabels == labels) / totalImgs * 100;
errorRate = 100 - accuracy;

fprintf('\n--- RESULTADOS FINALES ---\n');
fprintf('Tasa de Acierto (Accuracy): %.2f%%\n', accuracy);
fprintf('Tasa de Error: %.2f%%\n', errorRate);

% Visualización de la Matriz de Confusión 
figure('Name', 'Evaluación del Clasificador LRC');
confusionchart(labels, predictedLabels);
title(sprintf('Matriz de Confusión: PCA + LRC (Acierto: %.2f%%)', accuracy));