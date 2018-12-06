function start_pop = initialize_pop(pop_size, num_kill, num_met)
%INITIALIZE_POP Initializes genotype distribution
%   Detailed explanation goes here
    classes = cell(num_met + 1, 1);
    start_pops = cell(num_met + 1, 1);
    
    % initialize classes
    for i = 1:length(classes)
        classes{i} = strjoin({num2str(i - 1), num2str(num_kill)}, ' ');
    end
    
    % initializes population
    for i = 1:length(start_pops)
        start_pops{i} = 0;
    end
    start_pops{2} = pop_size;
    start_pop = containers.Map(classes, start_pops);
end

