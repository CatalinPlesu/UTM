triplete a1 a2 b1 b2 c1 c2 = [(a,b,c)| a<-[a1..a2],b<-[b1..b2],c<-[c1..c2], a<=b, b<=c]

triunghiuri xs = [(a,b,c)| (a,b,c) <- xs, a+b>c,a+c>b,c+b>a]

trDrept' xs = [(a,b,c) | (a,b,c) <- xs, a^2 + b^2 ==c^2||a^2 + c^2 ==b^2 ||c^2 + b^2 ==a^2]

trPer perimeter xs = [(a,b,c) |(a,b,c)<-xs, a+b+c==perimeter]

result = trPer 24 (trDrept' (triunghiuri (triplete 1 10 1 10 1 10)))
