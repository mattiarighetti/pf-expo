ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Tuesday 26 May 2015
} {
    {message ""}
    {confirm_sub 0}
}
set page_title "Iscrizioni"
set context [list $page_title]
set fe_html_menu [pf::fe_html_menu -id 2]
if {$message == "ok"} {
    set message "<div class=\"alert alert-success\" role=\"alert\"><strong>Pagamento avvenuto con successo.</strong> Ti ricordiamo che grazie a questa iscrizione hai diritto a partecipare a qualsiasi corso a pagamento, registrandoti nella relativa pagina del corso.</div>"
} else {
set message ""
}
set logo_url "http://images.professionefinanza.com/pfexpo/logos/"
append logo_url [db_string query "select immagine from expo_edizioni where report is null limit 1"]
template::head::add_css -href "expo_style.css" 
template::head::add_css -href "timetable.css"
if {[ad_conn user_id]} {
    set persona_id [db_string query "select persona_id from crm_persone where user_id = [ad_conn user_id]"]
    set iscrizione_html "<div class=\"row\"><ul class=\"list-group\">"
    db_foreach query "select i.iscrizione_id, e.evento_id, e.denominazione, e.sala_id, to_char(e.start_time, 'HH24:MI') as start_time, to_char(e.end_time, 'HH24:MI') as end_time from expo_iscrizioni i, expo_eventi e where e.evento_id = i.evento_id and i.persona_id = :persona_id order by e.start_time" {
	set sala [db_string query "select denominazione from expo_sale where sala_id = :sala_id"]
	append iscrizione_html "<li class=\"list-group-item\">$denominazione - in sala $sala dalle $start_time alle $end_time. <a class=\"btn btn-warning pull-right\" href=\"iscrizione?evento_id=$evento_id&return_url=[ns_urlencode http://pfexpo.professionefinanza.com/programma]\" role=\"button\">Cancella</a>"
    }
    append iscrizione_html "</ul></div>"
    #Estrae eventi non confermati
    if {[db_0or1row query "select * from expo_iscrizioni i, expo_eventi e where i.persona_id = :persona_id and i.confermato is null and e.evento_id = i.evento_id limit 1"]} {
	append iscrizione_html "<br></br><div class=\"alert alert-warning\"><strong>Attenzione</strong>: conferma la tua iscrizione agli eventi cliccando quì.<a href=\"http://pfexpo.professionefinanza.com/conferma\" class=\"btn btn-primary pull-right\">Conferma</a></div>"
    } else {
	#Estrae eventi confermati a pagamento
	if {[db_0or1row query "select * from expo_iscrizioni i, expo_eventi e where i.persona_id = :persona_id and i.pagato is null and e.evento_id = i.evento_id and e.prezzo > 0::money and e.evento_id = i.evento_id limit 1"]} {
	    append iscrizione_html "<br></br><div class=\"alert alert-info\"><strong>Attenzione</strong>: ti sei iscritto a degli eventi a pagamento. Ti abbiamo inviato una mail con i dati per procedere al bonifico, ma se preferisci puoi pagare con carta cliccando quì. <form action=\"https://www.paypal.com/cgi-bin/webscr\" method=\"post\"><input type=\"hidden\" name=\"cmd\" value=\"_xclick\"><input type=\"hidden\" name=\"item_name\" value=\"Corso PFEXPO Roma 2015\"><input type=\"hidden\" name=\"subtotal\" value=\"99.00\"><input type=\"hidden\" name=\"tax_rate\" value=\"22\"><input type=\"hidden\" name=\"amount\" value=\"99.00\"><input type=\"hidden\" name=\"currency_code\" value=\"EUR\"><input type=\"hidden\" name=\"business\" value=\"fatturazione@professionefinanza.com\"><input type=\"hidden\" name=\"paymentaction\" value=\"sale\"><input type=\"hidden\" name=\"billing_country\" value=\"IT\"><input type=\"hidden\" name=\"notify_url\" value=\"http://pfexpo.professionefinanza.com/paypal_confirm\"><input type=\"hidden\" name=\"custom\" value=\"persona_id,"
	    append iscrizione_html $persona_id
	    append iscrizione_html "\"><input type=\"hidden\" name=\"lc\" value=\"IT\"><input type=\"hidden\" name=\"return\" value=\"http://pfexpo.professionefinanza.com/paypal_confirm?persona_id="
	    append iscrizione_html $persona_id
	    append iscrizione_html "\"><center><button type=\"submit\" class=\"btn btn-success\">Paga con carta</button></center></form></div>"
	} else {
	    if {$confirm_sub} {
	    append iscrizione_html "<br></br><div class=\"alert alert-warning alert-dismissible\" role=\"alert\"><button type=\"button\" class=\"close\" data-dismiss=\"alert\" aria-label=\"Close\"><span aria-hidden=\"true\">&times;</span></button>Iscrizione confermata! In caso di modifica, dovrai riconfermare.</div>"
	    }    
	}
    }    
} else {
    set iscrizione_html ""
}
ad_return_template
