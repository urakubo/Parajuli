
%%%
%%%
function exec_sim_dend
%%%
%%%
	addpath('./subs');
	NUM_Repeat  = 100;
	sigma       = 0.565861;
	V_reset     = -0.075;
	EndT      	= 100;

	lambda = 1:1:12;

%	myCluster = parcluster('local');
%	myCluster.NumWorkers = 8; 
%	parpool(myCluster)


	dir 	= 'data1';
	mu 		= -6.4;
	% parfor i = 1:numel(lambda)
	for i = 1:numel(lambda)
		SimEach( dir, lambda(i), NUM_Repeat, mu, sigma, V_reset, EndT );
	end


	dir 	= 'data2';
	mu     = -6;
	% parfor i = 1:numel(lambda)
	for i = 1:numel(lambda)
		SimEach( dir, lambda(i), NUM_Repeat, mu, sigma, V_reset, EndT );
	end


	dir 	= 'data3';
	mu     = -5.6;
	% parfor i = 1:numel(lambda)
	for i = 1:numel(lambda)
		SimEach( dir, lambda(i), NUM_Repeat, mu, sigma, V_reset, EndT );
	end
	
%	delete(gcp('nocreate'));
	return;



