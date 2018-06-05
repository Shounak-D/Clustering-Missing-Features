function dist = pdist_obs(x_miss,miss_mask,prob_miss)
%Calculating the pairwise Penalized dissimilarity between points with
%Missing Features

x_d = x_miss;
mask = miss_mask;
dist = [];
pen = [];
for i = 1:size(x_d,1)
    now = x_d(1,:);
    now_mask = mask(1,:);
    x_d(1,:) = [];
    mask(1,:) = [];
    now_mask1 = or(repmat(now_mask,size(mask,1),1),mask);
    now = x_d - repmat(now,size(x_d,1),1);
    dist = [dist; sqrt(sum((now.^2).*~now_mask1,2))];
end

end

