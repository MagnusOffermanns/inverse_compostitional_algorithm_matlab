function [ size ] = calc_size_operated_picture( picture )
%calc_size_operated_picture is a function to calculate the size of the
%picture within the defined border
%   Detailed explanation goes here


size(2)=-picture.D(2)+picture.C(2);
size(1)=picture.D(1)-picture.A(1)


end

