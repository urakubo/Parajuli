
%%%
%%%
function main180128_Soma_Plot
%%%
%%%
	addpath('./subs');
	font_init;

	FigLoc = [	0.12 0.62 0.3 0.3; ...
			0.62 0.62 0.3,0.3; ...
			0.12 0.12 0.3 0.3; ...
			0.62 0.12 0.3,0.3];


	lambda        = 1:1:12;
	DirSoma       = {'data2', 'data2_nonuniform'}; 

	NUM_Dendrites = 20; 
	sigma         = 0.565861;
	mu     		  = -6;
	V_reset       = -0.080;
	col = [0,0,0; 1,0,0];
	col = [0,0,0; 0,0,0];
%%%
%%%
%%%
%%%
%%%
%%%
	figure;
	TITLE = {'I(Somatic spikes;', 'Synaptic inputs)'};
	for k = 1:numel(DirSoma);
		QMEAN = [];
		QSTD  = [];
		for j = 1:numel(lambda);
		%%
		%%
			filename = sprintf('./%s/soma_%g.mat', DirSoma{k},lambda(j));
			load(filename, 'lambda', 'pp', 'SynInput', 'DendSpike');
		%%%
		%%% Mutual information
		%%%
			RR = [];
			for i = 1:numel(pp);
				R = ObtainCC2(pp(i),SynInput(i,:));
				% R = ObtainCC3(pp(i),SynInput(i,:));
				R(isnan(R)) = 0;
				RR = [RR;R];
			end;
			% size(RR)
			QM = mean(RR(:,:));
			QS = std(RR(:,:));
			% size(QM)
			QMEAN = [QMEAN; QM];
			QSTD  = [QSTD ; QS];	
		%%
		%%
		end;
		%%
		%%
		TARG = 6;
		axes('Position', FigLoc(k,:));
		PlotStat(QMEAN, QSTD, lambda, TARG, TITLE, NUM_Dendrites, col(k,:));
		xlim([0 10]);
		%%
		%%
	end;
	
%%%
%%%
%%%
%%%


function PlotStat(QMEAN, QSTD, lambda, TARG, TITLE, NUM_Repeat, col)

	title(TITLE);
	xlabel('Synaptic input frequency (Hz)');
	ylabel('(bit)');
	box off ;
	ax = gca;
	set(ax, 'TickDir', 'out');
	hold on;
	plot(lambda, QMEAN(:,TARG), 'o-', 'Color', col,'MarkerFaceColor',col, 'MarkerSize', 3 );
	for i = 1:numel(lambda);
		plot([lambda(i), lambda(i)], [QMEAN(i,TARG)-QSTD(i,TARG)/NUM_Repeat, QMEAN(i,TARG)+QSTD(i,TARG)/NUM_Repeat], '-', 'Color', col);
	end;


function PlotSynInput(p)

%		[B,ID] =  sort(p.W,'descend');
		[B,ID] =  sort(p.W);
		NUM = numel(p.SynT);
		figure;
		axis([p.StartT, p.EndT, 0, NUM+1]);
		xlabel('Time(s)');
		hold on;
		for i = 1:NUM;
			ii = ID(i);
			col  = rand(3,1);
			SynT = p.SynT{ii,1};
			for j = 1:numel(SynT);
				plot([SynT(j), SynT(j)], [ii-1, ii],'-','Color',col);
			end;
		end;
		for i = 1:numel(p.SpikeT);
			tmp = p.SpikeT(i);
			plot([tmp, tmp], [NUM, NUM+1],'r-');
		end;




function PlotStat2(Q_ID, lambda, TARG, TITLE, NUM_Repeat)

	title(TITLE);
	xlabel('Synaptic input frequency (Hz)');
	ylabel('(bit)');
	box off ;
	ax = gca;
	set(ax, 'TickDir', 'out');
	hold on;
	plot(lambda, Q_ID, 'ko-','MarkerFaceColor','k', 'MarkerSize', 3 );



function PlotIOPair(p)

		NUM = numel(p);
		figure;
		axis([p(1).StartT, p(1).EndT, 0, NUM+1]);
		xlabel('Time(s)');
		hold on;
		for i = 1:NUM;
			[M,ID] = max(p(i).W);
			Input  = p(i).SynT{ID,1};
			Output = p(i).SpikeT;
			for j = 1:numel(Input);
				plot([Input(j), Input(j)]  , [i-0.4, i],'-','Color','b');
			end;
			for j = 1:numel(Output);
				plot([Output(j), Output(j)], [i-0.8, i-0.4],'-','Color','r');
			end;
		end;


function PlotMembPot(p, ymin, ymax, yminSp, ymaxSp)
		figure;
		subplot(1,2,1);
		plot(p.T,p.Vm,'b-');
		hold on;
		for i = 1:numel(p.SpikeT);
			tmp = p.SpikeT(i);
			plot([tmp, tmp], [yminSp, ymaxSp],'r-');
		end;
		ylim([ymin, ymax]);
		xlabel('Time(s)');
		ylabel('Membrane potential (V)');

		xmax = 100;
		subplot(1,2,2);
		h = histogram(p.Vm);
		h.Normalization = 'pdf';
		h.Orientation   = 'horizontal';
		h.BinWidth      = (ymax-ymin)/200;
		hold on;
		plot([0,xmax],[1, 1] * p.V_th,'r:');
		plot([0,xmax],[1, 1] * p.V_e,'k--');
		ylim([ymin, ymax]);
		xlim([0, xmax]);

%%%%
%%%%
%%%%

function R = ObtainCC3(p,Input)
		MAXLAG = 100;
		NUM_StrongInput = numel(Input);
		edges0 = p.StartT:p.dt*10:p.EndT;
		R = [];
		%
		for i = 1:NUM_StrongInput-1;
			I1 = Input{i};
			I2 = Input{i+1};
			O  = p.SpikeT;
			[ICount1,edges] = histcounts(I1, edges0);
			[ICount2,edges] = histcounts(I2, edges0);
			ICount          = (ICount1 > 0).* (ICount2 > 0);
			[OCount,edges]  = histcounts(O, edges0);
			OCount          = (OCount > 0);
			%%%
			NUM_edges = numel(edges) - 1;
			P_OandI  = sum(ICount.*OCount) /NUM_edges;
			P_I      = sum(ICount) / NUM_edges;
			P_O      = sum(OCount) / NUM_edges;
			P_OoverI = P_OandI/P_I;
			R_IO     = P_OoverI * sqrt(P_I/P_O);

			P_nI      = 1 - P_I;
			P_nO      = 1 - P_O;
			P_OandnI  = sum((ICount == 0).*OCount) / NUM_edges;
			P_nOandI  = sum(ICount.*(OCount == 0)) / NUM_edges;
			P_nOandnI = sum((ICount == 0).*(OCount == 0)) / NUM_edges;
			
			MI11	= P_OandI   * log(P_OandI / (P_I*P_O) );
			MI00	= P_nOandnI * log( P_nOandnI / (P_nI*P_nO) );
			MI01	= P_nOandI  * log( P_nOandI / (P_I*P_nO) );
			MI10	= P_OandnI  * log( P_OandnI / (P_nI*P_O) );
			
			MI      = MI11 + MI00 + MI01 + MI10;
			
			%fprintf('P_OandI = %1.3f; P_I = %1.3f; P_O = %1.3f; P_OoverI = %1.3f; R_IO = %1.3f; MI = %1.3f \n',...
			% 	P_OandI, P_I, P_O, P_OoverI, R_IO, MI);
			R = [R; P_OandI, P_I, P_O, P_OoverI, R_IO, MI];
			%%%
		end;


%%%%
%%%%
%%%%

function R = ObtainCC2(p,Input)
		MAXLAG = 100;
		NUM_StrongInput = numel(Input);
		edges0 = p.StartT:p.dt*10:p.EndT;
		R = [];
		%
		for i = 1:NUM_StrongInput;
			I  = Input{i};
			O = p.SpikeT;
			[ICount,edges] = histcounts(I, edges0);
			[OCount,edges] = histcounts(O, edges0);
			%%%
			ICount          = (ICount > 0);
			OCount          = (OCount > 0);
			%%%
			NUM_edges = numel(edges) - 1;
			P_OandI  = sum(ICount.*OCount) / NUM_edges;
			P_I      = sum(ICount) / NUM_edges;
			P_O      = sum(OCount) / NUM_edges;
			P_OoverI = P_OandI/P_I;
			R_IO     = P_OoverI * sqrt(P_I/P_O);
			
			%%%
			%%%
			P_nI      = 1 - P_I;
			P_nO      = 1 - P_O;
			P_OandnI  = sum((ICount == 0).*OCount) / NUM_edges;
			P_nOandI  = sum(ICount.*(OCount == 0)) / NUM_edges;
			P_nOandnI = sum((ICount == 0).*(OCount == 0)) / NUM_edges;
			
			MI11	= P_OandI   * log(P_OandI / (P_I*P_O) );
			MI00	= P_nOandnI * log( P_nOandnI / (P_nI*P_nO) );
			MI01	= P_nOandI  * log( P_nOandI / (P_I*P_nO) );
			MI10	= P_OandnI  * log( P_OandnI / (P_nI*P_O) );
			
			MI      = MI11 + MI00 + MI01 + MI10;
			
			%fprintf('P_OandI = %1.3f; P_I = %1.3f; P_O = %1.3f; P_OoverI = %1.3f; R_IO = %1.3f; MI = %1.3f \n',...
			% 	P_OandI, P_I, P_O, P_OoverI, R_IO, MI);
			R = [R; P_OandI, P_I, P_O, P_OoverI, R_IO, MI];
			%%%
		end;
			
		% disp(R);


function SetFontArial
		set(groot,'defaultAxesFontName',    'Arial');
		set(groot,'defaultTextFontName',    'Arial');
		set(groot,'defaultLegendFontName',  'Arial');
		set(groot,'defaultColorbarFontName','Arial');


