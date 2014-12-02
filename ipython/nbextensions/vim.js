/*
Add this file to $(ipython locate)/nbextensions/vim.js
And load it with:

require(["nbextensions/vim"], function (vim_extension) {
    console.log('vim extension loaded');
    vim_extension.load_extension();
});

*/
define([
    'notebook/js/notebook',
    'notebook/js/keyboardmanager',
    'codemirror/keymap/vim'
], function() {
    var load_extension = function() {
        IPython_vim_patch(IPython);
    };

    return {
        load_extension: load_extension,
    };
});


function IPython_vim_patch(IPython) {
    // only monkey patch on notebook page
    if(!IPython.Cell) {
        return;
    }


    // plug in so :w saves
    CodeMirror.commands.save = function(cm) {
        IPython.notebook.save_notebook();
    }

    // Monkey patch: KeyboardManager.handle_keydown
    // Diff: disable this handler
    IPython.KeyboardManager.prototype.handle_keydown = function(event) {
        var cell = IPython.notebook.get_selected_cell();
        var vim_mode = cell.code_mirror.getOption('keyMap');
        var notebook = IPython.notebook;

        if (cell instanceof IPython.TextCell) {
            // when cell is rendered, we get no key events, so we capture here
            if (cell.rendered && event.type == 'keydown') {
                // switch IPython.notebook to this.notebook if Cells get notebook reference
                ret = IPython.VIM.keyDown(IPython.notebook, event);
                return ret;
            }
        }
        return;
    }

    // the new ipython refactor was screwing up key handling
    IPython.Cell.prototype.handle_codemirror_keyevent = function (editor, event) {
        return false;
    }

    // For VIM, focusing the element makes no sense. We want editor focused
    IPython.Cell.prototype.focus_cell = function () {
        //this.focus_editor();
        return;
    }

    // Monkey patch: KeyboardManager.register_events
    // Diff: disable this handler
    IPython.KeyboardManager.prototype.register_events = function(e) {
        return;
    }
    // Monkey patch insert_cell_below
    // Diff: Select cell after insert
    IPython.Notebook.prototype.insert_cell_below = function(type, index) {
        index = this.index_or_selected(index);
        var cell = this.insert_cell_at_index(type, index + 1);
        this.select(this.find_cell_index(cell));
        return cell;
    };

    // Monkey patch insert_cell_above
    // Diff: Select cell after insert
    IPython.Notebook.prototype.insert_cell_above = function(type, index) {
        index = this.index_or_selected(index);
        var cell = this.insert_cell_at_index(type, index);
        this.select(this.find_cell_index(cell));
        return cell;
    };

    // Monkey patch: execute_cell
    // Diff: don't switch to command mode
    IPython.Notebook.prototype.execute_cell = function() {
        var cell = this.get_selected_cell();
        var cell_index = this.find_cell_index(cell);
        cell.execute();
        this.set_dirty(true);
    };

    IPython.Notebook.prototype.command_mode = function () {
        return;
    }

    IPython.Notebook.prototype.edit_mode = function () {
        return;
    }

    // Focus editor on select
    IPython.CodeCell.prototype.select = function() {
        // assume on new selects that we reset all cells to normal mode
        // we don't have a select that dumps us into insert mode, afaik
        this.notebook.reset_cells();
        var cont = IPython.Cell.prototype.select.apply(this);
        if (cont) {
            this.code_mirror.refresh();
            this.focus_editor();
            this.auto_highlight();
        }
        return cont;
    };

    // Focus editor on select
    IPython.TextCell.prototype.select = function() {
        var cont = IPython.Cell.prototype.select.apply(this);
        if(this.rendered) {
            this.element.focus();
        } else {
            this.code_mirror.refresh();
            this.focus_editor();
        }
        return cont;
    };

    IPython.TextCell.prototype.execute = function () {
        this.render();
        this.command_mode();
    };

    IPython.CodeCell.prototype.handle_keyevent = function(editor, event) {
        var ret = this.handle_codemirror_keyevent(editor, event);
        if (ret) {
            event.codemirrorIgnore = true;
            return ret;
        }
        if (event.type == 'keypress') {
            // switch IPython.notebook to this.notebook if Cells get notebook reference
            ret = IPython.VIM.keyDown(IPython.notebook, event);
            if (ret) {
                event.codemirrorIgnore = true;
                return ret;
            }
        }
        if (event.type == 'keydown') {
            // switch IPython.notebook to this.notebook if Cells get notebook reference
            ret = IPython.VIM.keyDown(IPython.notebook, event);
            if (ret) {
                event.codemirrorIgnore = true;
                return ret;
            }
            return ret;
        }
        return false;
    };

    // Override TextCell keydown
    // Really just here to handle the render/editing of text cells
    // Might need to consider also using codemirror keyevent
    IPython.TextCell.prototype.handle_keyevent = function(editor, event) {
        var ret = this.handle_codemirror_keyevent(editor, event);
        if (ret) {
            return ret;
        }
        if (event.type == 'keydown') {
            ret = IPython.VIM.keyDown(IPython.notebook, event);
            return ret;
        }
        return false;
    }

    // reset all cells to normal vim
    IPython.Notebook.prototype.reset_cells = function () {
        var cells = this.get_cells();
        var arr_length = cells.length;
        for(var i = 0; i < arr_length; i++) {
            var c = cells[i];
            var cm = c.code_mirror;
            var current_mode = cm.getOption('keyMap');
            // cell isn't set to vim. set to vim. should only happen on startup.
            if(current_mode.indexOf('vim') !== 0) {
                cm.setOption('keyMap', 'vim');
                continue;
            }

            // reset cell to normal vim
            if(current_mode == 'vim-insert') {
                CodeMirror.Vim.handleKey(cm, '<Esc>', 'user')
            }
        }
    };


    IPython.Notebook.prototype.setVIMode = function(mode) {
        /*
         * The point of this logic is that only one cell should be in insert
         * mode at any one point. In reality the important function here is reset_cells.
         *
         * TODO: If we click on another cell while in insert, we should have a way to reset cells first
         * and then select.
         */
        selected_cell = this.get_selected_cell()
        cm = null;
        if (selected_cell) {
            cm = selected_cell.code_mirror;
        }

        this.reset_cells();
        if (cm && mode == 'INSERT') {
            CodeMirror.Vim.handleKey(cm, 'i', 'user')
        }
    }

    var NormalMode = {};
    var InsertMode = {};

    var VIM = function() {
    };

    VIM.prototype.keyDown = function(that, event) {
        var cell = that.get_selected_cell();
        var vim_mode = cell.code_mirror.getOption('keyMap');

        ret = false;

        if (vim_mode == 'vim') {
            ret = NormalMode.keyDown(that, event);
        }

        if (vim_mode == 'vim-insert') {
            ret = InsertMode.keyDown(that, event);
        }

        if (ret) {
            event.preventDefault();
            return true;
        }
        return false;
    };

    NormalMode.keyDown = function(that, event) {
        var cell = that.get_selected_cell();
        var cell_type = cell.cell_type;
        var textcell = cell instanceof IPython.TextCell;


        // ` : enable console
        if (event.which === 192) {
            $(IPython.console_book.element).toggle();
            IPython.console_book.focus_selected();
            return true;
        }

        // Meta S: save_notebook
        if ((event.ctrlKey || event.metaKey) && event.keyCode == 83) {
            that.save_notebook();
            event.preventDefault();
            return false;
        }

        // K: up cell
        if (event.which === 75 && (event.shiftKey || event.metaKey)) {
            that.select_prev();
            return true;
        }
        // k: up
        if (event.which === 75 && !event.shiftKey) {
            // textcell. Treat as one line item when not rendered
            if (textcell && cell.rendered) {
                that.select_prev();
                return true;
            }
            var cursor = cell.code_mirror.getCursor();
            if (cursor.line === 0) {
                that.select_prev();
                var new_cell = that.get_selected_cell();
                if (new_cell.code_mirror) { // bottom line, same ch position
                    var last_line = new_cell.code_mirror.lastLine();
                    // NOTE: a current code_mirror bug doesn't respect the new cursor opsition
                    // https://github.com/marijnh/CodeMirror/issues/2289
                    if (new_cell.code_mirror.state.vim) {
                        new_cell.code_mirror.state.vim.lastHPos = cursor.ch;
                    }
                    new_cell.code_mirror.setCursor(last_line, cursor.ch);
                }
                // right now textcell is handled via Document handler prevent the double call
                event.preventDefault();
                event.stopPropagation();
                return true;
            }
        }
        // J: down cell
        if (event.which === 74 && (event.shiftKey || event.metaKey)) {
            that.select_next();
            return true;
        }
        // j: down
        if (event.which === 74 && !event.shiftKey) {
            // textcell. Treat as one line item when not rendered
            if (textcell && cell.rendered) {
                that.select_next();
                return true;
            }
            var cursor = cell.code_mirror.getCursor();
            var ch = cursor.ch;
            if (cursor.line === (cell.code_mirror.lineCount() - 1)) {
                that.select_next();
                var new_cell = that.get_selected_cell();
                if (new_cell.code_mirror) { // bottom line, same ch position
                    // NOTE: a current code_mirror bug doesn't respect the new cursor opsition
                    // https://github.com/marijnh/CodeMirror/issues/2289
                    new_cell.code_mirror.setCursor(0, cursor.ch);
                    if (new_cell.code_mirror.state.vim) {
                        new_cell.code_mirror.state.vim.lastHPos = cursor.ch;
                    }
                }
                // right now textcell is handled via Document handler prevent the double call
                event.preventDefault();
                event.stopPropagation();
                return true;
            };
        }
        // Y: copy cell
        if (event.which === 89 && event.shiftKey) {
            that.copy_cell();
            return true;
        }
        // D: delete cell / cut
        if (event.which === 68 && event.shiftKey) {
            that.cut_cell();
            return true;
        }
        // P: paste cell
        if (event.which === 80 && event.shiftKey) {
            that.paste_cell_below();
            return true;
        }
        // B: open new cell below
        if (event.which === 66 && event.shiftKey) {
            that.insert_cell_below('code');
            that.setVIMode('INSERT');
            return true;
        }
        // shift+O or apple + O: open new cell below
        // I know this is wrong but i hate hitting A
        if (event.which === 79 && (event.metaKey || event.shiftKey)) {
            that.insert_cell_below('code');
            that.setVIMode('INSERT');
            return true;
        }
        // A: open new cell above
        if (event.which === 65 && event.shiftKey) {
            that.insert_cell_above('code');
            that.setVIMode('INSERT');
            return true;
        }
        // control/apple E: execute (apple - E is easier than shift E)
        if ((event.ctrlKey || event.metaKey) && event.keyCode == 69) {
            that.execute_cell();
            return true;
        }
        // E:  execute
        if (event.which === 69 && event.shiftKey) {
            that.execute_cell();
            return true;
        }
        // F: toggle output
        if (event.which === 70 && event.shiftKey) {
            that.toggle_output();
            return true;
        }
        // M: markdown
        if (event.which === 77 && event.shiftKey) {
            that.to_markdown();
            return true;
        }
        // C: codecell
        if (event.which === 77 && event.shiftKey) {
            that.to_code();
            return true;
        }
        // i: insert. only relevant on textcell
        var rendered = cell.rendered;
        if (textcell && rendered && event.which === 73 && !event.shiftKey) {
            cell.unrender();
            cell.focus_editor();
            return true;
        }

        // i: use our internal vimode setter. 
        if ((textcell && !rendered) && event.which === 73 && !event.shiftKey) {
            that.setVIMode('INSERT');
            return true;
        }

        // i: use our internal vimode setter. 
        if (!textcell && event.which === 73 && !event.shiftKey) {
            that.setVIMode('INSERT');
            return true;
        }

        // esc: get out of insert and render textcell
        if (textcell && !rendered && event.which === 27 && !event.shiftKey) {
            //cell.render();
            //return false;
        }
    };

    InsertMode.keyDown = function(that, event) {
        var cell = that.get_selected_cell();
        var cell_type = cell.cell_type;
        var textcell = cell instanceof IPython.TextCell;

        // esc: use our internal vim mode setter
        if (event.which === 27 && !event.shiftKey) {
            that.setVIMode('NORMAL');
            return true;
        }

        // control/apple E: execute (apple - E is easier than shift E)
        if ((event.ctrlKey || event.metaKey) && event.keyCode == 69) {
            that.execute_cell();
            return true;
        }
        if (event.which === 74 && (event.metaKey)) {
            that.select_next();
            return true;
        }
        if (event.which === 75 && (event.metaKey)) {
            that.select_prev();
            return true;
        }
        // Meta S: save_notebook
        if ((event.ctrlKey || event.metaKey) && event.keyCode == 83) {
            that.save_notebook();
            event.preventDefault();
            return false;
        }
    };

    IPython.VIM = new VIM();

    // this takes care of existing cells
    IPython.notebook.setVIMode('NORMAL'); 

    IPython.Cell.options_default.cm_config.keyMap = "vim";
}
