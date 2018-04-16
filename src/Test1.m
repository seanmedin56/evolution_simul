addpath('test1Helper');

%creates a very basic model organism morbidistat

genes = 2; %representing a single relevant gene with 2 variations

m = @(gene,births,t) mutate(gene,births);

b = @(gene,t,dist) random('bino',dist(gene),.5);

d = @(gene,t,dist) death(gene,t,dist(gene));

start = containers.Map({'1','2'},{[100000],[0]});



test1 = Organism(genes,m,b,d,start);

test1 = evolve(test1,150);
