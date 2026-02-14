function [images, labels] = cargarBaseDatosORL(rutaBase, targetSize)
    % Carga y preprocesa la base de datos ORL 
    % rutaBase: Carpeta que contiene las subcarpetas s1, s2... s40
    % targetSize: Vector [filas, columnas]
    
    numPeople = 40; % Definido por el artículo 
    imgsPerPerson = 10; % Definido por el artículo 
    totalImgs = numPeople * imgsPerPerson;
    
    % Pre-asignar matriz de imágenes (Cada columna es una imagen vectorizada)
    % D = targetSize(1) * targetSize(2)
    images = zeros(prod(targetSize), totalImgs);
    labels = zeros(totalImgs, 1);
    
    count = 1;
    fprintf('Cargando imágenes y redimensionando a %dx%d...\n', targetSize(1), targetSize(2));

    for i = 1:numPeople
        folderPath = fullfile(rutaBase, sprintf('s%d', i));
        
        for j = 1:imgsPerPerson
            % Las imágenes ORL suelen ser .pgm 
            imgName = sprintf('%d.pgm', j);
            fullPath = fullfile(folderPath, imgName);
            
            if exist(fullPath, 'file')
                img = imread(fullPath);
                
                % 1. Convertir a double para cálculos precisos
                img = double(img);
                
                % 2. Redimensionar según la recomendación del estudio 
                imgResized = imresize(img, targetSize);
                
                % 3. Vectorizar (convertir matriz 2D en vector columna)
                images(:, count) = imgResized(:);
                labels(count) = i; % Etiqueta de la persona (1 a 40)
                
                count = count + 1;
            else
                warning('No se encontró el archivo: %s', fullPath);
            end
        end
    end
    fprintf('Carga finalizada: %d imágenes procesadas.\n', count-1);
end