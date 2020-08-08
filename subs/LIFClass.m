%%
%%
classdef LIFClass < handle
%%
    properties
%%
%% Parameters
%%
		V_reset   = -0.080;   % -80mV
		V_e       = -0.075;   % -75mV
		V_th      = -0.040;   % -40mV
		Rm        = 10e6  ;   % membrane resistance
		tau_m     = 0.01  ;   % membrane time constant
		Im        = 0     ;   % 3.6e-9 External current
		dt        = 0.0005;
		ReflactST = 20    ;   % Reflactory period: dt x ReflactST = 10 ms
		StartT    = 0     ;
		EndT      = 50    ;   % 50
		T      ;
		Vm     ;
		W      ;
		SynT   ;
		SpikeT ;

	end % Properties
%%
%%
	methods
%%
		function o = InitSimulationTime(o)
			o.T = o.StartT:o.dt:o.EndT;
		end
%%
		function o = SetGaussWeight(o, NUM, mu,sigma)
			if nargin < 4
    			mu    = 0.01;
    			sigma = 0.003;
			end
    		fprintf('mu = %g, sigma = %g \n',mu,sigma);
			o.W  = normrnd(mu,sigma,[NUM,1]); % x, mean, sd
		end
%%
		function o = SetLogNormWeight(o, NUM, mu,sigma)
			if nargin < 4
    			mu    = 0.01;
    			sigma = 0.003;
			end
    		fprintf('mu = %g, sigma = %g \n',mu,sigma);
			o.W  = lognrnd(mu,sigma,[NUM,1]); % x, mean, sd
		end
%%
		function o = SetLogNormWeight2(o, NUM, mu,sigma, Maxmult)
			if nargin < 4
    			mu    = 0.01;
    			sigma = 0.003;
			end
			rndmax = (o.V_th - o.V_e)/Maxmult;
    		fprintf('mu = %g, sigma = %g, V_e = %g, V_th = %g \n', ...
    				mu,sigma,o.V_e,o.V_th);
    		fprintf('V_th - V_e = %g divided by %g is set to be the max weight: %g \n', ...
    			o.V_th-o.V_e, Maxmult, rndmax);
			o.W  = lognrnd(mu,sigma,[NUM,1]); % x, mean, sd
			for i = 1:numel(o.W)
				if o.W(i) > rndmax
					o.W(i) = o.SubRecLogNormWeight2(mu,sigma,rndmax);
				end
			end
		end
%%
		function val = SubRecLogNormWeight2(o, mu, sigma, rndmax)
			% fprintf('Exception \n');
			val  = lognrnd(mu,sigma,1);
			if val > rndmax
				 val = o.SubRecLogNormWeight2(mu, sigma, rndmax);
			end
		end
%%
		function o = SetPoissonInput(o, lambda)
				NUM = numel(o.W);
				o.SynT = cell(NUM,1);
				for i = 1:NUM
					S = [];
					t = o.StartT - log(rand)/lambda;
					n = 0;
					while t < o.EndT, n = n+1;
						S(n) = t; t = t - log(rand)/lambda;
					end
					o.SynT{i,1} = S;
				end
		end
%%
%%
		function o = RunSimulation(o)
%%
%%
			o.SpikeT   = [];
			Vm         = zeros(size(o.T));
			Vm(1)      = o.V_reset;
			Refractory = 0;

			SynThist = zeros( numel(o.W) , numel(o.T)-1 );
			for i = 1:numel(o.W)
					[n,~] = histcounts( o.SynT{i,1}, o.T );
					SynThist(i,:) = n;
			end
			Icurrent = o.W' * SynThist ;

			for t=1:numel(o.T)-1
				Vm(t) = Vm(t) + Icurrent(:,t) * (Refractory <= 0);
			    Vm(t+1) = Vm(t) + o.dt * ( -(Vm(t) - o.V_e) + o.Im * o.Rm) / o.tau_m;
				if	Refractory > 0
					Refractory = Refractory - 1;
    			elseif Vm(t) > o.V_th
        			Vm(t+1) = o.V_reset;
        			o.SpikeT = [o.SpikeT,o.T(t)];
        			Refractory = o.ReflactST;
    			end
			end
			o.Vm = Vm;
		end
%%
%%
	end % methods
end
%%
%%


