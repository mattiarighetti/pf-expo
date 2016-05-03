ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
} {
    iscritto_id:integer
}
set html ""
set maxrows 50
set sheets 1
set ctr 0
set offset 0
multirow create events description
set lines_to_print 1
while {$lines_to_print} {
    db_foreach query "SELECT e.descrizione AS description FROM pf_expo_eventi e, pf_expo_iscrizioni i WHERE i.evento_id = e.evento_id AND i.iscritto_id = :iscritto_id ORDER BY e.evento_id" {
	if {$ctr >= $maxrows} {
	    break
	}
	multirow append events $description
	incr ctr 2
	incr offset
    }
    if {$ctr < $maxrows} {
	set lines_to_print 0
    }
    if {$sheets > 1} {
	append html "\n<!-- PAGE BREAK -->\n"
    }   
    set ctr 0
    set code [template::adp_compile -file [ah::package_root]/fatturazione/dettfatt-c-stamp.adp]
    append html [template::adp_eval code]
    incr sheets
    multirow  create dettfattc fattura dataemiss clienti tipopag prodotti quantita prezzo 
}
set file_html [open /tmp/dettfatt-c-stamp.html w]
puts $file_html $html
close $file_html
set fontsize 8
with_catch error_msg {
    exec htmldoc --portrait --webpage --header ... --footer ... --quiet --left 1cm --right 1cm --top 0cm --bottom 0cm --fontsize $fontsize -f /tmp/dettfatt-c-stamp.pdf /tmp/dettfatt-c-stamp.html
} {
    # con htmldoc 1.8.23 e' necessaria la with_catch
} 
# send pdf
ns_returnfile 200 application/pdf /tmp/dettfatt-c-stamp.pdf
# drops temporary files
ns_unlink /tmp/dettfatt-c-stamp.pdf
ns_unlink /tmp/dettfatt-c-stamp.html
ad_script_abort