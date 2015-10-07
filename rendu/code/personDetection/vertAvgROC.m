
function [ fprs, tpravg ] = vertAvgROC( samples, ROCS)
% Vertical averaging of ROC curves
% Inputs:
%   samples,        the number of points the averaged ROC will contain;
%   ROCS{nrocs}     a cell array of ROC curves. each ROC curve is a nx2 matrix
%                   where every row contains a point on the ROC curve
%                   (true-positive-rate, false-positive-rate)                         
%
% Output:
%    fprs           Array of size samples+1 containing locations fpr
%                   where the averages were calculated. Plot on x-axis.
%    tpravg         Array of size samples+1 containing the vertical
%                   averages. Plot on y-axis.

% This script implements the vertical ROC averaging of Tom Fawcett's paper
% "An introduction to ROC analysis" (algorithm 3 in the paper).

% Example with an 2 ROC curves containing 3 points:
% ROC{1} = [0 0; 0.1 0.1; 0.2 0.4; 0.6 0.9; 1 1]
% ROC{2} = [0 0; 0.1 0.2; 0.2 0.5; 0.6 0.9; 1 1]
% [x, y] = vertAvgROC(5, ROC)
% plot(x,y)
% hold on
% plot(ROC{1}(:,1), ROC{1}(:,2))
% plot(ROC{2}(:,1), ROC{2}(:,2))
% In practice, you have much more ROCs and points, i.e. you can set samples much higher and it looks better.

%
    nrocs = size(ROCS,2);
    s = 1;
    fprs = 0:1/samples:1;
    for fpr_sample = fprs
        tprsum = 0;
        for i=1:nrocs
            tprsum = tprsum + tpr_for_fpr(fpr_sample, ROCS{i});
        end

        tpravg(s) = tprsum/nrocs;
        s = s+1;
    end
end

function tpr = tpr_for_fpr(fpr_sample, ROC)
    i = 1;
    while i < size(ROC, 1) && ROC(i+1,1) < fpr_sample
        i = i+1;
    end
    if ROC(i,1) == fpr_sample
        tpr =  ROC(i,2);
    else
        tpr = interpolate(ROC(i,:), ROC(i+1,:), fpr_sample);
    end
end

function tpr = interpolate(ROCP1, ROCP2, X)
    slope = (ROCP2(2) - ROCP1(2))/(ROCP2(1)-ROCP1(1));
    tpr = ROCP1(2)+ slope*(X-ROCP1(1));
end