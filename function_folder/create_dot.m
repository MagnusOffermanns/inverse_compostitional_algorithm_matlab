function [ dot ] = create_dot( size_dot )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
if mod(size_dot,2)==1
    cross=0;
    return 
end

dot=zeros(size_dot);

dot(size(dot,1)/2+1,size(dot,2)/2+1)=1;
dot(size(dot,1)/2,size(dot,2)/2)=1;
dot(size(dot,1)/2,size(dot,2)/2+1)=1;
dot(size(dot,1)/2+1,size(dot,2)/2)=1;

end

