


printf("Tempo inicial: ")

tinit  = timer();

for i=1:10000

    A=rand(100,100);

end

t = timer() - tinit



printf("Tempo final %f\n", t)
