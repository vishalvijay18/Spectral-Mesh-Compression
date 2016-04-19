function [ adjMat ] = fdes(fileName, rowVectors)
%  Compute  spectral  compressions  of  a  given  (small) 
%  triangle mesh

%reading smf file using read_smf function
[F, X] = readsmf(fileName);
rowVectorSize = length(rowVectors);

%getting size of Face and Vertex matrix
[faceNum, dim] = size(F);
[vertexNum, dim] = size(X);

adjMat = zeros(vertexNum, vertexNum);

%calculating adjacency matrix with -1 if edge present
for i = 1:faceNum
    v1 = F(i,1);
    v2 = F(i,2);
    v3 = F(i,3);
    
    adjMat(v1, v2) = -1;
    adjMat(v2, v1) = -1;
    adjMat(v2, v3) = -1;
    adjMat(v3, v2) = -1;
    adjMat(v3, v1) = -1;
    adjMat(v1, v3) = -1;
    
end

sumOfAdj = sum(adjMat,2);

%updating diagonal elements
for k = 1:vertexNum
    adjMat(k,k) = -sumOfAdj(k);
end

[eigenVectors, diagonalMat] = eig(adjMat);

eigenValues = zeros(vertexNum,2);

%storing eigenvalues
for k = 1:vertexNum
    eigenValues(k,2) = k;
    eigenValues(k,1) = diagonalMat(k,k);
end

fTransform = transpose(eigenVectors) * X;

sortedEigen = sort(eigenValues);

sortedEigenVectors = zeros(vertexNum,vertexNum);

for p = 1:vertexNum
    sortedEigenVectors(:,p) = eigenVectors(:, sortedEigen(p,2));
end

%displaying original mesh
figure();
trimesh(F,  X(:,1), X(:,2), X(:,3), 'EdgeColor', [0.3 0.3 0.3], 'FaceColor', [0.8 0.8 0.8], 'FaceLighting', 'phong');
 
%picking top values and applying the results
for z = 1:rowVectorSize
    figure();
    inverseFT = zeros(vertexNum,3);
    for u = 1:rowVectors(z)
        inverseFT = inverseFT + sortedEigenVectors(:,u)*fTransform(sortedEigen(u,2),:);
    end

    %trimesh(F, X(:,1), X(:,2), X(:,3), 'EdgeColor', [0.3 0.3 0.3], 'FaceAlpha', 0.8, 'FaceColor', [0.8 0.8 0.8], 'FaceLighting', 'phong');
    trimesh(F, inverseFT(:,1), inverseFT(:,2), inverseFT(:,3), 'EdgeColor', [0.3 0.3 0.3], 'FaceColor', [0.8 0.8 0.8], 'FaceLighting', 'phong');
    
    hold on;
end



%Used the provided code in assignment directory
function [F, X] = readsmf(filename)

    fid = fopen(filename, 'r');
    if fid == -1
        disp('ERROR: could not open file');
        F = 0; 
        X = 0;
        return;
    end

    vnum = 1;
    fnum = 1;

    while (feof(fid) ~= 1)
        line = '';
        line = fgetl(fid);

        if length(line) > 0 & line(1) == 'v'
            dummy = sscanf(line, '%c %f %f %f');
            X(vnum, :) = dummy(2:4, :)';
            vnum = vnum + 1;
        elseif length(line) > 0 & (line(1) == 'f' | line(1) == 't')
            dummy = sscanf(line, '%c %f %f %f');
            F(fnum, :) = dummy(2:4, :)';
            fnum = fnum + 1;
        end

        % all other lines are ignored
    end

 fclose(fid);
