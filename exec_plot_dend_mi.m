
%%%
%%%
function main180126_Summary
%%%
%%%
	addpath('./subs');
	font_init;

	lambda = 1:1:12;
	d    = {'data1', 'data2', 'data3'};
	sigma         = 0.565861;
	mu     		  = [-6.4, -6, -5.6];

	FigLoc = [	0.12 0.62 0.3 0.3; ...
			0.62 0.62 0.3,0.3; ...
			0.12 0.12 0.3 0.3; ...
			0.62 0.12 0.3,0.3];

	col = [	0,0,0;
			0.3,0.3,0.3;
			0.6,0.6,0.6];

	filename = sprintf('./%s/%g.mat',d{1}, lambda(1));
	load(filename, 'p');
	NUM_Repeat    = numel(p)

	dd = 'data';
	filename = sprintf('./%s/QMEAN_QSTD.mat', dd);
	load(filename, 'QMEAN_TOT', 'QSTD_TOT');

	TARG = 6;
	TITLE = {'I(Dendritic spike;', 'Largest input)'};

	figure;
	axes('Position', FigLoc(1,:));
	nn = 2;
	PlotStat(QMEAN_TOT{nn}, QSTD_TOT{nn}, lambda, TARG, TITLE, NUM_Repeat);
	ylim([-0.001,0.010]);
	xlim([0,10]);

	axes('Position', FigLoc(2,:));
	PlotStat2(QMEAN_TOT, QSTD_TOT, lambda, TARG, TITLE, col, NUM_Repeat );
	ylim([-0.001,0.010]);
	xlim([0,10]);
%%%
%%%
%%%
%%%
function PlotStat2(QMEAN_TOT, QSTD_TOT, lambda, TARG, TITLE, col, NUM_Repeat)

	title(TITLE);
	xlabel('Synaptic input frequency (Hz)');
	ylabel('(bit)');
	box off ;
	ax = gca;
	set(ax, 'TickDir', 'out');
	hold on;
	%%%
	%%%
	for j = 1:numel(QMEAN_TOT)
		plot(lambda, QMEAN_TOT{j}(:,TARG), 'o-','MarkerFaceColor', col(j,:), ...
		'MarkerSize', 3,'Color', col(j,:));
		for i = 1:numel(lambda);
			plot([lambda(i), lambda(i)], ...
				[QMEAN_TOT{j}(i,TARG)-QSTD_TOT{j}(i,TARG)/NUM_Repeat, QMEAN_TOT{j}(i,TARG)+QSTD_TOT{j}(i,TARG)/NUM_Repeat], ...
				'-', 'Color', col(j,:));
		end;
	end;



function PlotStat(QMEAN, QSTD, lambda, TARG, TITLE, NUM_Repeat)

	title(TITLE);
	xlabel('Synaptic input frequency (Hz)');
	ylabel('(bit)');
	box off ;
	ax = gca;
	set(ax, 'TickDir', 'out');
	hold on;
	plot(lambda, QMEAN(:,TARG), 'ko-','MarkerFaceColor','k', 'MarkerSize', 3 );
	for i = 1:numel(lambda);
		plot([lambda(i), lambda(i)], [QMEAN(i,TARG)-QSTD(i,TARG)/NUM_Repeat, QMEAN(i,TARG)+QSTD(i,TARG)/NUM_Repeat], 'k-');
	end;



