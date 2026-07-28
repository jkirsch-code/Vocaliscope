function plotspectra(c)

cut_sppres = get(deref(c.model),'cut_sppres');
glottal_flow = get(deref(c.model),'glottal_flow');

if isa(cut_sppres,'signal') && isa(glottal_flow,'signal')
  % window the signals
  cut_sppres_win = win(cut_sppres,'hamming');
  glottal_flow_win = win(glottal_flow,'hamming');
  % compute spectra
  cut_sppres_s = db(half1(fft(cut_sppres_win)));
  glottal_flow_s = db(half1(fft(glottal_flow_win)));
  % compute frequency response of the vocal tract filter
  [h,f] = freqz(1, get(deref(c.model),'hvt'), len(cut_sppres), cut_sppres.fs);
  dbh = db(h);
  % compute frequency response of the glottis filter
  Hg = call('get',c.model,'hg');
  [hg,fg] = freqz(1, Hg, len(cut_sppres), cut_sppres.fs);
  dbhg = db(hg);
  % plot spectra
  labels = {};
  axes(c.hAxes);
  cla;
  hold on;
  % pressure signal 
  checkbox = findobj(c.hObject, 'Tag', 'pressureCheckbox');
  if ~isempty(checkbox) && get(checkbox, 'Value')
    plot(cut_sppres_s, 'Color', [0.466 0.674 0.188]);
    labels{end+1} = 'speech';
    %0.494 0.184 0.556
  end
  % vocal tract filter frequency response
  checkbox = findobj(c.hObject, 'Tag', 'filterCheckbox');
  if ~isempty(checkbox) && get(checkbox, 'Value')
    plot(f, dbh, 'Color',[0.85 0.325 0.098], 'LineWidth', 2);
    labels{end+1} = 'tract filter';
  end
  % formant frequencies
  checkbox = findobj(c.hObject, 'Tag', 'formantsCheckbox');
  if ~isempty(checkbox) && get(checkbox, 'Value')
    plotformants(f, dbh);
    labels{end+1} = 'formants';
  end
  % flow
  checkbox = findobj(c.hObject, 'Tag', 'flowCheckbox');
  if ~isempty(checkbox) && get(checkbox, 'Value')
    plot(glottal_flow_s, 'Color', [0 0.447 0.741]);
    labels{end+1} = 'flow';
    %0.466 0.674 0.188
  end
  % glottal flow filter frequency response
  checkbox = findobj(c.hObject, 'Tag', 'gfilterCheckbox');
  if ~isempty(checkbox) && get(checkbox, 'Value')
    plot(fg, dbhg, 'Color', [0 0.447 0.741], 'LineWidth', 2);
    labels{end+1} = 'glottis filter';
    %0.301 0.745 0.933
  end
  hold off;
  axis tight;
  grid on;
  % logarithmic or linear frequency scale
  hLogRadioButton = findobj(c.hObject, 'Tag', 'logRadioButton');
  if ~isempty(hLogRadioButton) && get(hLogRadioButton, 'Value')
    set(gca, 'XScale', 'log');
    xlimits = xlim;
    xlim([60 xlimits(2)]);
  else
    set(gca, 'XScale', 'linear');
  end  
  xlabel('Hz');
  ylabel('dB');
  %%legend(labels, 1); KIRSCH commented out
  legend(labels);
else
  axes(c.hAxes);
  cla;
end


function plotformants(f, dbh)

dbh1 = [dbh(2:end); Inf];
dbh_1 = [Inf; dbh(1:end-1)];

max_bool = (dbh > dbh1) & (dbh > dbh_1);
max_indices = find(max_bool);
max_values = dbh(max_indices);
max_f = f(max_indices);
plot(max_f, max_values, 'LineStyle', 'none', 'Marker', 'o', 'Color', [0.85 0.325 0.098]);

for k=1:length(max_indices)
  str = sprintf('  %.0f Hz, %.1f dB', max_f(k), max_values(k));
  text(max_f(k), max_values(k), str, ...
       'VerticalAlignment', 'bottom', ...
       'HorizontalAlignment', 'left', ...
       'FontSize',8);
end
