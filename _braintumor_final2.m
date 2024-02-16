
% Specify the path to the image file
imagePath = "<path of image file>"
% Read the image
image = imread(imagePath);

% Convert the image to grayscale
gray_image = im2gray(image);

% Convert the grayscale image to binary using a threshold
bw = im2bw(image, 0.6);

% Label connected components in the binary image
label = bwlabel(bw);

% Apply Wiener2 denoising to the labeled image
denoised_img = wiener2(label, [5, 5]);

% Compute region properties (area and bounding box) for the labeled image
stats = regionprops(label, 'Area', 'BoundingBox');
area = [stats.Area];
bounding_boxes = {stats.BoundingBox};

% Compute aspect ratios for each bounding box
aspect_ratios = zeros(size(bounding_boxes));
for i = 1:numel(bounding_boxes)
    aspect_ratios(i) = bounding_boxes{i}(3) / bounding_boxes{i}(4);
end

% Define criteria for potential tumor regions
high_area_region = area > 500;
reasonable_aspect_ratio = aspect_ratios > 0.5 & aspect_ratios < 2;
potential_tumor_regions = high_area_region & reasonable_aspect_ratio;

% Find the maximum area among potential tumor regions
max_area = max(area(potential_tumor_regions));

% Set a threshold for tumor detection
area_threshold = 2000;

% Check if a tumor is detected based on the maximum area
if max_area > area_threshold
    tumor_label = find(area == max_area);
    fprintf('Tumor detected in region %d with area %d.\n', tumor_label, max_area);
    tumor = ismember(label, tumor_label);
else
    fprintf('No tumor detected.\n');
    tumor = zeros(size(label));
end

% Create a structuring element for dilation
se = strel('square', 5);

% Dilate the detected tumor region
tumor = imdilate(tumor, se);

% Display the original image, the isolated tumor region, and the detected tumor boundaries
figure;
subplot(1, 3, 1);
imshow(image, []);
title('Brain');

subplot(1, 3, 2);
imshow(tumor, []);
title('Tumor Alone');

% Find and plot boundaries of the detected tumor region on the original image
[B, L] = bwboundaries(tumor, 'noholes');
subplot(1, 3, 3);
imshow(image, []);
hold on
for i = 1:length(B)
    plot(B{i}(:, 2), B{i}(:, 1), 'y', 'linewidth', 1.45);
end
title('Detected Tumor');
