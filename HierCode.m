%% Implementation of HAC-FWPD algorithm

% Required pre-loaded data in the workspace
%-------------------------------------------
% x -> dataset, rows correspond to data points
% labels -> class labels to be used for clustering validity
% choice -> type of missingness: 1: MCAR
%                                2: MAR
%                                3: MNAR-I
%                                4: MNAR-II
% frac -> fraction of missingness
% linkageType -> type of linkage: 1: Single Linkage
%                                 2: Average Linkage
%                                 3: Complete Linkage

%% generating the pattern of missing features as per CHOICE
[x_miss,miss_mask,prob_miss] = missGenerator(x,frac,choice);

%% Initialization
alpha = min(0.5,frac);

%% HAC-FWPD
Y_miss = pdist_miss(x_miss,miss_mask,alpha,prob_miss)';

switch linkageType
    case 1
        Z_sl = linkage(Y_miss,'single');
        assignNew_miss = cluster(Z_sl,'maxclust',length(unique(labels)));
    case 2
        Z_al = linkage(Y_miss,'average');
        assignNew_miss = cluster(Z_al,'maxclust',length(unique(labels)));
    case 3
        Z_cl = linkage(Y_miss,'complete');
        assignNew_miss = cluster(Z_cl,'maxclust',length(unique(labels)));
    otherwise
        error('Something is wrong with your choice of linkage!');
end
