#! /usr/bin/octave -qf

pkg load statistics

%% Step 1 - Form affinity matrix A
%% Step 2 - Define diagonal matrix D and Construct matrix L
%% Step 3 - Find x1,x2,..., xk, the larget k eigenvectors of L, and form matrix X
%% Step 4 - From the matrix Y from X by renormalizing each of X's rows to have unit length
%% Step 5 - Cluster into k clusters via K-means or any similar approach
%% Step 6 - Assign original point si to cluster j if and only if row i of the matrix Y was assigned to cluster j


arg_list = argv ();
file = arg_list{1};

printf("Running spectral graph clustering algorithm\n");

%% Get content of file
E = csvread(file);

%% Step 1
%% Convert edge list to Adjaceny matrix A
col1 = E(:,1);
col2 = E(:,2);
max_ids = max(max(col1,col2));
As = sparse(col1, col2, 1, max_ids, max_ids); 
A = full(As);

%% Step 2
%% Get Degree Matrix
D = diag(sum(A, 2));

NewD = mpower(D, -0.5);
AD = NewD*A;
%%  L = D^{-1/2} AD{-1/2}
L = NewD*AD;

%% Step 3
K = 2;
%% lm is set as default
[X, ~] = eigs(L, K);

%% Step 4

%% Renormalize, taken from net
N = size(A,1);
Y = zeros(size(X));
for i=1:N
	denominator = norm(X(i,:));
	for j=1:K
		Y(i,j) = X(i,j)/denominator;
	end
end

%% Step 5

[idx, ~] = kmeans(Y, K);

%% Step 6
color = {'m', 'b', 'c','r','y'};
hold on;
for i=1:size(A,1)
  c = idx(i,1);
  for j=1:size(A,2)  
    if A(i,j) == 1
        plot(i,j,'color', color{c}, 'marker', '*');
    end  
  end  
end
hold off;
print -djpg output.jpg
