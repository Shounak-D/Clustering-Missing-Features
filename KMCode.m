%% Implementation of KMeans-FWPD algorithm

% Required pre-loaded data in the workspace
%-------------------------------------------
% x -> dataset, rows correspond to data points
% labels -> class labels to be used for clustering validity
% choice -> type of missingness: 1: MCAR
%                                2: MAR
%                                3: MNAR-I
%                                4: MNAR-II
% frac -> fraction of missingness

%% generating the pattern of missing features as per CHOICE
[x_miss,miss_mask,prob_miss] = missGenerator(x,frac,choice);

%% Initialization
alpha = min(0.5,frac);

%% KMeans-FWPD
num_clss = length(unique(labels));
assign = randi(num_clss,1,size(x,1)); % create the initial random cluster assignment
assignNew_miss = k_miss(x_miss,miss_mask,num_clss,assign,alpha,prob_miss);
