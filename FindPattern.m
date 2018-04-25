clear all; close all;

%Parameters for patternsTilted.bmp
%colorThreshold = 80;
%numPeaks = 4; threshold = 0.5; fillGap = 1; minLength = 300;

%Parameters for pattern1Photo.bmp
colorThreshold = 150;
numPeaks = 15; threshold = 0.5; fillGap = 10; minLength = 600;
minRadius = 25; maxRadius = 35;

I = imread('pattern1Photo.bmp');
try
    grayI = rgb2gray(I);
catch
    grayI = I;
end

[centers, radii] = imfindcircles(grayI, [minRadius, maxRadius]);

BW = grayI>colorThreshold;
mascara=ones(9,9)/81;
BW_Horiz=conv2(mascara,abs(diff(BW)));
BW_Vert=conv2(mascara,abs(diff(BW')))';

try
BW_Vert = BW_Vert(1:length(BW_Horiz(:,1)),:);
end
try
BW_Vert = BW_Vert(:,1:length(BW_Horiz(1,:)));
end
try
BW_Horiz = BW_Horiz(1:length(BW_Vert(:,1)),:);
end
try
BW_Horiz = BW_Horiz(:,1:length(BW_Vert(1,:)));
end

BW1 = BW_Horiz + BW_Vert;

[H,T,R] = hough(BW1);
P  = houghpeaks(H,numPeaks,'threshold',ceil(threshold*max(H(:))));
x = T(P(:,2)); y = R(P(:,1));
plot(x,y,'s','color','white');
lines = houghlines(BW1,T,R,P,'FillGap', fillGap,'MinLength', minLength);

imshow(I, 'InitialMagnification', 'fit'), hold on;

viscircles(centers, radii, 'color', 'red');

max_len = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end
