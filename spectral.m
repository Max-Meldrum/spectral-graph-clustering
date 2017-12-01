#! /usr/bin/octave -qf

arg_list = argv ();
file = arg_list{1};

printf("Running spectral graph clustering algorithm\n");

%% Get content of file
E = csvread(file);

%% Convert edge list to Adjaceny matrix A
col1 = E(:,1);
col2 = E(:,2);
max_ids = max(max(col1,col2));
As = sparse(col1, col2, 1, max_ids, max_ids); 
A = full(As);

%% Print A
%%printf("%i\n", A);

