function [ rect_image ] = paint_rect(sizepicx,sizepicy,picture,xstart,ystart,height,width,newpicture,fillvalue)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

rect_image=picture;

if newpicture == 1
rect_image=zeros(sizepicy,sizepicx);
end
    



for n=1+xstart:1:xstart+width
    for m=1+ystart:1:ystart+height
        rect_image(m,n)=fillvalue;
    end


end

