function [ cross ] = create_cross(size_y,size_x)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if mod(size_x,2)==1 || mod(size_y,2)==1
    cross=0;
    return 
end
first_quarter=zeros(size_y/2-1,size_x/2-1);
white_line_horz=ones(2,size(first_quarter,2));
one_half=[first_quarter;white_line_horz;first_quarter];
white_line_vert=ones(size(one_half,1),2);
cross=[one_half,white_line_vert,one_half];
end

