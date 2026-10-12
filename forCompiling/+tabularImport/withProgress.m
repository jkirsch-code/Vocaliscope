function varargout = withProgress(fn, parent, title, message)
%WITHPROGRESS  Show an indeterminate progress window while FN runs.
%   WITHPROGRESS(FN) and WITHPROGRESS(FN, PARENT, TITLE, MESSAGE) run FN with
%   a progress window up while it runs, and pass FN's outputs straight back so
%   a caller can keep the assignment it would have written anyway.
%
%   PARENT is the figure the window belongs to, or [] for a window of its own.
%   The standalone form is what is needed before the import dialog exists, for
%   the first analysis of a file, when there is no figure to hang it on yet.
%
%   Indeterminate on purpose. The work being waited for is a single call into
%   READMATRIX, which reports nothing until it is finished, so a determinate
%   bar could only ever sit at zero and then jump. Showing it moving is the
%   honest thing.
%
%   Every part of this is guarded. A progress window is a courtesy, and
%   UIPROGRESSDLG will not appear on a release without a desktop - which is
%   how the test suites run - and that must never be allowed to fail an import
%   that would otherwise have worked.
%
%   The window is closed whatever FN does, including raising, so a failed read
%   cannot leave a modal window over the dialog.
%
%   See also READTABULARFILE, PREVIEWDIALOG.

arguments
    fn (1,1) function_handle
    parent = []
    title (1,1) string = "tabularImport"
    message (1,1) string = ""
end

try
    if isempty(parent)
        dialog = uiprogressdlg('Title', char(title), ...
            'Message', char(message), 'Indeterminate', 'on', ...
            'Cancelable', 'off');
    else
        dialog = uiprogressdlg(parent, 'Title', char(title), ...
            'Message', char(message), 'Indeterminate', 'on', ...
            'Cancelable', 'off');
    end
catch
    % No desktop, or no uiprogressdlg. Carry on without one.
    dialog = [];
end

% Drawn before the work starts, not after, so the user sees a wait rather
% than a flash of nothing. But only when there is something VISIBLE to paint.
%
% DRAWNOW also processes pending callbacks, and a progress window parented to a
% dialog that is still being built is itself invisible - so the draw would
% achieve nothing while handing the event loop a chance to run a timer against a
% half-built window. That is how PREVIEWDIALOG ended up with its own figure
% deleted out from under it: the failure was reported by the Visible SETTER
% reading the getter, which looks nothing like a deleted figure.
paintable = isempty(parent) || ...
    (isgraphics(parent) && isprop(parent, 'Visible') && strcmp(parent.Visible, 'on'));
if ~isempty(dialog) && paintable
    drawnow;
end

try
    if nargout == 0
        fn();
    else
        [varargout{1:nargout}] = fn();
    end
catch ME
    closeWindow(dialog);
    rethrow(ME);
end
closeWindow(dialog);
end


function closeWindow(dialog)
%CLOSEWINDOW  Take the progress window down, if it is up.
    if isempty(dialog) || ~isgraphics(dialog)
        return;
    end
    try
        close(dialog);
    catch
        % Already gone, which is the outcome that was wanted.
    end
end