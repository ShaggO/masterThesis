clc, clear

binType = 'gaussian';
binSigma = 1.3;
left = -pi;
right = pi;
binCount = 12;
binCArgin = {};
period = 1;
options = {'-r300'};

% scale binSigma
binSigma = binSigma .* (right-left) ./ binCount;

switch binType
    case 'box'
        [binF, ~] = ndFilter(binType,binSigma-0.003);
    otherwise
        [binF, ~] = ndFilter(binType,binSigma);
end
binC = createBinCenters(left,right,binCount,binCArgin{:});
wRenorm = renormWeights(binType,binSigma,left,right,period > 0,binC);

x = linspace(left,right,100000)';

fig('unit','inches','width',12,'height',8,'fontsize',8)
box on
hold on
for i = 2
    d = abs(x-binC(i));
    if period
        d = min(d,right-left-d);
    end
    y(:,i) = wRenorm(i)*binF(d);
    plot(x,y(:,i),'b-','linewidth',1)
end
plot(binC(i)*[1 1],[0 max(y(:,i))],'k--')
text(binC(i),0,['f_' num2str(i)],'horizontalalignment','center','verticalalignment','top','fontsize',16)
axis([left right 0 0.6])
xlabel('\Theta');
ylabel('B');

export_fig('../defence/img/binExample.pdf',options{:})