function [ output_args ] = rmipredict( fea,Y,w,b)
threshold=0.5;

d=size(fea,2);% feature dimension
m=size(fea,1);
preY=zeros(size(Y));
for kk=1:m
    X=full( fea );%NumDim*NumIns(in this bag)
    % calculate the Noisy-OR model
    acc=w'*X'+b;% 1*NumIns
    pk=sigmoid(acc);
end


end

function g = sigmoid(z)

g = 1.0 ./ (1.0 + exp(-z));
end

