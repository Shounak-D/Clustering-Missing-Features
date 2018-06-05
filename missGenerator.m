function [x_miss,miss_mask,prob_miss] = missGenerator(x,frac,choice)
% generating the pattern of missing features as per CHOICE
% frac -> fraction of missingness (0,1)
% choice -> type of missingness: 1: MCAR
%                                2: MAR
%                                3: MNAR-I
%                                4: MNAR-II

missCounter = (size(x,1)*size(x,2))*frac;

switch choice
    case 1
        % generating a random pattern of missing features s.t. features are removed completely at random (MCAR)
        miss_mask = zeros(size(x));
        while (missCounter>0)
            i = randi(size(x,1));
            j = randi(size(x,2));
            if (miss_mask(i,j)~=1)
                miss_mask(i,j) = 1;
                missCounter = missCounter - 1;
            end
        end
        display('Finished generating MCAR masks.');

    case 2
        % generating a random pattern of missing features s.t. features are
        % removed at random, depending upon the observed features (MAR)
        miss_tag = randperm(size(x,2));
        x = [x(:,miss_tag(1:floor(size(x,2)/2))),x(:,miss_tag((floor(size(x,2)/2)+1):end))];
        
        reln_tag = zeros(ceil(size(x,2)/2),floor(size(x,2)/2));
        P = randi(floor(size(x,2)/2),1,ceil(size(x,2)/2));
        for i = 1:size(reln_tag,1)
            reln_tag(i,P(i)) = randi(3);
        end
        reln_tag = [reln_tag, zeros(ceil(size(x,2)/2),ceil(size(x,2)/2))];

        miss_mask = zeros(size(x));
        while (missCounter>0)
            i = randi(size(x,1));
            j = randi(ceil(size(x,2)/2)) + floor(size(x,2)/2);
            if (miss_mask(i,j)~=1)
                tag_locn = find(reln_tag((j - floor(size(x,2)/2)),:)~=0);
                miss_type = reln_tag((j - floor(size(x,2)/2)),tag_locn);
                if (miss_type==1)
                    muMf = 0;
                    sigmaMf = 0.35;
                elseif (miss_type==2)
                    muMf = 1;
                    sigmaMf = 0.35;
                else
                    muMf = 2;
                    sigmaMf = 0.35;
                end
                probMiss = gaussmf(abs(x(i,tag_locn)), [sigmaMf, muMf]);
                probAct = rand(1);
                if (probAct<=probMiss)
                    miss_mask(i,j) = 1;
                    missCounter = missCounter - 1;
                end
            end
        end
        display('Finished generating MAR masks.');

    case 3
        % generating a random pattern of missing features s.t. features are
        % removed based on their values only (MNAR-I)
        miss_type = randi(3,1,size(x,2));
        miss_mask = zeros(size(x));
        while (missCounter>0)
            i = randi(size(x,1));
            j = randi(size(x,2));
            if (miss_mask(i,j)~=1)
                if (miss_type(j)==1)
                    muMf = 0;
                    sigmaMf = 0.35;
                elseif (miss_type(j)==2)
                    muMf = 1;
                    sigmaMf = 0.35;
                else
                    muMf = 2;
                    sigmaMf = 0.35;
                end
                probMiss = gaussmf(abs(x(i,j)), [sigmaMf, muMf]);
                probAct = rand(1);
                if (probAct<=probMiss)
                    miss_mask(i,j) = 1;
                    missCounter = missCounter - 1;
                end
            end
        end
        miss_count = sum(miss_mask,2); miss_count = miss_count';
        clearvars -except x labels K k miss_count miss_mask alpha Loops loop choice alpha
        display('Finished generating MNAR-I masks.');

    case 4
        % generating a random pattern of missing features s.t. features are removed according to MNAR-II
        miss_tag = randperm(size(x,2));
        x = [x(:,miss_tag(1:floor(size(x,2)/2))),x(:,miss_tag((floor(size(x,2)/2)+1):end))];

        reln_tag = zeros(ceil(size(x,2)/2),floor(size(x,2)/2)); %required for MAR missingness
        P = randi(floor(size(x,2)/2),1,ceil(size(x,2)/2));
        for i = 1:size(reln_tag,1)
            reln_tag(i,P(i)) = randi(3);
        end
        reln_tag = [reln_tag, zeros(ceil(size(x,2)/2),ceil(size(x,2)/2))]; %required for MNAR missingness

        miss_type2 = randi(3,1,floor(size(x,2)/2));

        miss_mask = zeros(size(x));
        while (missCounter>0)
            flag = round(rand(1));
            if (flag)
                %dependence on observed features
                i = randi(size(x,1));
                j1 = randi(ceil(size(x,2)/2));
                j = j1 + floor(size(x,2)/2);
                if (miss_mask(i,j)~=1)
                    miss_type1 = reln_tag(j1,P(j1));
                    if (miss_type1==1)
                        muMf = 0;
                        sigmaMf = 0.35;
                    elseif (miss_type1==2)
                        muMf = 1;
                        sigmaMf = 0.35;
                    else
                        muMf = 2;
                        sigmaMf = 0.35;
                    end
                    probMiss = gaussmf(abs(x(i,P(j1))), [sigmaMf, muMf]);
                    probAct = rand(1);
                    if (probAct<=probMiss)
                        miss_mask(i,j) = 1;
                        missCounter = missCounter - 1;
                    end
                end
            else
                %dependence on unobserved features
                i = randi(size(x,1));
                j = randi(floor(size(x,2)/2));
                if (miss_mask(i,j)~=1)
                    if (miss_type2(j)==1)
                        muMf = 0;
                        sigmaMf = 0.35;
                    elseif (miss_type2(j)==2)
                        muMf = 1;
                        sigmaMf = 0.35;
                    else
                        muMf = 2;
                        sigmaMf = 0.35;
                    end
                    probMiss = gaussmf(abs(x(i,j)), [sigmaMf, muMf]);
                    probAct = rand(1);
                    if (probAct<=probMiss)
                        miss_mask(i,j) = 1;
                        missCounter = missCounter - 1;
                    end
                end
            end
        end
        display('Finished generating MNAR-II masks.');

    otherwise
        error('Something is wrong with your choice of missingness!');
end

%% filling the absent values with a value outside the dataset called UPPER
upper = max(max(x)) + 1000;
x_miss = x;
x_miss(miss_mask==1) = upper;

%% finding the frequency of each feature to be used as feature weights
prob_miss = sum(miss_mask,1)/sum(sum(miss_mask));

end

