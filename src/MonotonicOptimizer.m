% This model looks at how an organism will evolve when we apply a selection
% pressure favoring an overexpression of some metabolite. The selection
% pressure is applied via genes the organism has that produce a protein
% that is toxic to the organism when the desired metabolite is not present.
% In this specific case, the toxic genes can mutate to be harmless and the
% metabolic output is proportional to the number of genes relating to the
% metabolic output that have the value '1'

addpath('MonotonicOptimizerHelper/');

num_kill_genes = 5;
num_met_genes = 20;

kill_mutation_rate = .0001;
met_mutation_rate = .0001;

population_start = 10000;

basal_death_rate = .1;

max_birth_rate = 1;
birth_decay = .00005;

toxic_decay = 1;
toxic_prod = 1000;
activator_param = 10000;

met_prod = 100;
met_coop = 2;
met_diss = 1;

num_generations = 72;

b = @(gene, t, dist) birth(gene, dist, max_birth_rate, birth_decay);
d = @(gene, t, dist) death(gene, dist, activator_param, toxic_prod, ...
    met_prod, met_coop, met_diss, basal_death_rate, toxic_decay);
m = @(gene, births, t) mutate2(gene, met_mutation_rate, num_met_genes, ...
    kill_mutation_rate, num_kill_genes, births);

start = initialize_pop(population_start, num_kill_genes, num_met_genes);

mon_opt = Organism(m,b,d,start);

mon_opt = evolve(mon_opt, num_generations);

plot_output(mon_opt, met_prod);
