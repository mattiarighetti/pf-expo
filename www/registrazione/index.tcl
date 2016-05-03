ad_page_contract {  
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Thursday 12 February 2015
} {
    {q ""}
}
pf::user_must_admin
set page_title "Registrazione PFEXPO 2015 Roma"
set context ""
set focus "q"
if {[db_0or1row query "select * from expo_edizioni where attivo is true limit 1"]} {
    set expo_id [db_string query "select expo_id from expo_edizioni where attivo is true"]
} else {
    ad_return_complaint 1 "Non risultano edizioni PFEXPO attive."
}
template::head::add_javascript -src "DYMO.label.framework.js" -charset "UTF-8"
template::head::add_javascript -src "dymo.js" -charset "UTF-8"
ad_form -name "cerca" \
    -mode edit \
    -form {
	{q:text(text)
	    {label "Ricerca"}
	    {value $q}
	}
    } -on_submit {
	ad_returnredirect "?q=$q"
    }
ad_return_template
if {$q ne ""} {
    set table_html "<table class=\"table table-condensed\"><tr><th>Nome e cognome</th><th>Email</th><th>Telefono</th><th>&nbsp;</th><th>&nbsp;</th></tr>"
    db_foreach query "select iscritto_id, initcap(lower(nome)) as nome, initcap(lower(cognome)) as cognome, email, telefono, barcode, case when pagato is true then 1 else 0 end as paid from expo_iscritti where expo_id = :expo_id and (cognome ilike '%$q%' or nome ilike '%$q%' or telefono ilike '%$q%' or email ilike '%$q%' or nome||cognome ilike '%$q%' or cognome||nome ilike '%$q%' or barcode ilike '%$q%')" {
	if {$paid == 1} {
	    set bgcolor "#ff9999"
	} else {
	    set bgcolor ""
	}
	append table_html "<tr bgcolor=\"$bgcolor\"><td>$nome $cognome</td><td>$email</td><td>$telefono</td><td><a href=\"iscrizioni-list?iscritto_id=$iscritto_id\" class=\"btn btn-info btn-sm\"><span class=\"glyphicon glyphicon-th-list\"></span></a></td>"
	#Estrazione corsi da passare a DYMO LABEL
	set courses ""
	db_foreach query "select e.short_title, s.denominazione as sala, to_char(e.start_time, 'HH24:MI') as start_time, i.iscrizione_id, i.soldout from expo_eventi e, expo_iscrizioni i, expo_sale s where e.evento_id = i.evento_id and i.iscritto_id = :iscritto_id and s.sala_id = e.sala_id" {
	    append courses "- " $short_title " (" $sala ", " $start_time ")"
	    if {$paid == 1 || [db_0or1row query "select * from expo_iscrizioni where voucher_id is not null and iscrizione_id = :iscrizione_id limit 1"]} {
		append courses "-(€)"
	    }
	    if {$soldout ne ""} {
		append courses "-(*)"
	    }
	    append courses "<br />"
	}
	#Toglie ultimo br, inutile
	set courses [string trimright $courses "<br />"]
	append table_html "<td><center><button id=\"print\" class=\"btn btn-success btn-sm\" onClick=\"printBadge('$barcode','[string map {' &rsquo;} $nome]','[string map {' &rsquo;} $cognome]', '[string map {' &rsquo;} $courses]')\"><span class=\"glyphicon glyphicon-print\"></span></button></td></tr>"
    }
    append table_html "</table>"
} else {
    set table_html ""
}

