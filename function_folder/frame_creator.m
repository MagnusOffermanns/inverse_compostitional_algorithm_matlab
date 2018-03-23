function [ original_points_framed ] = frame_creator( original_points,translation_vector )
%frame_creator creates a square frame of 4 points around the given points
%   Detailed explanation goes here

 
 
 original_points(1:2,:)=bsxfun(@minus,original_points(1:2,:),translation_vector(1:2));
 max_vector=max(original_points(1:2,:),[],2);
 min_vector=min(original_points(1:2,:),[],2);
 
%frames the picture so that all sides are not the same 
%  A=[min_vector(1);max_vector(2);1;0];
%  B=[max_vector;1;0];
%  C=[max_vector(1);min_vector(2);1;0];
%  D=[min_vector;1;0];

%frames the picture that all sides are the same length (max dist in x and y)
max_vector1=max([max_vector abs(min_vector)],[],2);
%requires a tripple check
A=[max_vector1;1;0];
B=[-max_vector1(1);max_vector1(2);1;0];
C=[max_vector1(1);-max_vector1(2);1;0];
D=[-max_vector1;1;0];

framepoints=[A,B,C,D]; 
original_points_framed=[framepoints(:,~ismember(framepoints(1:2,:)',original_points(1:2,:)','rows')),original_points];
%scatter(original_points_framed(1,:),original_points_framed(2,:))
%axis ij
end

