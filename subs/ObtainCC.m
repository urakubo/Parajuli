%%%%
%%%%
%%%%
function R = ObtainCC(p)
		MAXLAG = 100;
		NUM_Dendrites = numel(p);
		edges0 = p(1).StartT:p(1).dt*10:p(1).EndT;
		R = [];
		%
		for i = 1:NUM_Dendrites;
			[M,ID] = max(p(i).W);
			Input  = p(i).SynT{ID,1};
			Output = p(i).SpikeT;
			[ICount,edges] = histcounts(Input,  edges0);
			[OCount,edges] = histcounts(Output, edges0);
			ICount          = (ICount > 0);
			OCount          = (OCount > 0);
			% [r,lags] = xcorr(ICount,OCount,MAXLAG);
			% subplot(4,3,i)
			% plot(lags,r,'k-');
			%%%
			P_OandI  = sum(ICount.*OCount) / numel(edges);
			P_I      = sum(ICount) / numel(edges);
			P_O      = sum(OCount) / numel(edges);
			P_OoverI = P_OandI/P_I;
			R_IO     = P_OoverI * sqrt(P_I/P_O);
			
			%%%
			%%%
			P_nI      = 1 - P_I;
			P_nO      = 1 - P_O;
			P_OandnI  = sum((ICount == 0).*OCount) / numel(edges);
			P_nOandI  = sum(ICount.*(OCount == 0)) / numel(edges);
			P_nOandnI = sum((ICount == 0).*(OCount == 0)) / numel(edges);
			
			MI11	= P_OandI   * log(P_OandI / (P_I*P_O) );
			MI00	= P_nOandnI * log( P_nOandnI / (P_nI*P_nO) );
			MI01	= P_nOandI  * log( P_nOandI / (P_I*P_nO) );
			MI10	= P_OandnI  * log( P_OandnI / (P_nI*P_O) );
			
			MI      = MI11 + MI00 + MI01 + MI10;
			
			fprintf('P_OandI = %1.3f; P_I = %1.3f; P_O = %1.3f; P_OoverI = %1.3f; R_IO = %1.3f; MI = %1.3f \n',...
			 	P_OandI, P_I, P_O, P_OoverI, R_IO, MI);
			R = [R; P_OandI, P_I, P_O, P_OoverI, R_IO, MI];
			%%%
		end;
