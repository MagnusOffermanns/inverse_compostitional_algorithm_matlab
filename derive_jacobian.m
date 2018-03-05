clear all
close all
syms x y p1 p2 p3 p4 p5 p6 %(x coordinate, y coordinate,x translation, y translation,z translation, rotation x, rotation y, rotation z)

vector=[x;y;1];
vector=[(1+p3);(1+p3);1].*vector


%rotations
rotationmatrix=eye(3);
rotationmatrix=rotationmatrix*[cos(p6),-sin(p6),0;sin(p6),cos(p6),0;0,0,1]; %rotation z
%rotationmatrix=rotationmatrix*[1,0,0;0,cos(p4),-sin(p4);0,sin(p4),cos(p4)]; %rotationmatrix x
%rotationmatrix=rotationmatrix*[cos(p5),0,sin(p5);0,1,0;-sin(p5),0,cos(p5)]; %rotationmatrix y
vector=rotationmatrix*vector;

%translation by x (p1) and y p2
%vector=vector+[p1;p2;0];

% projection back on ground plane
%vector=vector/vector(3);

%jacobian caculation
jacobian_vector=jacobian(vector,[p1,p2,p3,p4,p5,p6]);
non_substituted_jacobian=jacobian_vector;

%substitiution with p1..6 with 0 since this is the jacobian we need for the
%inverse compostional algorithms
end_jacobian=subs(jacobian_vector,[p1,p2,p3,p4,p5,p6],[0,0,0,0,0,0])

%fuer die latex herleitung
rotationmatrix=[1,0,0;0,cos(p4),-sin(p4);0,sin(p4),cos(p4)]; %rotationmatrix x
rotationmatrix=rotationmatrix*[cos(p5),0,sin(p5);0,1,0;-sin(p5),0,cos(p5)]; %rotationmatrix y
rotationmatrix=rotationmatrix*[cos(p4),-sin(p6),0;sin(p6),cos(p6),0;0,0,1]; %rotationmatrix z
P13=[p1;p2;p3];
vector=[x;y;1];
proj=[0 0 1]*(rotationmatrix*vector+P13);
P13quote=jacobian(P13,[p1,p2,p3,p4,p5,p6]);
%calculation of the first term
first=(P13quote*proj);
projquote=jacobian(proj,[p1,p2,p3,p4,p5,p6]);
second=P13*projquote
first_part=(first-second)/(proj^2)

%calculation of the second term
third=rotationmatrix*vector
third=jacobian(third,[p1,p2,p3,p4,p5,p6])
third=third*proj

fourth=(rotationmatrix*vector)*projquote
second_part=(third-fourth)/(proj^2)

full_result=first_part+second_part

end_result=subs(full_result,[p1,p2,p3,p4,p5,p6],[0,0,0,0,0,0])



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