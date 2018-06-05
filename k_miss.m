function assignNew = k_miss(x_miss,miss_mask,k,assign,alpha,prob_miss)
%kmeans algorithm for Missing features with argumented initial assignment
% x_miss -> dataset, rows correspond to data points
% miss_mask -> a matrix having the same size as x_miss with 1 at the
% locations of missing features, 0 at all other locations
% k -> number of clusters
% assign -> vector of initial cluster assignments
% prob_miss -> probability of a feature being missing

upper = max(max(x_miss));
% upper = 9999;
for iter = 1:500
    centre = upper*ones(k,size(x_miss,2));
    centre_mask = zeros(k,size(x_miss,2));
    for i = 1:k
        centre_mask(i,:) = prod(miss_mask(assign==i,:),1);
        for j = 1:size(x_miss,2)
            if any((miss_mask(:,j)==0)'&(assign==i))
                centre(i,j) = mean(x_miss((miss_mask(:,j)==0)'&(assign==i),j));
            end
        end
    end
    dist = zeros(size(x_miss,1),k);
    pen = zeros(size(x_miss,1),k);
    for i = 1:size(x_miss,1)
        for j = 1:k
            dist(i,j) = sqrt(sum((centre(j,(centre_mask(j,:)==0)&(miss_mask(i,:)==0)) - x_miss(i,(centre_mask(j,:)==0)&(miss_mask(i,:)==0))).^2));
            pen(i,j) = sum(prob_miss((centre_mask(j,:)|miss_mask(i,:))==1))/sum(prob_miss);
        end
    end
    dist = (dist - min(min(dist)))./(max(max(dist)) - min(min(dist)));
    Dist = (1-alpha)*dist + alpha*pen;
    [~,assignNew] = min(Dist,[],2);
    if (all(assignNew==assign'))
        break;
    end
    assign = assignNew';
end



end
