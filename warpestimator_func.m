function [ warp_param] = warpestimator_func(T,I)
%warpestimator_func estimates the translation parameters based on two pictures T and I 
%   Detailed explanation goes here
%profile on;

warp_param=[0,0,0,0]; %[x-translation,y-translation,scale,rotation]
%precalculations
[Gx,Gy]=gradientcalc(T.Data_snippet);%gradient bedenken 
gradient_times_jacobian=calcjacobiantimesgradient(Gx,Gy,T); %gradient times jacobian at x=0 %chagned
hessian=calc_hessian(gradient_times_jacobian); 


%warpablepicI=pic2warpablepic(I); % brings the picture in a state so that 
                                             %a warp can be applied

runtime=150;
global error_vector;
error_vector = -1*ones(1,runtime);
cleanupObj = onCleanup(@()cleanMeUp());
error_plot_flag=0;
for ii=1:runtime% does the estimation 100 times since I dont know the estimated error 

[I_temp]=warp_func(warp_param,I);

%[Gx,Gy,size_x,size_y]=gradientcalc(effektive_picture_scaled); %muss nicht gewarped werden da es gleich gross ist wie I und die Border sich gleich verschiebt


[delta_p,error_num]=calc_delta_p(T,I_temp,hessian,gradient_times_jacobian,error_plot_flag);
error_vector(ii)=error_num;

error_plot_flag=0;


warp_param=warp_param+transpose(delta_p);
update=['xtranslation: ',num2str(warp_param(1)),'  y translation: ', num2str(warp_param(2)), '  scale: ', num2str(warp_param(3)),'  rotation: ', num2str(warp_param(4)),' iteration: ',num2str(ii)];
disp(update);
end
%updates the warp parameter

figure
plot(error_vector);
debug_func(T,I,warp_param);
%profile viewer

end


function [] = cleanMeUp()
%cleanMeUP gets executed if controll-c is pressed 

global error_vector;
figure
error_vector=error_vector(error_vector~=-1);
plot(error_vector);


end


