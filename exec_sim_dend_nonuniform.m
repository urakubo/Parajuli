
%%%
%%%
function exec_sim_dend_nonuniform
%%%
%%%

	addpath('./subs');
%	lambda = 0.5:0.5:12;
	NUM_Repeat  = 100;
	V_reset     = -0.075;
	EndT      	= 100;

	lambda = 1:1:12;

%	myCluster = parcluster('local');
%	myCluster.NumWorkers = 8; 
%	parpool(myCluster)

	d    = 'data2_nonuniform';

	sigma      = 0.565861;
	mu_mean    =  -6;
	mu_sigma   = 0.4;
	% parfor i = 1:numel(lambda);
	for i = 1:numel(lambda);
		SimEachNonuniform( d, lambda(i), NUM_Repeat, mu_mean, mu_sigma, sigma, V_reset, EndT );
	end;
	% delete(gcp('nocreate'));
	return;



