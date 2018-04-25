% This model looks at what happens when an organism has two food sources
% and which food source it eats depends on the genes. There is also another
% mutually constraining resource. At the beginning all the organisms eat
% the same food resource, but that resource dwindles with time causing the
% organisms to start to eat the other food resource.
% The birth rate changes according to the population size and what food 
% each organism eats. 

addpath('TwoVariantsHelper/');

num_genes = 5;

mutation_rate = .001;

population_start = 11500;

death_rate = .05;

birth1 = .5;

birth2 = .5;

reward1 = .25;

reward2 = .25;

food1_start = 18000;

food1_slope = 50;

food2_start = 18000;

food_shared = 5500;

num_generations = 500;

b= @(gene,t,dist) birth_two_var(birth1,birth2,reward1,reward2,food1_start, ...
    food1_slope,food2_start,food_shared,num_genes,gene,dist,t);

d = @(gene,t,dist) random('bino',dist(gene),death_rate);

m = @(gene,births,t) mutate_two_vars(mutation_rate,gene,num_genes,births);

classes = cell(num_genes+1,1);
start_pops = cell(num_genes+1,1);
for i = 1:length(classes)
    classes{i} = int2str(i-1);
    start_pops{i} = 0;
end
start_pops{num_genes + 1} = population_start;

start = containers.Map(classes,start_pops);

two_var = Organism(num_genes,m,b,d,start);

two_var = evolve(two_var,num_generations);

