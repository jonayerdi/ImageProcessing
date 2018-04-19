clear all; close all;

pattern1corners = [178 593; 589 592; 75 963; 529 961];
pattern2corners = [688 593; 1090 592; 640 962; 1091 958];
pattern3corners = [1188 593; 1591 590; 1199 961; 1647 957];
pattern4corners = [1691 590; 2100 586; 1760 959; 2212 956];
patterncorners = [pattern1corners; pattern2corners; pattern3corners; pattern4corners];
patterncount = length(patterncorners)/4;

image = imread('patternsTilted.bmp');
image_gray = rgb2gray(image);

imshow(image, 'InitialMagnification', 'fit'); hold on;
plotcorners(patterncorners);

figure;
for i = 1:patterncount
    pattern = fixperspective(image_gray, patterncorners((i-1)*4+1:i*4,:), [600 600]);
    imwrite(pattern,strcat('img/pattern',num2str(i), '.bmp'));
    subplot(1,patterncount,i);
    imshow(pattern, 'InitialMagnification', 'fit');
end

function [R] = fixperspective(I, C, S) %(image, corners, resultsize)
    X1 = [1 1; S(1) 1; 1 S(2); S(1) S(2)];
    Tform1 = maketform('projective', C, X1);
    R = imtransform(I,Tform1,'Xdata',[1 S(1)],'Ydata',[1 S(2)]);
end

function plotcorners(corners)
    for i = 1:length(corners)
        plot(corners(i,1),corners(i,2),'Marker','.','Color','r','MarkerSize',10);
    end
end
