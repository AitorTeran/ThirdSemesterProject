v=[3;2;1;0.8;1.5];
y=zeros(length(v),1);
y=exp(v)/exp(sum(v))
sum(y)

