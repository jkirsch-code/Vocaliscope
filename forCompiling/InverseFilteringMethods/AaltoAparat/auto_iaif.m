%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [g,Hvt2,e_ar,Hg2,options]=auto_iaif(s1,s_options,p_default)

   % if auto-type is not defined, then use default
   if ~isfield(s_options,'autotype')
       s_options.autotype = 'cyclicity';
   end

   % choose type
   if strcmp(s_options.autotype,'cyclicity')
       [g,Hvt2,e_ar,Hg2,options]=auto_iaif_cyclicity(s1,s_options,p_default);
   elseif strcmp(s_options.autotype,'aic')
       [g,Hvt2,e_ar,Hg2,options]=auto_iaif_aic(s1,s_options,p_default);
   else
       error('Unknown type for automatic model order selection.');
   end

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Automatic model order selection by AIC
function [g,Hvt2,e_ar,Hg2,options]=auto_iaif_aic(s1,s_options,p_default)
%    disp('Automatic model order specification in progress.');
    spec_ready = 0;           % specification is not ready yet
    s_options.p = 8;          % initial model order
    s_options.rho = 0.99;     % initial lip radiation
    s_options.f0 = find_f0(s1);
    s_options.flist = find_f(s1,'F0',s_options.f0)';
    
    % step through model orders
    while spec_ready==0
        % calculate iaif model for this model order
        [s_g{s_options.p}, s_a{s_options.p}, s_e(s_options.p), ...
                Hg2{s_options.p}, s_options] = iaif(s1,s_options);
        
        if s_options.p >= 50
            spec_ready = 1;
        end
        
        s_options.p=s_options.p+2;
    end
    ix = find(s_e > 0);
    
    aic(ix) = -2 *log(s_e(ix)) + 2*ix;
    [foo,pix] = min(aic(ix));
    p = ix(pix);
    
    g = s_g{p};
    Hvt2 = s_a{p};
    e_ar = s_e(p);
    Hg2 = Hg2{p}; 
    options = s_options;
    options.p = p;
    return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Automatic model order selection by cyclicity analysis in the phase plane
function [g,Hvt2,e_ar,Hg2,options]=auto_iaif_cyclicity(s1,s_options,p_default)
%    disp('Automatic model order specification in progress.');
    spec_ready = 0;           % specification is not ready yet
    s_options.p = 8;          % initial model order
    s_options.rho = 0.99;     % initial lip radiation
    s_options.f0 = find_f0(s1);
    s_options.flist = find_f(s1,'F0',s_options.f0)';
    
    % step through model orders
    while spec_ready==0
        % calculate iaif model for this model order
%         [s_g{s_options.p}, s_a{s_options.p}, s_e(s_options.p), Hg2, s_options] ...
%             = iaif(s1,s_options);
        [s_g{s_options.p}, s_a{s_options.p}, s_e(s_options.p), Hg2] ...
            = iaif(s1,s_options);
        
        % quality analysis
        [s_cyc(s_options.p), s_kurt(s_options.p), s_mean_circ(s_options.p)] ...
            = iaif_quality(s_g{s_options.p}, s_options.f0);
        
        % check if we have at least 3 good results
        ix = find(s_cyc < 1.3);
        ix = ix(find(s_cyc(ix) ~= 0));
        if (length(ix) >= 3) || (s_options.p >= 50)
            ss_options = s_options;
            % find best model order based on kurtosis
            if length(ix) >= 1
                [foo, k] = min(s_kurt(ix));
                ix = ix(k);
            else % no good inverse filterings found - choose best
                ix = find(s_cyc > 0);
                [foo, k] = min(s_mean_circ(ix));
                ix = ix(k);
            end
            ss_options.p = ix;

            [g,Hvt2,e_ar,Hg2,options,ss_cyc,ss_kurt,ss_mean_circ]=golden_iaif(s1,s_options);
            
            % check if this is still non-cyclic
            if ss_cyc < 1.3
                spec_ready = 1;
            else
                % we have cycles - continue searching
                s_cyc(ix) = ss_cyc;
                s_kurt(ix) = ss_kurt;
                s_mean_circ(ix) = ss_mean_circ;
                
                % but if we have searched all model orders already, then
                % find the one with the least cycles
                if (s_options.p >= 50)
                    % find best non-cyclic
                    ix = find(s_cyc ~= 0);
                    [foo, k] = min(s_mean_circ(ix));
                    s_options.p = ix(k);

                    % determine lip radiation
                    [g,Hvt2,e_ar,Hg2,options,ss_cyc,ss_kurt,ss_mean_circ]=golden_iaif(s1,s_options);
                    
                    % forced exit
                    spec_ready = 1;
                end
            end
        end
        
        s_options.p=s_options.p+2;
    end
    
    return
    
    

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% golden section search of lip radiation function with kurtosis, or,
% alternatively, the mean subcycle circumference
function [g,Hvt2,e_ar,Hg2,options,cyc,kurt,mean_circ]=golden_iaif(s1,s_options)
    % golden-section search for lip-radiation function
    golden_section = 2/(1+sqrt(5));
    sides(4) = 0.999;     % right side starting point
    sides(1) = 0.97;   % left side starting point
    % inside points
    sides(3) = sides(1) + (sides(4)-sides(1))*golden_section;
    sides(2) = sides(4) - (sides(4)-sides(1))*golden_section;
    
    % calculate quality of lip-radiation points
    for k=1:4
        s_options.rho = sides(k);
%         [s_g{k}, s_a{k}, s_e(k), Hg2{k}, s_options] = iaif(s1,s_options);
[s_g{k}, s_a{k}, s_e(k), Hg2{k}] = iaif(s1,s_options);
        [s_cyc(k), s_kurt(k), s_mean_circ(k)] = iaif_quality(s_g{k}, s_options.f0);
    end
    
    % check if kurtosis or mean circumference optimisation 
    if max(s_mean_circ) > 0
        optim_by_kurt = false;
    else
        optim_by_kurt = true;
    end
    
    % iterate N times
    N = 10;
    for k=1:N
        % find out which side is better
        % first check if we are using kurt or mean_circ
        if optim_by_kurt
            [foo, ix] = min(s_kurt);
        else
            [foo, ix] = min(s_mean_circ);
        end
        if ix <= 2
            % step in left side
            s_g{4} = s_g{3}; s_a{4} = s_a{3}; s_e(4) = s_e(3); Hg2{4} = Hg2{3};
            s_g{3} = s_g{2}; s_a{3} = s_a{2}; s_e(3) = s_e(2); Hg2{3} = Hg2{2};
            s_kurt(3:4) = s_kurt(2:3); s_cyc(3:4) = s_cyc(2:3);
            s_mean_circ(3:4) = s_mean_circ(2:3);
            sides(3:4) = sides(2:3);
            
            % new inside left point
            sides(2) = sides(4) - (sides(4)-sides(1))*golden_section;
            
            k = 2;
        else
            % step in right side
            s_g{1} = s_g{2}; s_a{1} = s_a{2}; s_e(1) = s_e(2); Hg2{1} = Hg2{2};
            s_g{2} = s_g{3}; s_a{2} = s_a{3}; s_e(2) = s_e(3); Hg2{2} = Hg2{3};
            s_kurt(1:2) = s_kurt(2:3); s_cyc(1:2) = s_cyc(2:3);
            s_mean_circ(1:2) = s_mean_circ(2:3); 
            sides(1:2) = sides(2:3);
            
            % new inside right point
            sides(3) = sides(1) + (sides(4)-sides(1))*golden_section;

            k = 3;
        end
        % calculate quality of new inside point
        s_options.rho = sides(k);
%         [s_g{k}, s_a{k}, s_e(k), Hg2{k}, s_options] = iaif(s1,s_options);
[s_g{k}, s_a{k}, s_e(k), Hg2{k}] = iaif(s1,s_options);
        [s_cyc(k), s_kurt(k), s_mean_circ(k)] = iaif_quality(s_g{k}, s_options.f0);
    end
    if optim_by_kurt
        [foo, ix] = min(s_kurt);
    else
        [foo, ix] = min(s_mean_circ);
    end
    s_options.rho = sides(ix);

    % return parameters
    g = s_g{ix};
    Hvt2 = s_a{ix};
    e_ar = s_e(ix);
    Hg2 = Hg2{ix};
    options = s_options;
    cyc = s_cyc(ix);
    kurt = s_kurt(ix);
    mean_circ = s_mean_circ(k);
