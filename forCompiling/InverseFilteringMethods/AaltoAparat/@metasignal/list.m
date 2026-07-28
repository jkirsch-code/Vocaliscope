function segment_ids = list(m, segment_type)
% function segment_ids = list(m, segment_type)

switch segment_type
    case 'phone',
        segment_ids = {m.phone_list.phone};
        k=1;
        while k < length(segment_ids)
            ix = strmatch(segment_ids{k}, {segment_ids{k+1:end}},'exact');
            lix = 1:length(segment_ids);
            lix(ix) = [];
            segment_ids = {segment_ids{lix}};
            k=k+1;
        end
    case 'word',
        segment_ids = {m.word_list.word};
        k=1;
        while k < length(segment_ids)
            ix = strmatch(segment_ids{k}, {segment_ids{k+1:end}},'exact');
            lix = 1:length(segment_ids);
            lix(ix) = [];
            segment_ids = {segment_ids{lix}};
            k=k+1;
        end
    case 'text',
        segment_ids = m.text.str;
    otherwise,
        error('Unknown segment type');
end