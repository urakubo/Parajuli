%%%
%%%
%%%
function exec_plot_weight()
%%%
%%%
%%%
addpath('./subs');
font_init;

lambda = 1:1:12;
FigLoc = [	0.12 0.62 0.3 0.3; ...
			0.62 0.62 0.3,0.3; ...
			0.12 0.12 0.3 0.3; ...
			0.62 0.12 0.3,0.3];

NUM_Plot	= 6;
ymax 		= 0.014;
d 			= {'data2','data1_nonuniform'};

%%%
%%%

figure;
for k = 1:numel(d);
	filename = sprintf('./%s/%g.mat',d{k},1);
	load(filename, 'p');
	NUM_Repeat = numel(p);
	axes('Position', FigLoc(k,:));
	GraphPlot(p, NUM_Plot);
	ylim([0, ymax]);
end;


function GraphPlot(p, NUM_Plot)
	box off;
	ax = gca;
	set(ax, 'TickDir', 'out');
	xlim([0, NUM_Plot+1]);

	ax.XTick = [1:NUM_Plot];
	ax.YTick = [0:0.004:0.018];

	xlabel('Branch ID');
	ylabel('Synaptic strength (mV)');

	hold on;
	for i = 1:NUM_Plot;
		ww = p(i).W;
		plot(i-0.4+(0.4*rand(size(ww))), ww, 'ko', 'MarkerSize', 0.5, 'MarkerFaceColor', 'k');
		bplot(ww, i+0.3, 'nooutliers', 'linewidth' , 0.5, 'width', 0.3);
	end;


