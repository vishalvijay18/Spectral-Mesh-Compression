%
% This function reads in an SMF file and stores the geometry
% and connectivity information
%
% Input: name (full path) of the smf file as a string
% Output: Point coordinates list X (n x 3) and face list 
% F (f x 3) indexing into the point list.
%
% ----------------------------------------------------------
% Richard Zhang (c) 2016
%
function [F, X] = read_smf(filename)

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

