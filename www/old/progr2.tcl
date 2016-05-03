ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Tuesday 26 May 2015
} {
    {message ""}
    {confirm_sub 0}
}
#Imposta pagina
set page_title "Iscrizioni"
set context [list $page_title]
set fe_html_menu [pf::fe_html_menu -id 2]
set logo_url "http://images.professionefinanza.com/pfexpo/logos/"
append logo_url [db_string query "select immagine from expo_edizioni where report is null limit 1"]
template::head::add_css -href "expo_style.css" 
template::head::add_css -href "timetable.css"
set sessione_id [ad_get_cookie pfexpo_session]
#Imposta messaggio in caso di ritorno da paypal
if {$message == "ok"} {
    set message "<div class=\"alert alert-success\" role=\"alert\"><strong>Pagamento avvenuto con successo.</strong> Ti ricordiamo che grazie a questa iscrizione hai diritto a partecipare a qualsiasi corso a pagamento, registrandoti nella relativa pagina del corso.</div>"
} else {
    set message ""
}
#Se loggato
if {[ad_conn user_id]} {
    set persona_id [db_string query "select persona_id from crm_persone where user_id = [ad_conn user_id]"]
    if {$sessione_id ne ""} {
        db_dml query "update expo_iscrizioni set persona_id where sessione_id = :sessione_id"
    }
    set iscrizione_html "<p class=\"lead\">Hai scelto di partecipare ai seguenti eventi</p><br><div class=\"row\"><ul class=\"list-group\">"
    db_foreach query "select i.iscrizione_id, e.evento_id, e.denominazione, e.sala_id, to_char(e.start_time, 'HH24:MI') as start_time, to_char(e.end_time, 'HH24:MI') as end_time from expo_iscrizioni i, expo_eventi e where e.evento_id = i.evento_id and i.persona_id = :persona_id order by e.start_time" {
	set sala [db_string query "select denominazione from expo_sale where sala_id = :sala_id"]
	append iscrizione_html "<li class=\"list-group-item\">$denominazione - in sala $sala dalle $start_time alle $end_time. <a class=\"btn btn-warning btn-sm pull-right\" href=\"iscrizione?evento_id=$evento_id&return_url=[ns_urlencode http://pfexpo.professionefinanza.com/programma]\" role=\"button\">Cancella</a>"
    }
    append iscrizione_html "</ul></div>"
    #In caso di eventi non confermati
    if {[db_0or1row query "select * from expo_iscrizioni i, expo_eventi e where i.persona_id = :persona_id and i.confermato is null and e.evento_id = i.evento_id limit 1"]} {
	append iscrizione_html "<br></br><div class=\"alert alert-warning\"><strong>Attenzione</strong>: conferma la tua iscrizione agli eventi cliccando quì.<a href=\"http://pfexpo.professionefinanza.com/conferma\" class=\"btn btn-primary pull-right\">Conferma</a></div>"
    } else {
	#In caso di eventi a pagamento imposta avviso e Paypal
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
	ad_return_template
    }    
} else {
    #Controlla cookie, se esiste è utente iscritto non registrato
    if {$sessione_id ne ""} {
	set iscrizione_html "<p class=\"lead\">Hai scelto di partecipare ai seguenti eventi</p><br><div class=\"row\"><ul class=\"list-group\">"
	db_foreach query "select i.iscrizione_id, e.evento_id, e.denominazione, e.sala_id, to_char(e.start_time, 'HH24:MI') as start_time, to_char(e.end_time, 'HH24:MI') as end_time from expo_iscrizioni i, expo_eventi e where e.evento_id = i.evento_id and i.sessione_id = :sessione_id order by e.start_time" { 
	    set sala [db_string query "select denominazione from expo_sale where sala_id = :sala_id"]                                                  
	    append iscrizione_html "<li class=\"list-group-item\">$denominazione - in sala $sala dalle $start_time alle $end_time. <a class=\"btn btn-sm btn-warning pull-right\" href=\"iscrizione?evento_id=$evento_id&return_url=[ns_urlencode http://pfexpo.professionefinanza.com/programma]\" role=\"button\">Cancella</a>"
	}
	#Creo form per iscrizione simultanea
	ad_form -name register \
	    -form {
		{first_names:text
		    {html {placeholder "Nome" class "form-control input-sm col-sm-2"}}
		}
		{last_name:text
		    {html {placeholder "Cognome" class "form-control input-sm col-sm-2"}}
		}
		{email:text
		    {html {placeholder "Email" class "form-control input-sm col-sm-2"}}
		}
		{societa:text
		    {html {placeholder "Societ&agrave;" class "form-control input-sm col-sm-2"}}
		}
		{provincia:text
		    {html {placeholder "Provincia" class "form-control input-sm col-sm-2"}}
		}
		{privacy:boolean(checkbox)
		    {after_html "<a href=\"privacy_policy\" target=\"_blank\">Privacy</a>"}
		}
	    } -new_data {
		set user_id [db_nextval acs_object_id_seq]
		db_transaction {
		    array set creation_info [auth::create_user \
						 -user_id $user_id \
						 -verify_password_confirm \
						 -email $email \
						 -first_names $first_names \
						 -last_name $last_name \
						 -password $password \
						 -password_confirm $password_confirm ]
		    if {![db_0or1row query "select * from crm_contatti where lower(valore) like '%'||lower(:email)||'%' limit 1"]} {
			set persona_id [db_string query "select max(persona_id) + trunc(random() *99 + 1) from crm_persone"]		    
			db_dml query "insert into crm_persone (persona_id, user_id, nome, cognome, societa_man) values (:persona_id, :user_id, :first_names, :last_name, :societa_man)"
			set contatto_id [db_string query "select max(contatto_id) + trunc(random() *99 + 1) from crm_contatti"]
			db_dml query "insert into crm_contatti (contatto_id, tipo_id, persona_id, valore, preferito) values (:contatto_id, 6, :persona_id, :email, true)"
		    } else {
			set persona_id [db_string query "select persona_id from crm_contatti where lower(valore) like '%'||:email||'%' limit 1"]
			db_dml query "update crm_persone set user_id = :user_id where persona_id = :persona_id"
		    }
		    set indirizzo_id [db_string query "select max(indirizzo_id) + trunc(random() *99 + 1) from crm_indirizzi"]
		    db_dml query "insert into crm_indirizzi (indirizzo_id, via, provincia_id, persona_id, tipo_id) values (:indirizzo_id, :indirizzo, :provincia_id, :persona_id, 2)"
	} 
		db_dml query "update expo_iscrizioni set persona_id = :persona_id where sessione_id = :sessione_id"
	    }
	#Bottone conferma
	append iscrizione_html "</ul></div><br></br>"
	set confirm_form "1"
    } else {
	set iscrizione_html ""
    }
}
ad_return_template
