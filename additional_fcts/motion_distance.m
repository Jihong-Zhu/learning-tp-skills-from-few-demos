function dist = motion_distance(rr)
    data = rr.Data;
    dist = 0;
    for i = 1 : length(data) - 1
        dist = norm(data(:, i + 1) - data(:, i)) + dist; 
    end
end