function [ transformed_coordinates ] = UL2middle( y,x,T)
%UL2middle makes a coordinate transformation of the 0/0 in the upper left
%corner to the middle
%   Detailed explanation goes here
size_whole=size(T.Data); %size of the whole picture
transformed_coordinates=[y-(size_whole(1)/2),x-(size_whole(2)/2)];



end

