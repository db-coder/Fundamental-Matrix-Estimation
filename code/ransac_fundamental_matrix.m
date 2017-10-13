% RANSAC Stencil Code
% CS 4476 / 6476: Computer Vision, Georgia Tech
% Written by Henry Hu

% Find the best fundamental matrix using RANSAC on potentially matching
% points

% 'matches_a' and 'matches_b' are the Nx2 coordinates of the possibly
% matching points from pic_a and pic_b. Each row is a correspondence (e.g.
% row 42 of matches_a is a point that corresponds to row 42 of matches_b.

% 'Best_Fmatrix' is the 3x3 fundamental matrix
% 'inliers_a' and 'inliers_b' are the Mx2 corresponding points (some subset
% of 'matches_a' and 'matches_b') that are inliers with respect to
% Best_Fmatrix.

% For this section, use RANSAC to find the best fundamental matrix by
% randomly sample interest points. You would reuse
% estimate_fundamental_matrix() from part 2 of this assignment.

% If you are trying to produce an uncluttered visualization of epipolar
% lines, you may want to return no more than 30 points for either left or
% right images.

function [ Best_Fmatrix, inliers_a, inliers_b] = ransac_fundamental_matrix(matches_a, matches_b)


%%%%%%%%%%%%%%%%
% Your code here
%%%%%%%%%%%%%%%%

% Your ransac loop should contain a call to 'estimate_fundamental_matrix()'
% that you wrote for part II.

iterations = 1000;
x = 9;
confidence = 0;
threshold = 0.01;

for i = 1:iterations
	index = randsample(size(matches_a,1),x);
	samples_a = matches_a(index,:);
	samples_b = matches_b(index,:);
	F_matrix = estimate_fundamental_matrix(samples_a,samples_b);

	inliers = zeros(size(matches_a,1));
	count = 0;
	for j = 1:size(matches_a,1)
		res = [matches_a(j,:) 1]*F_matrix*[matches_b(j,:),1]';
		if(abs(res) < threshold)
			count = count + 1;
			inliers(j) = 1;
		end
	end
	confidence_ = count;
	if(confidence_ > confidence)
		in = find(inliers);
		inliers_a = matches_a(in,:);
		inliers_b = matches_b(in,:);
		Best_Fmatrix = F_matrix;
		confidence = confidence_;
	end
end
%placeholders, you can delete all of this
% Best_Fmatrix = estimate_fundamental_matrix(matches_a(1:10,:), matches_b(1:10,:));
% inliers_a = matches_a(1:30,:);
% inliers_b = matches_b(1:30,:);

end