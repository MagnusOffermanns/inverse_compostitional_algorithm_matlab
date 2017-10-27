function [ delta_p,error_num ] = calc_delta_p(T_Data,I_Data,hessian,gradient_times_jacobian,plot_flag)
%calc_delta_p Calculates the 
%   Detailed explanation goes here
delta_p=zeros(size(gradient_times_jacobian,2),1);
error_num=0;

%to plot the error
% if plot_flag==1
% ploterror=zeros(size_picy,size_picx);
% end


for yy=1:size(T_Data,1)
    for xx=1:size(T_Data,2)
        error_num=error_num+double(T_Data(yy,xx)-I_Data(yy,xx));
        %error_num=error_num+double((T(yy+border_y,xx+border_x)-I(yy+w_border_y,xx+w_border_x)));%calculation of the error at pixel xx,yy
        
        delta_p=delta_p+transpose(gradient_times_jacobian(((yy-1)*size(T_Data,2)+xx),:))*double((T_Data(yy,xx)-I_Data(yy,xx))); %calculation of formular 10
        
    end
end
delta_p=pinv(hessian)*delta_p;



end

