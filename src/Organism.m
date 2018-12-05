classdef Organism
    % Outline of a population of organisms. This class is meant to assist
    % with simulating evolution under changing selection pressure.
    %   Defines a population of organsims with a variety of genotypes.
    %   Organisms have a birth rate, death rate, and mutation rate that
    %   both depends on their genotype, the time, and (in the case of the
    %   death and birth rates) the composition of the population.
    
    properties
        
        %function that takes in a gene and its frequency and returns a
        %distribution of new gemomes
        mutate
        
        %function that takes in a gene, its frequency, and a time and
        %returns number of new organisms produced in the next time
        %step
        birth_rate
        
        %function that takes in a gene, its frequency, and a time and
        %returns a new, reduced frequency of that gene
        death_rate
        
        %maps each gene to the number of organisms having that gene
        G
        
        %the time elapsed
        T = 1
        
        %the history of the populations of each gene
        history = containers.Map('KeyType','char','ValueType','any');
        
        %the history of the entire population
        history_pop
        
    end
    
    methods
        function obj = set.T(obj,T)
            obj.T = T;
        end
        
        function obj = set.history(obj,hist)
            obj.history = hist;
        end
        
        function obj = set.history_pop(obj,hist_pop)
            obj.history_pop = hist_pop;
        end        
        
        function obj = Organism(m,b,d,G_0)
            % Defines the organism
            %   m: function for introducing mutations to the offspring of
            %   organisms(must be a function of the genotype, the number of 
            %   births, and the time)
            %   b: function for the birth rate (function of the genotype,
            %   the time, and the total poulation)
            %   d: functon for the death rate (function of the genotype,
            %   the time, and the total population)
            %   G_0: initial number of organisms with each genotype in the
            %   population
            obj.mutate = m;
            obj.birth_rate = b;
            obj.death_rate = d;
            obj.G = G_0;
            tot = 0;
            keys_iter = keys(G_0);
            obj.history = containers.Map('KeyType','char','ValueType','any');
            for i = 1:length(keys_iter)
                tot = tot + G_0(keys_iter{i});
                obj.history(keys_iter{i}) = G_0(keys_iter{i});
            end
            obj.history_pop = tot;
            obj.T = 1;
            
        end
        
        function obj = evolve(obj,dt)
            %Evolves the organism or dt time steps (where dt is an integer)
            %   Returns a new evolved Organism (note that the original
            %   organism will be only partially modified. The evolved
            %   organism only comes from the obj returned by this function
            for j = 1:dt
                pop = obj.history_pop(obj.T);
                obj.T = obj.T + 1;
                new_distrib = containers.Map('KeyType','char','ValueType','int32');
                gene_iter = keys(obj.G);
                for i = 1:length(gene_iter)
                    gene = gene_iter{i};
                    births = obj.birth_rate(gene,obj.T,obj.G);
                    new_genes = obj.mutate(gene,births,obj.T);
                    deaths = obj.death_rate(gene,obj.T,obj.G);
                    if ~ isKey(new_distrib,gene)
                        new_distrib(gene) = 0;
                    end
                    new_distrib(gene) = new_distrib(gene) - deaths;
                    keys_iter = keys(new_genes);
                    for k = 1:length(keys_iter)
                        key = keys_iter{k};
                        if ~isKey(new_distrib,key)
                            new_distrib(key) = 0;
                        end
                        new_distrib(key) = new_distrib(key) + new_genes(key);
                    end
                end
                key_iter = keys(new_distrib);
                for i = 1:length(key_iter) 
                    key = key_iter{i};
                    if ~isKey(obj.G,key)
                        obj.G(key) = 0;
                        obj.history(key) = zeros(1,obj.T - 1);
                    end
                    pop = pop + new_distrib(key);
                    obj.G(key) = obj.G(key) + new_distrib(key);
                    obj.history(key) = [obj.history(key) obj.G(key)];
                    if length(obj.history(key)) > obj.T
                        stop = true;
                    end
                end
                obj.history_pop(obj.T) = pop;
                if length(obj.history_pop) > obj.T
                    stop = true;
                end
            end
            
        end
        
        function display_hist(obj,gs,labels,show_all,logscale)
            % Displays a plot of population versus time for the specified
            % genes gs
            figure();
            leg = labels;
            
            for i = 1:length(gs)
                gene = gs{i};
                if logscale
                    semilogy(obj.history(gene))
                else
                    plot(obj.history(gene));
                end
                hold on
            end
            if show_all
                if logscale
                    semilogy(obj.history_pop);
                else
                    plot(obj.history_pop);
                end
                leg{length(labels) + 1} = 'total pop';
                hold on
            end
            grid on
            xlabel('time');
            ylabel('population');
            legend(leg);
        end
        
    end
end

