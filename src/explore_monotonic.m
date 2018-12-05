% this script loops through different variable combinations and plots the
% resulting average metabolic output (for the MonotonicOptimizer)

addpath('MonotonicOptimizerHelper/');

num_kill_genes = 5;
num_met_genes = 20;

kill_mutation_rate = .0001;
met_mutation_rate = .001;

population_start = 10000;

basal_death_rate = .1;

max_birth_rate = 1;
birth_decay = .00005;

toxic_decay = 1;
toxic_prod = 1000;
activator_param = 10000;

met_prod = 100;
met_coops = [1 2 3 4];
met_diss = 1;

num_generations = 72;

avg_outputs = cell(1, length(met_coops));

for i = 1:length(avg_outputs)
    met_coop = met_coops(i);
    
    b = @(gene, t, dist) birth(gene, dist, max_birth_rate, birth_decay);
    d = @(gene, t, dist) death(gene, dist, activator_param, toxic_prod, ...
        met_prod, met_coop, met_diss, basal_death_rate, toxic_decay);
    m = @(gene, births, t) mutate2(gene, met_mutation_rate, num_met_genes, ...
        kill_mutation_rate, num_kill_genes, births);

    start = initialize_pop(population_start, num_kill_genes, num_met_genes);

    org = Organism(m,b,d,start);

    org = evolve(org, num_generations);
    
    history = org.history;
    hist_pop = org.history_pop;
    gene_iter = keys(history);
    total_out = zeros(1, length(hist_pop));
    
    for gene = gene_iter
        genotype = strsplit(gene{1}, ' ');

        total_out = total_out + met_out(gene{1}, met_prod) * ...
            history(gene{1}) ./ hist_pop;
    end
    
    avg_outputs{i} = total_out;
    
end
labels = cell(1, length(avg_outputs));
figure();
for i = 1:length(avg_outputs)
    labels{i} = num2str(met_coops(i));
    plot(0:num_generations, avg_outputs{i});
    hold on
end
legend(labels);
title('Avg Output at Different Metabolic Cooperativities');
xlabel('generation');
ylabel('avg output');
