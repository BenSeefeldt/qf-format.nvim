local Formatter = {}

Formatter.setup = function ()

    local fn = vim.fn

    function _G.qftf(info)
        local items
        local ret = {}
        if info.quickfix == 1 then
            items = fn.getqflist({id = info.id, items = 0}).items
        else
            items = fn.getloclist(info.winid, {id = info.id, items = 0}).items
        end

        local name_max_size = 0
        local item_names = {}
        for i = info.start_idx, info.end_idx do
            local item_name = ''
            local e = items[i]
            if e.valid == 1 then
                if e.bufnr > 0 then
                    item_name = fn.bufname(e.bufnr)
                    if item_name == '' then
                        item_name = '[No Name]'
                    else
                        item_name = item_name:gsub('^' .. vim.env.HOME, '~')
                    end
                end

                if not (e.module == nil or e.module == '') then
                    item_name = e.module
                end
            else
                item_name = e.text
            end
            table.insert(item_names, i, item_name)
            name_max_size = math.max(name_max_size, #item_name)
        end

        name_max_size = math.min(name_max_size, 60) -- 60 is max size of name. 
        local itemFmt1, itemFmt2 = '%-' .. name_max_size .. 's', '…%.' .. (name_max_size - 1) .. 's'
        for i = info.start_idx, info.end_idx do
            local item_name = item_names[i]
            local e = items[i]
            local file_name = fn.bufname(e.bufnr)
            local lnum = e.lnum > 99999 and -1 or e.lnum
            local col = e.col > 999 and -1 or e.col
            local qtype = e.type == '' and '' or ' ' .. e.type:sub(1, 1):upper()
            local str
            if string.find(file_name, "^fugitive:///") then -- Special formatting for fugitive logs
                local validFmt = '%s │ %s │%s %s'
                local sha, path = item_name:match('([%a%d]+):(.+)')
                if #path <= name_max_size then
                    path = itemFmt1:format(path)
                else
                    path = itemFmt2:format(path:sub(1 - name_max_size))
                end
                str = validFmt:format(sha, path, qtype, e.text)
            else
                local validFmt = '%s │%5d:%-3d│%s %s'
                if #item_name <= name_max_size then
                    item_name = itemFmt1:format(item_name)
                else
                    item_name = itemFmt2:format(item_name:sub(1 - name_max_size))
                end
                str = validFmt:format(item_name, lnum, col, qtype, e.text)
            end
            table.insert(ret, str)
        end
        return ret
    end
    vim.o.qftf = '{info -> v:lua._G.qftf(info)}'
end

return Formatter
