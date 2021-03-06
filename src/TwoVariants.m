% This model looks at what happens when an organism has two food sources
% and which food source it eats depends on the genes. There is also another
% mutually constraining resource. The food changes dynamically (see contents
% of TwoVariantsHelper for more info). This dynamic food change is accounted 
% for in the birth_two_var method in TwoVariantsHelper).
% The birth rate changes according to the population size and what food 
% each organism eats. 

addpath('TwoVariantsHelper/');

num_genes = 5;

mutation_rate = .001;

population_start = 10000;

death_rate = .07;

birth1 = .5;

birth2 = .5;

reward1 = .25;

reward2 = .25;

food1_start = 18000;

period = 1500;

food2_start = 18000;

food_shared = 5500;

num_generations = 3000;

b= @(gene,t,dist) birth_two_var(birth1,birth2,reward1,reward2,food1_start, ...
    period,food2_start,food_shared,num_genes,gene,dist,t);

d = @(gene,t,dist) random('bino',dist(gene),death_rate);

m = @(gene,births,t) mutate_two_vars(mutation_rate,gene,num_genes,births);

classes = cell(num_genes+1,1);
start_pops = cell(num_genes+1,1);
for i = 1:length(classes)
    classes{i} = int2str(i-1);
    start_pops{i} = population_start / (num_genes + 1);
end

start = containers.Map(classes,start_pops);

two_var = Organism(num_genes,m,b,d,start);

two_var = evolve(two_var,num_generations);

display_hist(two_var,classes,classes,true,false);

