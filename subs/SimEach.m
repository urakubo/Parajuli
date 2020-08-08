
%%%
%%%
%%%
function SimEach( d, lambda, NUM_Repeat, mu, sigma, V_reset, EndT )
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
		p = LIFClass.empty([NUM_Repeat, 0]);
		for i = 1:NUM_Repeat
			p(i)         = LIFClass();
			p(i).EndT    = EndT;
			p(i).V_reset = V_reset;
			p(i).InitSimulationTime;
			p(i).SetLogNormWeight2(NUM_Syn, mu,sigma, Upperbound);
			p(i).SetPoissonInput(lambda);
			p(i).RunSimulation;
		end

		filename = sprintf('./%s/%g.mat', d,lambda);
		save(filename, 'lambda', 'p');



