% this script loops through different variable combinations and plots the
% resulting average metabolic output (for the MonotonicOptimizer)

addpath('MonotonicOptimizerHelper/');

num_kill_genes = 5;
num_met_genes = 21;

kill_mutation_rate = 10^(-6);
met_mutation_rates = [10^(-3), 10^(-4), 10^(-5), 10^(-6), 10^(-7)];

population_start = 10000;

basal_death_rate = .01;

max_birth_rate = 1;
birth_decay = .000005;

toxic_decay = 1;
toxic_prod = 0.5;
activator_param = 50;

met_prod = 5;
met_coop = 2;
met_diss = 1;

num_generations = 72 * 3;

avg_outputs = cell(1, length(met_mutation_rates));
avg_kills = cell(1, length(met_mutation_rates));
pops = cell(1, length(met_mutation_rates));

for i = 1:length(avg_outputs)
    met_mutation_rate = met_mutation_rates(i);
    mut_table = calc_mutate_probs(num_met_genes, num_kill_genes, ...
        met_mutation_rate, kill_mutation_rate);
    b = @(gene, t, dist) birth(gene, dist, max_birth_rate, birth_decay);
    d = @(gene, t, dist) death(gene, dist, activator_param, toxic_prod, ...
        met_prod, met_coop, met_diss, basal_death_rate, toxic_decay);
    m = @(gene, births, t) mutate3(gene, met_mutation_rate, num_met_genes, ...
        kill_mutation_rate, num_kill_genes, births, mut_table);

    start = initialize_pop(population_start, num_kill_genes, num_met_genes);

    org = Organism(m,b,d,start);

    org = evolve(org, num_generations);
    
    history = org.history;
    hist_pop = org.history_pop;
    gene_iter = keys(history);
    total_out = zeros(1, length(hist_pop));
    avg_kill = zeros(1, length(hist_pop));
    
    for gene = gene_iter
        genotype = strsplit(gene{1}, ' ');

        total_out = total_out + met_out(gene{1}, met_prod) * ...
            history(gene{1}) ./ hist_pop;
        avg_kill = avg_kill + str2double(genotype{2}) * history(gene{1}) ./ hist_pop;
    end
    
    avg_outputs{i} = total_out;
    avg_kills{i} = avg_kill;
    pops{i} = hist_pop;
    
end
labels = cell(1, length(avg_outputs));
figure();
for i = 1:length(avg_outputs)
    labels{i} = num2str(met_mutation_rates(i));
    plot(0:num_generations, avg_outputs{i});
    hold on
end
legend(labels);
title('Metabolic Output at Different Mutation Rates');
xlabel('generation');
ylabel('average metabolic output (a.u)');

labels = cell(1, length(avg_kills));
figure();
for i = 1:length(avg_kills)
    labels{i} = num2str(met_mutation_rates(i));
    plot(0:num_generations, avg_kills{i});
    hold on
end
legend(labels);
title('Number of kill genes at Different Mutation Rates');
xlabel('generation');
ylabel('average number of kill genes');

labels = cell(1, length(pops));
figure();
for i = 1:length(avg_kills)
    labels{i} = num2str(met_mutation_rates(i));
    plot(0:num_generations, pops{i});
    hold on
end
legend(labels);
title('Population size at Different Mutation Rates');
xlabel('generation');
ylabel('population size');

