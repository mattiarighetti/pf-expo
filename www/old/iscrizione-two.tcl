ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Tuesday 26 May 2015
} {
    {message ""}
    {confirm_sub 0}
    {pay_alert ""}
}
set page_title "Iscrizioni"
set context [list $page_title]
set fe_html_menu [pf::fe_html_menu -id 2]
if {$message == "ok"} {
    set message "<div class=\"alert alert-success\" role=\"alert\"><strong>Pagamento avvenuto con successo.</strong> Ti ricordiamo che grazie a questa iscrizione hai diritto a partecipare a qualsiasi corso a pagamento, registrandoti nella relativa pagina del corso.</div>"
} 
if {$message == "overlap"} {
    set message "<div class=\"alert alert-danger\" role=\"alert\">Attenzione! Non è possibile procedere all'iscrizione in quanto vi sono eventi a cui sei già iscritto in contemporanea.</div>"
}
set logo_url "http://images.professionefinanza.com/pfexpo/logos/"
append logo_url [db_string query "select immagine from expo_edizioni where report is null limit 1"]
template::head::add_css -href "expo_style.css" 
template::head::add_css -href "timetable.css"
set iscrizione_html ""
set button_confirm ""
set iscritto_id [ad_get_cookie iscritto_id]
db_foreach query "select evento_id, denominazione from expo_eventi order by evento_id asc" {
    if {[db_0or1row query "SELECT * FROM expo_iscrizioni WHERE evento_id = :evento_id AND iscritto_id = :iscritto_id LIMIT 1"]} {
	set button_$evento_id "<a class=\"btn btn-danger btn-sm\" href=\"iscrizione?evento_id=$evento_id\" role=\"button\"><span class=\"glyphicon glyphicon-remove-sign\"> Disiscriviti</span></a>"
    } else {
	set button_$evento_id "<a class=\"btn btn-success btn-sm\" href=\"iscrizione?evento_id=$evento_id\" role=\"button\"><span class=\"glyphicon glyphicon-ok-sign\"> Partecipa</span></a>"
    }
}
set iscrizione_html "<div class=\"row\"><ul class=\"list-group\">"
db_foreach query "select i.iscrizione_id, e.evento_id, e.denominazione, e.sala_id, to_char(e.start_time, 'HH24:MI') as start_time, to_char(e.end_time, 'HH24:MI') as end_time from expo_iscrizioni i, expo_eventi e where e.evento_id = i.evento_id and i.iscritto_id = :iscritto_id order by e.start_time" {
	set sala [db_string query "select denominazione from expo_sale where sala_id = :sala_id"]
	append iscrizione_html "<li class=\"list-group-item\">$denominazione - in sala $sala dalle $start_time alle $end_time. <a class=\"btn btn-warning pull-right\" href=\"iscrizione?evento_id=$evento_id\" role=\"button\">Disiscriviti</a>"
    }
    append iscrizione_html "</ul></div>"
    #Estrae eventi non confermati
    if {[db_0or1row query "select * from expo_iscrizioni i, expo_eventi e where i.iscritto_id = :iscritto_id and i.confermato is null and e.evento_id = i.evento_id limit 1"]} {
	set button_confirm "<center><div class=\"col-md-3\"></div><a href=\"http://pfexpo.professionefinanza.com/iscrizione-three\" class=\"btn btn-lg col-md-6 btn-primary\">Conferma l'iscrizione ai corsi</a></center><br>"
    } else {
	#Estrae eventi confermati a pagamento
	if {[db_0or1row query "select * from expo_iscrizioni i, expo_eventi e where i.iscritto_id = :iscritto_id and i.pagato is null and e.evento_id = i.evento_id and e.prezzo > 0::money and e.evento_id = i.evento_id limit 1"]} {
	    set pay_alert "<div class=\"alert alert-success\">ciao</div>"
	} else {
	    if {$confirm_sub} {
	    append iscrizione_html "<br></br><div class=\"alert alert-warning alert-dismissible\" role=\"alert\"><button type=\"button\" class=\"close\" data-dismiss=\"alert\" aria-label=\"Close\"><span aria-hidden=\"true\">&times;</span></button>Iscrizione confermata! In caso di modifica, dovrai riconfermare.</div>"
	    }    
	}
    }
if {[db_0or1row query "select * from expo_iscrizioni i, expo_eventi e where i.iscritto_id = :iscritto_id and i.pagato is null and i.evento_id = e.evento_id and e.prezzo > 0::money limit 1"]} {
    set pay_alert "<div class=\"alert alert-success\">Ti sei iscritto a un corso a pagamento, potrai procedere in due modi:<br><ul><li>effettuare un bonifico bancario di 120,78 € (99,00 + IVA) intestato a: <strong>PF Holding srl</strong> - IBAN IT17P0103001610000000606927 - SWIFT: PASCITM1MI9 - Causale: corso PFEXPO + cognome partecipante</li><li>pagare con carta di credito <a href=\"https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=2JK7ZACHKUSRE\">cliccando qua</a>.</ul> <br />Per l'emissione della relativa fattura invia una mail con i propri dati fiscali all'indirizzo:<a href=\"mailto:fatturazione@professionefinanza.com\">fatturazione@professionefinanza.com</a></div>"
}
    
ad_return_template

