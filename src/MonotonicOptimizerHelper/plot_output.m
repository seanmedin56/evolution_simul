function plot_output(org, met_prod_rate)
%PLOT_OUTPUT Plots population level and average metabolic output
%   Detailed explanation goes here
    history = org.history;
    hist_pop = org.history_pop;
    gene_iter = keys(history);
    total_out = zeros(1, length(hist_pop));
    avg_kill_genes = 0;
    
    for gene = gene_iter
        genotype = strsplit(gene{1}, ' ');

        total_out = total_out + met_out(gene{1}, met_prod_rate) * ...
            history(gene{1}) ./ hist_pop;
        avg_kill_genes = avg_kill_genes + str2double(genotype{2}) * ...
            history(gene{1}) ./ hist_pop;
    end
    figure();
    yyaxis left
    plot(total_out);
    ylabel('average metabolic output');
    xlabel('time');
    yyaxis right
    plot(hist_pop);
    ylabel('population size');
    
    figure();
    plot(avg_kill_genes);
    xlabel('generation');
    ylabel('num kill genes');
    
end

