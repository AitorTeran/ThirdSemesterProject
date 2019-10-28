function y = relu(x)
    y = zeros(length(x),1);
    for i = 1:length(x)
        if x(i) > 0 
            y(i) = x(i);
        else
            y(i) = 0;
        end
    end
end