# 

ad_page_contract {
    
    Form di iscrizione per i visitatori.
    
    @author mattia (mattia.righetti@professionefinanza.com)
    @creation-date 2015-11-27
    @cvs-id $Id$
} {
    
} -properties {
} -validate {
} -errors {
}
set page_title "PFEXPO - Iscriviti"
set session_id [ad_get_cookie session_id]
set expo_id [db_string query "select expo_id from expo_edizioni where attivo is true"]
set event_list_html "<ul class=\"list-group\">"
db_foreach query "select e.denominazione, to_char(e.start_time, 'HH24:MI') as start_time, s.denominazione as sala, case when e.prezzo > 0::money then ', a pagamento' else '' end as pagamento from expo_eventi e, expo_sale s, expo_tmp t where t.evento_id = e.evento_id and t.session_id = :session_id and e.sala_id = s.sala_id order by e.evento_id" {
    append event_list_html "<li>$denominazione <small>(Sala $sala, $start_time$pagamento)</small></li>"
}
append event_list_html "</ul>"
ad_form -name iscritto \
    -mode edit \
    -html "class grid-form" \
    -form {
	iscritto_id:key
	{nome:text
	    {label "Nome"}
	    {html {maxlength "100" size "50" placeholder "Nome" style "text-transform:capitalize"}}
	}
	{cognome:text
	    {label "Cognome"}
	    {html {maxlength "100" size "50" placeholder "Cognome" style "text-transform:capitalize"}}
	}
	{email:text
	    {label "Email"}
	    {html {maxlength "80" size "50" placeholder "Email" style "text-transform:lowercase"}}
	}
	{societa:text,optional
	    {label "Societ&agrave;"}
	    {html {maxlength "100" size "50" placeholder "Societ&agrave;" style "text-transform:capitalize"}}
	}
	{provincia:text
	    {label "Provincia"}
	    {html {maxlength "20" size "50" placeholder "Provincia"}}
	}
	{telefono:text
	    {label "telefono"}
	    {html {maxlength "20" size "50" placeholder "Telefono"}}
	}
	{voucher:text,optional
	    {label "Voucher (Non inserire nulla se non si è ricevuto un voucher)"}
	    {html {maxlenght "15" size "50" placeholder "Codice"}}
	}
	{portafoglio:text,optional
	    {label "Ammontare portafoglio"}
	}
	{clienti:text,optional
	    {label "Numero clienti"}
	}
	{attivita:text,optional
	    {label "Anni di attivita"}
	}
	{intermediario:text,optional
	    {label "Intermediario attuale"}
	}
	{privacy:boolean(checkbox),optional
	    {label "Privacy"}
	    {options {{"Accetto" 1}}}
	    {help_text "Effettuando questa iscrizone ci si dichiara operatori qualificati ai sensi previsti dai regolamenti Consob."}
	    {html {size "1" style "width:50px"}}
	}
    } -after_submit {
	ad_returnredirect [export_vars -base "conferma" {iscritto_id}]
	ad_script_abort
    } -validate {
	{nome
	    {[string length $nome] > 2}
	    "Nome troppo corto."
	}
	{cognome
	    {[string length $cognome] > 2}
	    "Cognome troppo corto."
	}
	{email
	    {[string match "*@*.*" $email] == 1}
	    "Indirizzo email non valido."
	}
        {telefono
	    {[string index $telefono 0] eq "3"}
	    "Il numero non inizia con 3!"
	}

	{voucher
	    {[pf::expo::voucher_check $voucher] == 1 || $voucher eq ""}
	    "Voucher non valido o scaduto."
	}
    } -select_query {
	"SELECT iscritto_id, nome, cognome, societa, email, provincia, telefono FROM expo_iscritti"
    } -new_data {
	#controlla se esiste gia email
	if {[db_0or1row query "SELECT * FROM expo_iscritti WHERE email ilike '%:email%' and expo_id = :expo_id limit 1"]} {
	    set iscritto_id [db_string query "SELECT iscritto_id FROM expo_iscritti WHERE lower(email) like lower('%:email%') and expo_id = :expo_id limit 1"]
	    db_dml query "delete from expo_iscrizioni where iscritto_id = :iscritto_id"
	} else {
	    set iscritto_id [db_string query "SELECT COALESCE(MAX(iscritto_id)+(trunc(random()*99+1)),trunc(random()*99+1)) FROM expo_iscritti"]
	    set barcode [expr (803000000000 + $iscritto_id)]
	    db_dml query "INSERT INTO expo_iscritti (iscritto_id, nome, cognome, societa, email, provincia, telefono, data, expo_id, barcode, portafoglio, clienti, attivita) VALUES (:iscritto_id, INITCAP(LOWER(:nome)), INITCAP(LOWER(:cognome)), INITCAP(:societa), LOWER(:email), INITCAP(LOWER(:provincia)), :telefono, current_date, :expo_id, :barcode, :portafoglio, :clienti, :attivita)"
	}
	#ciclo inserimento eventi
	db_foreach query "select evento_id from expo_tmp where session_id = '[ad_get_cookie session_id]'" {
	    set iscrizione_id [db_string query "select max(iscrizione_id) + trunc(random() *99+1) from expo_iscrizioni"]
	    #controllo voucher
	    if {$voucher ne ""} {
		set voucher_id [db_string query "select voucher_id from expo_voucher where lower(codice) = lower(:voucher)"]
		set voucher_evento_id [db_string query "select evento_id from expo_voucher where voucher_id = :voucher_id"]
		if {$voucher_evento_id == $evento_id || $voucher_evento_id == ""} {
		    db_dml query "insert into expo_iscrizioni (iscrizione_id, iscritto_id, evento_id, data, confermato, voucher_id) values (:iscrizione_id, :iscritto_id, :evento_id, current_date, true, :voucher_id)"
		}
	    } else {
		set soldout [db_string query "select soldout from expo_eventi where evento_id = :evento_id"]
		    db_dml query "insert into expo_iscrizioni (iscrizione_id, iscritto_id, evento_id, data, confermato, soldout) values (:iscrizione_id, :iscritto_id, :evento_id, current_date, true, :soldout)"
	    }
	}
    }
