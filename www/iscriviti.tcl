ad_page_contract {  
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date 2015-11-16
    @cvs-id $Id$set oacs:msg
} {
    {expo_id [pf::expo::id]}
    {msg ""}
}
#Basic settings
set logo_url "http://images.professionefinanza.com/pfexpo/logos/"
append logo_url [db_string query "select immagine from expo_edizioni where expo_id = :expo_id"]
ad_form -name "iscriviti" \
    -mode edit \
    -form {
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
	    {label "Cellulare"}
	    {html {maxlength "20" size "50" placeholder "Telefono"}}
	}
	{privacy:boolean(checkbox),optional
	    {label "Privacy"}
	    {options {{"Accetto" 1}}}
	    {help_text "Effettuando questa iscrizone ci si dichiara operatori qualificati ai sensi previsti dai regolamenti Consob."}
	    {html {size "1" style "width:50px"}}
	}
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
    } -on_submit {
	#controlla se esiste gia email
	if {[db_0or1row query "SELECT * FROM expo_iscritti WHERE email ilike '%:email%' and expo_id = :expo_id limit 1"]} {
	    set iscritto_id [db_string query "SELECT iscritto_id FROM expo_iscritti WHERE lower(email) like lower('%:email%') and expo_id = :expo_id limit 1"]
	    #db_dml query "delete from expo_iscrizioni where iscritto_id = :iscritto_id"
	} else {
	    set iscritto_id [db_string query "SELECT COALESCE(MAX(iscritto_id)+(trunc(random()*99+1)),trunc(random()*99+1)) FROM expo_iscritti"]
	    set barcode [expr (803000000000 + $iscritto_id)]
	    db_dml query "INSERT INTO expo_iscritti (iscritto_id, nome, cognome, societa, email, provincia, telefono, data, expo_id, barcode) VALUES (:iscritto_id, INITCAP(LOWER(:nome)), INITCAP(LOWER(:cognome)), INITCAP(:societa), LOWER(:email), INITCAP(LOWER(:provincia)), :telefono, current_date, :expo_id, :barcode)"
	}
    } -after_submit {
	acs_mail_lite::send -send_immediately -to_addr $email -from_addr "no-reply@professionefinanza.com" -reply_to "info@professionefinanza.com" -mime_type "text/plain" -subject "Conferma iscrizione PFEXPO" -body "Gentile Professionista della Finanza,\n\n
ti confermiamo l’avvenuta iscrizione all’edizione del PFEXPO in Tour di Padova 2016.\n
L’evento si svolgerà il 15 novembre presso l’hotel Crowne Plaza di Padova, via Po, 197 dalle ore 9.30 alle ore 18.30. Per ogni chiarimento puoi contattarci al num. 02-39565725.\n\n
Ti aspettiamo al PFEXPO!"
	ad_returnredirect iscriviti?msg=ok
	    ad_script_abort
	}
