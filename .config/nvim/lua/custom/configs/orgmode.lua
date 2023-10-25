require('orgmode').setup {
    org_agenda_files = { '~/Public/orgmode/agenda/*', '~/Public/orgmode/phone/*',
        -- '~/Public/orgmode/notes/**/*'
    },
    org_default_notes_file = '~/Public/orgmode/agenda/refile.org',
    org_capture_templates = {
        n = {
            description = 'Notes',
            template = '#+TITLE: %?\n#+DATE: %t\n',
            target = '~/Public/orgmode/notes/refile.org'
        }
    },
    org_indent_mode = 'indent', -- indent,noindent
    org_agenda_skip_scheduled_if_done = true,
    org_agenda_skip_deadline_if_done = true,
    -- org_tags_column = 0
    win_split_mode = 'tabnew',
}

