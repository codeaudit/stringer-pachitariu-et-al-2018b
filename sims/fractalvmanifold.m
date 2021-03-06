% computes eigenvalue spectra of example models
%     wide tuning curves
%     narrow tuning curves
%     sines and cosines with power-law decay (alpha = 1,2,3)
% see mathematical details in supplementary information
function fractalvmanifold(matroot)
%%
clf;
alp = [0 100 2:4];
rng('default')
rng(3)
for k=1:5
    np = 2^12;
    theta = linspace(0,2*pi,np);
    nD = 1000; % number of dimensions
        
    px = zeros(nD,np); 
    if k>2
		% sines and cosines with decay alp(k)
        theta = linspace(0,2*pi,np);
        x = zeros(nD,np);
        nn = zeros(nD,1);
        for n = 1:nD/2
            x((n-1)*2+1,:) = cos(theta*n);
            x((n)*2,:) = sin(theta*n);
            nn((n-1)*2+1) = n;
            nn((n)*2) = n;
        end
        px = x .* nn(:).^(-alp(k)/2);
    elseif k==1
		% wide tuning curves
        for n = 1:nD
            px(n,:) = cos(theta + 2*pi*n/nD);
        end
	else
		% narrow tuning curves
        for n = 1:nD
            px(n,round(n*np/nD)) = 1;
        end
    end
    %%
    [u s v] = svdecon(single(px - mean(px,1)));
    
    s= diag(s.^2);
    
    %% take a random projection
    
    w = randn(3,nD);
    
    wproj = w * px;
    
    %
    subplot(1,5,k),
    plot3(wproj(1,:),wproj(2,:),wproj(3,:)-min(wproj(3,:)),'linewidth',1);
    grid on;
    hold all;
    plot3(wproj(1,:),wproj(2,:),zeros(1,np),'color',.7*[1 1 1],'linewidth',1);
    drawnow;
    
    exresp{k} = px;
    spec{k} = s;
    exproj{k} = wproj;
    
end

%%
save(fullfile(matroot,'scalefree.mat'),'exresp','spec','exproj','alp');













