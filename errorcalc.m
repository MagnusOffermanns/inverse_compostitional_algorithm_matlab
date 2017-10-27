function [ error ] = errorcalc(warpableT,warpableI)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

picI=warpablepic2pic(warpableI,0,0);
picT=warpablepic2pic(warpableT,size(picI,2),size(picI,1));
error=(picI-picT).^2;
error=sum(sum(error));

end

