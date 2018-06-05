function pdist = pdist_miss(x_miss,miss_mask,alpha,prob_miss)
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
    now_mask2 = and(repmat(now_mask,size(mask,1),1),mask);
    now = x_d - repmat(now,size(x_d,1),1);
    dist = [dist; sqrt(sum((now.^2).*~now_mask1,2))];
    pen = [pen; sum(now_mask1.*repmat(prob_miss,size(now_mask1,1),1),2)./sum(prob_miss)];
end
dmax = max(max(dist));
dist = dist/dmax;
pdist = (1-alpha)*dist + alpha*pen;

end

