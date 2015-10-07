%%Generates the average ROC for our three models

load('neuralResultsAll');
load('SVMResultsAll');
load('RTResultsAll');
load('SVMResultsLinAll');

for i = 1:10
   ROCSNN{i} = [tprNN{i} fprNN{i}];   
   ROCSSVM{i} = [tprSVM{i} fprSVM{i}];
   ROCSSVMLin{i} = [tprSVMLin{i} fprSVMLin{i}];
   ROCSRT{i} = [tprRT{i} fprRT{i}];
   
end



%% average ROC
samples = 400;


graphBegX = 0.0001;
graphEndX = 1;


[ tpravgSVM, fprsSVM ] = vertAvgROC( samples , ROCSSVM);
semilogx(fprsSVM,tpravgSVM,'b', 'LineWidth',2); axis([graphBegX graphEndX 0 1]); xlabel('False Positive Rate'); ylabel('True Positive Rate');

hold on;

[ tpravgNN, fprsNN ] = vertAvgROC( samples , ROCSNN);
semilogx(fprsNN,tpravgNN,'r', 'LineWidth',2); axis([graphBegX graphEndX 0 1]); xlabel('False Positive Rate'); ylabel('True Positive Rate');
hold on;


[ tpravgSVMLin, fprsSVMLin ] = vertAvgROC( samples , ROCSSVMLin);
semilogx(fprsSVMLin,tpravgSVMLin,'y', 'LineWidth',2); axis([graphBegX graphEndX 0 1]); xlabel('False Positive Rate'); ylabel('True Positive Rate');


hold on;
[ tpravgRT, fprsRT ] = vertAvgROC( samples , ROCSRT);
semilogx(fprsRT,tpravgRT,'k', 'LineWidth',2); axis([graphBegX graphEndX 0 1]); xlabel('False Positive Rate'); ylabel('True Positive Rate');
hold on;

ind1 =  find(fprsNN>0.0096 & fprsNN<0.012);
pxNN = fprsNN(ind1(1));
pyNN = tpravgNN(ind1(1));

hold on;


ind2 =  find(fprsSVM>0.0096 & fprsSVM<0.012);


pxSVM = fprsSVM(ind2(1));
pySVM = tpravgSVM(ind2(1));

plot([pxSVM],[pySVM], 'ob', 'MarkerSize',8,...
    'MarkerEdgeColor','b',...
    'MarkerFaceColor','b');

text(pxSVM+0.002,pySVM-0.04,' Ideal Threshold', 'FontSize', 15);


hold on;




hold on;
plot([fprsSVM(ind2(1)), fprsSVM(ind2(1))], [0, tpravgSVM(ind2(1))], 'k--');
hold on;
plot([0.0001, fprsSVM(ind2(1))], [tpravgSVM(ind2(1)), tpravgSVM(ind2(1))], 'k--');


averageSVM = mean(SVMResults);
averageNN = mean(neuralResults);
averageRT = mean(RTResults);
averageSVMLin = mean(SVMResultsLin);

legendSVM = sprintf('SVM rbf %0.3f',averageSVM);
legendSVMLin = sprintf('SVM Linear %0.3f',averageSVMLin);
legendNN = sprintf('Neural Network %0.3f',averageNN);
legendRT = sprintf('Random Tree %0.3f',averageRT);

legend(legendSVM, legendNN, legendSVMLin, legendRT, 'Location','southeast');

savegraph(20,16, 'graphs/ROCAveragewithRTandLinSVM');