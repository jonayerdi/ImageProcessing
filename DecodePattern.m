clear all; close all;

image_list = ['pattern1.bmp'; 'pattern2.bmp'; 'pattern3.bmp'; 'pattern4.bmp'];

for i = 1:length(image_list(:,1))
    image = imread(image_list(i,:));
    try
        image_gray = rgb2gray(image);
    catch
        image_gray = image;
    end
    pattern = decodepattern(image_gray, 7, 7, 0.4);
    
    figure;
    subplot(1,2,1);
    imshow(image, 'InitialMagnification', 'fit');
    title('Image','FontSize',12);
    subplot(1,2,2);
    imshow(pattern, 'InitialMagnification', 'fit');
    title('Decoded','FontSize',12);
end

function [pattern, tile_color] = decodepattern(image, pattern_height, pattern_width, threshold)
    pattern = zeros(pattern_height, pattern_width);
    tile_color = zeros(pattern_height, pattern_width);
    image_height = length(image(:,1));
    image_width = length(image(1,:));

    color_min = min(image(:));
    color_max = max(image(:));
    color_boundary = color_min + (color_max - color_min) * threshold;

    for pattern_y = 1:pattern_height
        for pattern_x = 1:pattern_width
            start_y = round((pattern_y-1) * image_height / pattern_height + 1);
            stop_y = round((pattern_y) * image_height / pattern_height);
            start_x = round((pattern_x-1) * image_width / pattern_width + 1);
            stop_x = round((pattern_x) * image_width / pattern_width);
            tile_color(pattern_y, pattern_x) = mean(mean(image(start_y:stop_y, start_x:stop_x)));
            if tile_color(pattern_y, pattern_x) < color_boundary
                pattern(pattern_y, pattern_x) = 0;
            else
                pattern(pattern_y, pattern_x) = 1;
            end
        end
    end
end
