
%%%
%%%
function exec_sim_soma
%%%
%%%

	addpath('./subs');
	lambda        = 1:1:12;
	d             = {'data2','data2_nonuniform'};
	NUM_Dendrites = 20;
	sigma         = 0.565861;
	mu     		  = -6;
	V_reset       = -0.080;
%%%
%%%
%%%

	for k = 1:numel(d)
		for j = 1:numel(lambda)
		
			filename = sprintf('./%s/%g.mat',d{k}, lambda(j));
			load(filename, 'p');
			NUM_Repeat = numel(p);
			Input  = cell(NUM_Repeat,1);
			Output = cell(NUM_Repeat,1);
			for i = 1:NUM_Repeat;
				[M,ID] = max(p(i).W);
				Input{i}  = p(i).SynT{ID,1};
				Output{i} = p(i).SpikeT;
			end;
		
			NUM_Repeat_Soma_Spike = floor(NUM_Repeat/NUM_Dendrites) * 4 - 4;
			fprintf('Num of Repeat in a branch    : %g \n', NUM_Repeat );
			fprintf('Num of Dend                  : %g \n', NUM_Dendrites );
			fprintf('Num of Repeat for soma spike : %g \n', NUM_Repeat_Soma_Spike );
		
		%%% Simulation of soma

			SynInput   = cell(NUM_Repeat_Soma_Spike,NUM_Dendrites);
			DendSpike  = cell(NUM_Repeat_Soma_Spike,NUM_Dendrites);
			pp = LIFClass.empty([NUM_Repeat_Soma_Spike, 0]);
			for i = 1:NUM_Repeat_Soma_Spike;
				pp(i).V_reset	 = V_reset;
				pp(i).ReflactST = 10     ; % Reflactory period: dt x ReflactST = 5 ms
				pp(i).tau_m     = 0.02   ; % 10e-3;
				pp(i).SetGaussWeight(NUM_Dendrites, 0.02,0);
				% pp(i).SetGaussWeight(NUM_Dendrites, 0.01,0);

				pp(i).InitSimulationTime;
				ST    = (i-1)*(NUM_Dendrites/4);
				Range = [ST+1 : ST + NUM_Dendrites];
				% max(Range)
				SynInput(i,:)   = Input(Range)  ;
				DendSpike(i,:)  = Output(Range) ;
				pp(i).SynT      = Output(Range) ;
				pp(i).RunSimulation;
			end;
		
		%%%

			filename = sprintf('./%s/soma_%g.mat', d{k}, lambda(j));
			save(filename, 'lambda', 'pp', 'SynInput', 'DendSpike');
		%%%
		%%%
		end % j
	end % k
		%%%
		%%%
	
	



