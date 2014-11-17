function load_vimception() {
    cell = IPython.notebook.insert_cell_at_index('code', 0);
    IPython.notebook.select(0);
    cell.set_text('%load_ext vimception\n%reload_ext vimception\n%vimception');
    if (!IPython.notebook.kernel) {
        $([IPython.events]).on('status_started.Kernel', function() {
            cell.execute();
            IPython.notebook.delete_cell();
        });
    } else { 
        cell.execute();
        IPython.notebook.delete_cell();
    }
}

$([IPython.events]).on('app_initialized.NotebookApp', function(){
    $('#help_menu').prepend([
            '<li id="vimception" title="load up vimception cell">',
            '<a href="#" title="vimception" onClick="load_vimception()">vimception</a></li>',
            ].join("\n"));

// uncomment next line to *always* start in vimception
// $('#vimception a').click();
});
