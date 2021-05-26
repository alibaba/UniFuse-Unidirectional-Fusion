function [mat] =  cellstr2mat(cellstr, start, row, column)
    cellsize = size(cellstr);
    
    if row*column + start  > cellsize(1)
        error("mistaked size!")
    end
    
    mat = zeros(row, column);
    
    for i = 1:row
        for j = 1:column
            mat(i, j) = str2num(cellstr{start+(i-1)*column + j});
        end
    end
    
end
