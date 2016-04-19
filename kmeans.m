function [initg, tempMean, clust] = kmeans(x,k,varargin)
% K Means implementation
% takes two input x - the input data, k - number of clusters, and an
% optional array that supplies initial clustering

%handle wrong number of arguments
if (nargin > 3) || (length(varargin) > 1)
    error('Wrong number of arguments.');
end

%reading size
[n, dim] = size(x);

% checking dimension of input data
if (dim ~= 2)
    error('Incorrect dimension of input data. Needs to be 2D.');
end

%if optional array provided, read it. Else assign random initial clustering
if (length(varargin) == 1)
    initg = varargin{1};
else
    initg = randi([1,k],n,1);
end

clust = cell(1,k);
tempMean = cell(1,k);
changes = 1;

% running till it convereges
while changes > 0
    clear clust;
    clear tempMean;
    
    clust = cell(1,k);
    tempMean = cell(1,k);
    
    for entry = 1:n
        clust{initg(entry)} = [clust{initg(entry)}; x(entry, 1) x(entry,2)];
    end
    
    for entry = 1:k
        tempMean{entry} = mean(clust{entry});
    end
    
    %perform new clusters based on nearest centers. Track number of changes
    %during the process
    changes = 0;
    for b = 1:n
        minClust = Inf;
        minDist = Inf;
        for c = 1:k
            if (minDist > norm(tempMean{c} - x(b,:)))
                minDist = norm(tempMean{c} - x(b,:));
                minClust = c;
            end
        end
        if (initg(b) ~= minClust)
            changes = changes + 1;
        end
        initg(b) = minClust;
    end
    
end

%display results
for num = 1:k
        if (size(clust{num}) > 0)
            scatter(clust{num}(:,1), clust{num}(:,2));
            hold on;
        end
end
