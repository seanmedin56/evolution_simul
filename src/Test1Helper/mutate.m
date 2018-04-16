function distrib = mutate(gene,births)
%MUTATE Summary of this function goes here
%   Detailed explanation goes here
    mutants = random('bino',births,.0005);
    distrib = containers.Map('KeyType','char','ValueType','int32');
    if gene == '1'
        distrib('1') = births - mutants;
        distrib('2') = mutants;
    else
        distrib('2') = births - mutants;
        distrib('1') = mutants;
    end
end

