clear all
close all
syms x y p1 p2 p3 p4 p5 p6 %(x coordinate, y coordinate,x translation, y translation,scale, rotation z, rotation y, rotation x)
vector=[x*(1+p3);y*(1+p3);1];

%rotations
rotationmatrix=[cos(p4),-sin(p4),0;sin(p4),cos(p4),0;0,0,1]; %rotationmatrix z
rotationmatrix=rotationmatrix*[cos(p5),0,sin(p5);0,1,0;-sin(p5),0,cos(p5)]; %rotationmatrix y
rotationmatrix=rotationmatrix*[1,0,0;0,cos(p6),-sin(p6);0,sin(p6),cos(p6)]; %rotationmatrix x
vector=rotationmatrix*vector;

%translation by x (p1) and y p2
vector=vector+[p1;p2;0];

% projection back on ground plane
vector=vector/vector(3);

%jacobian caculation
jacobian_vector=jacobian(vector,[p1,p2,p3,p4,p5,p6]);
non_substituted_jacobian=jacobian_vector;

%substitiution with p1..6 with 0 since this is the jacobian we need for the
%inverse compostional algorithms
end_jacobian=subs(jacobian_vector,[p1,p2,p3,p4,p5,p6],[0,0,0,0,0,0])

%TODO
%mandatory
%- related work
%- derivation of jacobian by hand
%- working 3d testdata generation (gaps in resulting generated image are
%acceptable as long as they are ignored in the calculation, e.g. ignore all
%intensity values of 0; either use last found value or mean of multiple
%values mapped to the same pixel, whatever is the best in terms of needed
%implementation time versus quality of result); also set correct center of
%rotation
%
%optional (but highly appreciated)
%- working 6dof image alignment
%- derivation of jacobian by hand - thorough explaination in latex; will
%later be migrated into corresponding chapter in master thesis