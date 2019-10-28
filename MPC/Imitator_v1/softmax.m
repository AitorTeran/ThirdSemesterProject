function y = softmax(x)
        den = sum(exp(x));
        y = zeros(length(x),1);
        for i = 1:length(x)
            y(i) = exp(x(i))/den;
        end
end