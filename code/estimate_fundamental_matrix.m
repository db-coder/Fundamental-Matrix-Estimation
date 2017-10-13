% Fundamental Matrix Stencil Code
% CS 4476 / 6476: Computer Vision, Georgia Tech
% Written by Henry Hu

% Returns the camera center matrix for a given projection matrix

% 'Points_a' is nx2 matrix of 2D coordinate of points on Image A
% 'Points_b' is nx2 matrix of 2D coordinate of points on Image B
% 'F_matrix' is 3x3 fundamental matrix

% Try to implement this function as efficiently as possible. It will be
% called repeatly for part III of the project

function [ F_matrix ] = estimate_fundamental_matrix(Points_a,Points_b)

%%%%%%%%%%%%%%%%
% Your code here
%%%%%%%%%%%%%%%%

% Extra Credit
mean_a = mean(Points_a);
Ta = [1 0 -1*mean_a(1);0 1 -1*mean_a(2);0 0 1];
temp = Points_a - repmat(mean_a,size(Points_a,1),1);
s = 1/std2(temp);
Sa = [s 0 0;0 s 0;0 0 1];

temp = zeros(size(Points_a,1),3);
for i = 1:size(Points_a,1)
	temp(i,:) = Sa*Ta*[Points_a(i,1);Points_a(i,2);1];
end
Points_a = temp(:,1:2);

mean_b = mean(Points_b);
Tb = [1 0 -1*mean_b(1);0 1 -1*mean_b(2);0 0 1];
temp = Points_b - repmat(mean_b,size(Points_b,1),1);
s = 1/std2(temp);
Sb = [s 0 0;0 s 0;0 0 1];

temp = zeros(size(Points_b,1),3);
for i = 1:size(Points_b,1)
	temp(i,:) = Sb*Tb*[Points_b(i,1);Points_b(i,2);1];
end
Points_b = temp(:,1:2);

A = zeros(size(Points_a,1),9);
for i = 1:size(Points_a,1)
	A(i,:) = [Points_a(i,1)*Points_b(i,1) Points_a(i,1)*Points_b(i,2) Points_a(i,1) Points_a(i,2)*Points_b(i,1) Points_a(i,2)*Points_b(i,2) Points_a(i,2) Points_b(i,1) Points_b(i,2) 1];
end
[~,~,V] = svd(A);
f = V(:,end);
F = reshape(f,[3,3])';

[U,S,V] = svd(F);
S(3,3) = 0;
F_matrix = U*S*V';

F_matrix = (Sb*Tb)'*F_matrix*(Sa*Ta);     
end