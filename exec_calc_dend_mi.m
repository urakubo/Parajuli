
%%%
%%%
function exec_calc_dend_mi
%%%
%%%
	addpath('./subs');
	lambda = 1:1:12;
	d    = {'data1', 'data2', 'data3'};

	%%{
	QMEAN_TOT = cell(numel(d), 1);
	QSTD_TOT  = cell(numel(d), 1);
	for i = 1:numel(d);
		QMEAN = [];
		QSTD  = [];
		for j = 1:numel(lambda);
			filename = sprintf('./%s/%g.mat',d{i}, lambda(j));
			load(filename, 'p');
			R = ObtainCC(p);
			R(isnan(R)) = 0;
			QM = mean(R(:,:));
			QS = std(R(:,:));
			QMEAN = [QMEAN; QM];
			QSTD  = [QSTD ; QS];
		end;
		QMEAN_TOT{i} = QMEAN;
		QSTD_TOT{i}  = QSTD;
	end;
	filename = './data/QMEAN_QSTD.mat';
	save(filename, 'QMEAN_TOT', 'QSTD_TOT');
	return;
	%%}


