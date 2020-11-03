%%
%%
function exec_plot_soma
%%
%%
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


