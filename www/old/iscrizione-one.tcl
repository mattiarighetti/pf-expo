ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Monday 7 November, 2014
} {
    iscritto_id:integer,optional
}
set page_title "Iscriviti"
set context ""
set logo_url "http://images.professionefinanza.com/pfexpo/logos/"
append logo_url [db_string query "select immagine from expo_edizioni where report is null limit 1"]
set fe_html_menu [pf::fe_html_menu -id 2]
template::head::add_css -href "/expo_style.css" 
if {[ad_get_cookie iscritto_id] ne ""} {
    ad_returnredirect iscrizione-two+
    ad_script_abort
}
#Imposta form per raccolta generalità
ad_form -name iscritto \
    -mode edit \
    -form {
	iscritto_id:key
	{nome:text
	    {label "Nome"}
	    {html {maxlength "100" size "70" style "text-transform:capitalize"}}
	}
	{cognome:text
	    {label "Cognome"}
	    {html {maxlength "100" size "70" style "text-transform:capitalize"}}
	}
	{email:text
	    {label "Email"}
	    {html {maxlength "80" size "70" style "text-transform:lowercase"}}
	}
	{societa:text,optional
	    {label "Societ&agrave;"}
	    {html {maxlength "100" size "70" style "text-transform:capitalize"}}
	}
	{provincia:text
	    {label "Provincia"}
	    {html {maxlength "20" size "70"}}
	}
	{telefono:text,optional
	    {label "Telefono"}
	    {html {maxlength "20" size "70"}}
	}
	{privacy:boolean(radio)
	    {label "Privacy"}
	    {options {{"Accetto" 1}}}
	    {help_text "Effettuando questa scelta ci si dichiara operatori qualificati ai sensi previsti dai regolamenti Consob."}
	    {html {size "1" style "width:50px"}}
	}
    } -on_submit {
	if {[db_0or1row query "SELECT iscritto_id FROM expo_iscritti WHERE email = :email limit 1"]} {
	    ad_set_cookie iscritto_id [db_string query "SELECT iscritto_id FROM expo_iscritti WHERE LOWER(email) = LOWER(:email) order by iscritto_id limit 1"]
	    ad_returnredirect "iscrizione-two"
	    ad_script_abort
	}
    } -after_submit {
	ad_set_cookie iscritto_id $iscritto_id
	ad_returnredirect "iscrizione-two"
	ad_script_abort
    } -validate {
	{nome
	    {[string length $nome] > 2}
	    "Nome troppo corto."
	}
	{cognome
	    {[string length $cognome] >2}
	    "Cognome troppo corto."
	}
	{email
	    {[string match "*@*" $email] == 1}
	    "Indirizzo email non valido."
	}
        {privacy
	    {$privacy == 1}
	    "Bisogna essere operatori qualificati per partecipare all'evento."
        }
    } -select_query {
	"SELECT iscritto_id, nome, cognome, societa, email, provincia, telefono FROM expo_iscritti"
    } -new_data {
	set iscritto_id [db_string query "SELECT COALESCE(MAX(iscritto_id)+(trunc(random()*99+1)),trunc(random()*99+1)) FROM expo_iscritti"]
	db_dml query "INSERT INTO expo_iscritti (iscritto_id, nome, cognome, societa, email, provincia, telefono, data) VALUES (:iscritto_id, INITCAP(LOWER(:nome)), INITCAP(LOWER(:cognome)), INITCAP(:societa), LOWER(:email), INITCAP(LOWER(:provincia)), :telefono, current_date)"
    }
