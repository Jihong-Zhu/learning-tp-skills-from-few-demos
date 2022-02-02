function [velocity, v_norm] = motion_velocity(rr, time_step)
    if nargin < 2
        time_step = 0.01;
    end
    data = rr.Data;
    velocity = zeros(size(data));
    velocity = velocity(:,1:end-1);
    for i = 1 : length(velocity)
        velocity(:, i) = (data(:, i + 1) - data(:, i)) / time_step; 
    end
    v_norm = vecnorm(velocity, 2, 1);
end