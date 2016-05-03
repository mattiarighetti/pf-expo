ad_page_contract {  
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Thursday 12 February 2015
} {
    {q ""}
}
set page_title "Registrazione PFEXPO 2015 Roma"
set context ""
set focus "q"
ad_form -name "cerca" \
    -mode edit \
    -form {
	{q:text(text)
	    {label "Ricerca"}
	    {value $q}
	}
    } -on_submit {
	ad_returnredirect "utenti-list?q=$q"
    }
ad_return_template
if {$q ne ""} {
    set table_html "<table class=\"table table-hover\"><tr><th>Nome e cognome</th><th>Email</th><th>Telefono</th><th>&nbsp;</th></tr>"
    db_foreach query "select iscritto_id, initcap(lower(nome)) as nome, initcap(lower(cognome)) as cognome, email, telefono, barcode from expo_iscritti where lower(nome||cognome||email||telefono) like lower('%$q%') and expo_id = 2" {
	append table_html "<tr><td>$nome $cognome</td><td>$email</td><td>$telefono</td><td><center><a class=\"btn btn-success\" href=\"iscrizioni-list?iscritto_id=$iscritto_id\"><span class=\"glyphicon glyphicon-print\"></span></a></td></tr>"
    }
    append table_html "</table>"
} else {
    set table_html ""
}
