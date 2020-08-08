
%%%
%%%
%%%
function SimEachNonuniform( d, lambda, NUM_Repeat, mu_mean, mu_sigma, sigma, V_reset, EndT )
%%%
%%%
%%%

		Upperbound  = 2;
		NUM_Syn		= 250;

%%
%% Spine number, 1 umあたり 5個。
%% 50 umあたり 250個。
%%

		%%
		%% Computation of each branch
		%%
		
		mmu = [];
		p   = LIFClass.empty([NUM_Repeat, 0]);
		for i = 1:NUM_Repeat;
			p(i)         = LIFClass();
			p(i).EndT    = EndT;
			p(i).V_reset = V_reset;
			p(i).InitSimulationTime;
			mu2 = normrnd(mu_mean, mu_sigma, 1);
			mmu = [mmu, mu2];
			p(i).SetLogNormWeight2(NUM_Syn, mu2, sigma, Upperbound);
			p(i).SetPoissonInput(lambda);
			p(i).RunSimulation;
		end;

		filename = sprintf('./%s/%g.mat', d,lambda);
		save(filename, 'lambda', 'p', 'mu2');


