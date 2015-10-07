% Boxplot of the results
load('SVMResults');
load('SVMResultsLin');
load('RTResults');
load('neuralResults');
boxplot([RTResults' SVMResultsLin' neuralResults' SVMResults'   ], 'labels', ...
    {'Random Forest' 'SVM linear kernel' 'Neural Networks' 'SVM rbf kernel' });

savegraph(18, 13, 'graphs/boxplotPPDet');
