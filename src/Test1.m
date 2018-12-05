addpath('Test1Helper');

% creates a very basic model organism (see Test1Helper for mutate and death
% functions)

genes = 2; %representing a single relevant gene with 2 variations

m = @(gene,births,t) mutate(gene,births);

b = @(gene,t,dist) random('bino',dist(gene),.5);

d = @(gene,t,dist) death(gene,t,dist(gene));

start = containers.Map({'1','2'},{[100000],[0]});

test1 = Organism(m,b,d,start);

test1 = evolve(test1,150);

display_hist(test1, {['1'], ['2']}, {'Organism A', 'Organism B'}, true,true);
