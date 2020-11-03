
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


