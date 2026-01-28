c = randn(1, 10)
negative = [];pP
for i=1:10
    if c(1,i) < 0
       negative = [negative c(1,i)];
    end
end
negative