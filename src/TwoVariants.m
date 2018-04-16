addpath('TwoVariantsHelper/');

num_genes = 10;

mutation_rate = .001;

population_start = 10000;

death_rate = .07;

birth1 = .5;

birth2 = .5;

reward1 = .25;

reward2 = .25;

food1_start = 18000;

food1_slope = 100;

food2_start = 20000;

food_shared = 5500;

num_generations = 300;

b= @(gene,t,dist) birth_two_var(birth1,birth2,reward1,reward2,food1_start, ...
    food1_slope,food2_start,food_shared,num_genes,gene,dist,t);

d = @(gene,t,dist) random('bino',dist(gene),death_rate);

m = @(gene,births,t) mutate_two_vars(mutation_rate,gene,num_genes,births);

start = containers.Map({int2str(num_genes)},{population_start});

two_var = Organism(num_genes,m,b,d,start);

two_var = evolve(two_var,num_generations);

