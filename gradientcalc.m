function [Gx,Gy,size_x,size_y] = gradientcalc( image)
%gradientcalc
%   Calculates the x and y gradient of a picture

[Gx,Gy]=imgradientxy(image); %sobel gradient operator
size_y=size(Gx,1);
size_x=size(Gx,2);
%Gx=transpose(reshape(Gx.',[1,(size(Gx,1)*size(Gx,2))]));
%Gy=transpose(reshape(Gy.',[1,(size(Gy,1)*size(Gy,2))]));
%imagegradient=[Gx,Gy]; %concatinate xgradient and y gradient for later multiplication

end

