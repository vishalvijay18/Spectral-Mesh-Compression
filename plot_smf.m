%
% Plot a mesh specified in an SMF file
%
% -----------------------------------------------------
% Richard Zhang (c) 2016
%
function [F, X] = plot_smf(smf_file, varargin)

[dummy, argc] = size(varargin);

[F, X] = read_smf(smf_file);

%trimesh(F, X(:,1), X(:,2), X(:,3), 'EdgeColor', [0.3 0.3 0.3], 'FaceAlpha', 0.8, 'FaceColor', [0.8 0.8 0.8], 'FaceLighting', 'phong');
trimesh(F, X(:,1), X(:,2), X(:,3), 'EdgeColor', [0.3 0.3 0.3], 'FaceColor', [0.8 0.8 0.8], 'FaceLighting', 'phong');

hold on;

%
% perhaps some vertices need to be highlighted
%
if argc > 0  % vertex list specified
    vl = varargin{1};
    for i=1:length(vl)
        scatter3(X(vl, 1), X(vl, 2), X(vl, 3), 50, ones(length(vl),1)*[0 0 1], 'filled');
    end
end

hold off;
