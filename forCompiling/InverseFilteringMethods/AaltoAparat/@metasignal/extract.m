function x = extract(m, segment_type, segment_id)
% function x = extract(m, segment_type, segment_id)

if nargin < 3
    segment_id = '';
end

switch segment_type
    case 'phone',
        if length(segment_id) > 0
            ix = strmatch(segment_id, {m.phone_list.phone}, 'exact');
        else
            ix = 1:length(m.phone_list);
        end
        x = {};
        for k = 1:length(ix)
            x{k} = m.s.s((m.phone_list(ix(k)).start+1):m.phone_list(ix(k)).end);;
        end
    case 'word',
        if length(segment_id) > 0
            ix = strmatch(segment_id, {m.word_list.word}, 'exact');
        else
            ix = 1:length(m.word_list);
        end
        x = {};
        for k = 1:length(ix)
            x{k} = m.s.s((m.word_list(ix(k)).start+1):m.word_list(ix(k)).end);;
        end
    case 'text',
        x = m.s.s(m.text.start+1:m.text.end);
    otherwise,
        error('Unknown segment type');
end
