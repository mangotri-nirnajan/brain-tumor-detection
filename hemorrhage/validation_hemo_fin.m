datasetFolder = 'E:\Acdemics\EBS CBE\21ES603 - Signal & Image Processing\Term Project\HEMORRHAGE\Hemorrhagic';
%datasetFolder='E:\Acdemics\EBS CBE\21ES603 - Signal & Image Processing\Term Project\archive\NO_validation'
% Initialize counters for azccuracy calculation
totalImages = 0;
hemorrhageDetected = 0;


imageFiles = dir(fullfile(datasetFolder, '*.jpg')); % Get a list of all image files in the folder Update the file extension if needed

for k = 1:length(imageFiles)
    % Read the CT scan image
    imagePath = fullfile(datasetFolder, imageFiles(k).name);
    inputImage = imread(imagePath);
    image = imresize(inputImage, [512, 512]);

    % Convert the image to grayscale
    grayImage = rgb2gray(image);

    % Apply Gaussian smoothing
    smoothedImage = imgaussfilt(grayImage, 2);

    % Apply edge detection using the Sobel operator
    edgeImage = edge(smoothedImage, 'sobel');
    

    % Use morphological operations to enhance edges
    se = strel('disk', 5);
    edgeImage = imdilate(edgeImage, se);

    % Thresholding to segment the image
    threshold = 150; % Adjust this threshold based on your observations
    segmentedImage = smoothedImage > threshold;

    % Calculate the area of the segmented regions
    stats = regionprops(segmentedImage, 'Area');

    % Print the areas of the identified segments
    totalArea = 0;
    for i = 1:length(stats)
        %fprintf('Segment %d Area: %d\n', i, stats(i).Area);
        totalArea = totalArea + stats(i).Area;
    end
    fprintf('Total Area of all Segments: %d\n', totalArea);

    % Use a threshold to determine if there is hemorrhage
    areaThreshold = 19000; % Adjust this threshold based on your observations
    if any([stats.Area] > areaThreshold)
        disp('The brain sample has hemorrhage.');
        hemorrhageDetected = hemorrhageDetected + 1;
    else
        disp('No hemorrhage detected.');
    end

    totalImages = totalImages + 1;
end

% Calculate and display the percentage of accuracy
accuracy = (hemorrhageDetected / totalImages) * 100;
hemorrhageDetected
totalImages
fprintf('Accuracy: %.2f%%\n', accuracy);
