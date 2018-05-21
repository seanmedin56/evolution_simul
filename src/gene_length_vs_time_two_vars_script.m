addpath('TwoVariantsHelper/');

% Plots time to reach 'equilibirium' vs number of genes for TwoVariants
% Organism (note: this method is irrelevant to the current version of
% TwoVariants. It was used when the food resource for the dominant organism
% constantly decreased with time.)

%universal variables
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

% to be plotted
range = 3:30;


for i = 13:length(range)
    num_genes = range(i);
    
    b= @(gene,t,dist) birth_two_var(birth1,birth2,reward1,reward2,food1_start, ...
    food1_slope,food2_start,food_shared,num_genes,gene,dist,t);

    d = @(gene,t,dist) random('bino',dist(gene),death_rate);

    m = @(gene,births,t) mutate_two_vars(mutation_rate,gene,num_genes,births);

    classes = cell(num_genes+1,1);
    start_pops = cell(num_genes+1,1);
    for j = 1:length(classes)
        classes{j} = int2str(j-1);
        start_pops{j} = 0;
    end
    start_pops{num_genes + 1} = population_start;

    start = containers.Map(classes,start_pops);

    two_var = Organism(num_genes,m,b,d,start);
    
    while true
        two_var = evolve(two_var,10);
        if two_var.history_pop(end) == 0
            break
        else
            hist = two_var.history('0');
            change_perc = (hist(end) - hist(end-10)) / hist(end-10);
            if change_perc < .001 && hist(end) / two_var.history_pop(end) > .92
                break
            end
        end   
    end
    times(i) = two_var.T;
    disp(times(i));
    
    save('temp_file')
end
