ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Monday 7 November, 2014
} {
    iscritto_id:integer,optional
}
set page_title "Iscriviti"
set context ""
set logo_url "http://images.professionefinanza.com/pfexpo/logos/"
append logo_url [db_string query "select immagine from expo_edizioni where attivo is true"]
set fe_html_menu [pf::fe_html_menu -id 2]
template::head::add_css -href "/expo_style.css" 
template::head::add_css -href "timetable.css"
# Imposta form per raccolta generalità
ad_form -name iscritto \
    -mode edit \
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
	{telefono:text,optional
	    {label "Telefono"}
	    {html {maxlength "20" size "50" placeholder "Telefono"}}
	}
	{morning1:integer(select),optional
	    {label "Evento prima mattina"}
	    {options {{"Evento prima mattina"} [db_list_of_lists query "select concat(denominazione, ' - (', case when prezzo > 0::money then 'A pagamento' else 'Gratuito' end, ')'), evento_id from expo_eventi where evento_id between 18 and 20 order by start_time, sala_id"]}}
	    {html {style "width:900px;"}}
	}
	{morning2:integer(select),optional
            {label "Evento seconda mattina"}
            {options {{"Evento seconda mattina" } [db_list_of_lists query "select concat(denominazione, ' - (', case when prezzo > 0::money then 'A pagamento' else 'Gratuito' end, ')'), evento_id from expo_eventi where evento_id = 21 order by start_time, sala_id"]}}
	    {html {style "width:900px;"}}
        }
	{noon:integer(select),optional
            {label "Evento primo pomeriggio"}
            {options {{"Evento primo pomeriggio" } [db_list_of_lists query "select concat(denominazione, ' - (', case when prezzo > 0::money then 'A pagamento' else 'Gratuito' end, ')'), evento_id from expo_eventi where evento_id between 22 and 24  order by start_time, sala_id"]}}
	    {html {style "width:900px;"}} 
        }
	{afternoon:integer(select),optional
            {label "Evento secondo pomeriggio"}
            {options {{"Evento secondo pomeriggio" } [db_list_of_lists query "select concat(denominazione, ' - (', case when prezzo > 0::money then 'A pagamento' else 'Gratuito' end, ')'), evento_id from expo_eventi where evento_id between 25 and 27 order by start_time, sala_id"]}}
	    {html {style "width:900px;"}}
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
	    {[string match "*@*" $email] == 1}
	    "Indirizzo email non valido."
	}
	{privacy
	    {$privacy == 1}
	    "Impostare privacy"
	}
    } -select_query {
	"SELECT iscritto_id, nome, cognome, societa, email, provincia, telefono FROM expo_iscritti"
    } -new_data {
	set expo_id [db_string query "select expo_id from expo_edizioni where attivo is true"]
	if {[db_0or1row query "SELECT iscritto_id FROM expo_iscritti WHERE email ilike '%:email%' and expo_id = :expo_id limit 1"]} {
	    set iscritto_id [db_string query "SELECT iscritto_id FROM expo_iscritti WHERE lower(email) like lower('%:email%') and expo_id = :expo_id limit 1"]
	    ad_set_cookie iscritto_id $iscritto_id
	    db_dml query "delete from expo_iscrizioni where iscritto_id = :iscritto_id"
	} else {
	    set iscritto_id [db_string query "SELECT COALESCE(MAX(iscritto_id)+(trunc(random()*99+1)),trunc(random()*99+1)) FROM expo_iscritti"]
	    set barcode "8030000"
	    if {[string length $iscritto_id] == 4} {
		append barcode 0
	    }
	    append barcode $iscritto_id
	    db_dml query "INSERT INTO expo_iscritti (iscritto_id, nome, cognome, societa, email, provincia, telefono, data, expo_id, barcode) VALUES (:iscritto_id, INITCAP(LOWER(:nome)), INITCAP(LOWER(:cognome)), INITCAP(:societa), LOWER(:email), INITCAP(LOWER(:provincia)), :telefono, current_date, :expo_id, :barcode)"
	}
	foreach {evento_id} [list $morning1 $morning2 $noon $afternoon] {
	    if {$evento_id ne ""} {
		set iscrizione_id [db_string query "select max(iscrizione_id) + trunc(random() *99+1) from expo_iscrizioni"]
		db_dml query "insert into expo_iscrizioni (iscrizione_id, iscritto_id, evento_id, data, confermato) values (:iscrizione_id, :iscritto_id, :evento_id, current_date, true)"
	    }
	}
    }
