function [ output ] = ieround( number )
%UNTITLED Summary of this function goes here
%   number =<0.5 output=0
%   number >0.5 output=1
output=0;
if number-0.5>0
    output=1;
end
    



end

