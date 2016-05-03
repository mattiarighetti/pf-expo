ad_page_contract {  
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date 2015-11-16
    @cvs-id $Id$set oacs:msg
} {
    {expo_id "3"}
}
# Se ID Expo vuoto, prende quello attivo
if {$expo_id eq ""} {
    set expo_id [db_string query "select expo_id from expo_edizioni where attivo is true"]
}

#Basic settings
set page_title [db_string query "select 'PFEXPO - '||c.denominazione||' '||to_char(e.data, 'YYYY') from expo_edizioni e, expo_luoghi l, comuni c where c.comune_id = l.comune_id and e.luogo_id = l.luogo_id and expo_id = :expo_id"]
ns_log notice pippo $page_title
set logo_url "http://images.professionefinanza.com/pfexpo/logos/"
append logo_url [db_string query "select immagine from expo_edizioni where expo_id = :expo_id"]
template::add_footer -html "<script src=\"https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js\"></script>"
#template::head::add_css -href "expo_style.css" 
template::add_body_handler -event "data-spy" -script "scroll"
template::head::add_css -href "../timetable.css"
template::add_body_handler -event "data-target" -script "#barra"
template::add_body_handler -event "style" -script "position:relative;"
#template::add_body_handler -event "data-offset" -script "50"
#template::head::add_javascript -src "pfexpo.js"
template::head::add_css -href "../expo_style.css" 

#DIVIDER: #HOME
set pfexpo_data [db_string query "select to_char(e.data, 'dd/mm/yyyy')||' - '||c.denominazione from expo_edizioni e, expo_luoghi l, comuni c where c.comune_id = l.comune_id and l.luogo_id = e.luogo_id and e.expo_id = :expo_id"]
set pfexpo_luogo [db_string query "select l.denominazione from expo_luoghi l, expo_edizioni e where e.expo_id = :expo_id and l.luogo_id = e.luogo_id"]
#set marquee "<div style=\"display:inline-block\">"
#db_foreach query "select citazione, relatore_id from expo_relatori where citazione is not null order by random()" {
#    append marquee "<div class=\"row\"><div class=\"col-md-6\"><h1>&ldquo;</h1><p>$citazione</p><h1>&rdquo;</h1></div>"
#    set nominativo [db_string query "select nome||' '||cognome from expo_relatori where relatore_id = :relatore_id"]
#    set posizione [db_string query "select posizione from expo_relatori where relatore_id = :relatore_id"]
#    append marquee "<div class=\"col-md-6\"><h4>$nominativo</h4><br><p>$posizione</p></div></div>"
#}
#append marquee "</div>"
set carousel_url "#iscriviti"

#DIVIDER: #ISCRIVITI
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
    }
set event_list {}
set counter 1
db_foreach query "select distinct(start_time) as inizio, to_char(start_time, 'HH24') as ore from expo_eventi where expo_id = :expo_id order by start_time" {
    lappend $event_list $counter
    ad_form -extend \
	-name iscritto \
	-form {
	    {$counter:integer(select),optional
		{label "Eventi delle $ore"}
		{options {{"Seleziona..."} [db_list_of_lists query "select concat(denominazione, ' - (', case when prezzo > 0::money then 'A pagamento' else 'Gratuito' end, ')'), evento_id from expo_eventi where start_time = :inizio and expo_id = :expo_id order by start_time, sala_id"]}}
		{html {style "width:900px;"}}
	    }
	}
    incr counter
}
#	{eventi:text(checkbox),multiple,optional
#	    {label "Corsi"}
#	    {options {[db_list_of_lists query "select e.denominazione||' - <small>('||case when e.prezzo > 0::money then 'A pagamento' else 'Gratuito' end||') alle '||to_char(e.start_time, 'HH24:MI')||' in sala '||s.denominazione||'</small>', e.evento_id from expo_eventi e, expo_sale s where e.expo_id = :expo_id and e.sala_id = s.sala_id order by e.start_time, e.sala_id"]}}
#	    {html {size 10}}
#	}
ad_form -extend \
    -name iscritto \
    -form {
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
	if {[db_0or1row query "SELECT iscritto_id FROM expo_iscritti WHERE email ilike '%:email%' and expo_id = :expo_id limit 1"]} {
	    set iscritto_id [db_string query "SELECT iscritto_id FROM expo_iscritti WHERE lower(email) like lower('%:email%') and expo_id = :expo_id limit 1"]
	    db_dml query "delete from expo_iscrizioni where iscritto_id = :iscritto_id"
	} else {
	    set iscritto_id [db_string query "SELECT COALESCE(MAX(iscritto_id)+(trunc(random()*99+1)),trunc(random()*99+1)) FROM expo_iscritti"]
	    set barcode [expr (803000000000 + $iscritto_id)]
	    db_dml query "INSERT INTO expo_iscritti (iscritto_id, nome, cognome, societa, email, provincia, telefono, data, expo_id, barcode) VALUES (:iscritto_id, INITCAP(LOWER(:nome)), INITCAP(LOWER(:cognome)), INITCAP(:societa), LOWER(:email), INITCAP(LOWER(:provincia)), :telefono, current_date, :expo_id, :barcode)"
	}
	set counter 1
	    set iscrizione_id [db_string query "select max(iscrizione_id) + trunc(random() *99+1) from expo_iscrizioni"]
	    db_dml query "insert into expo_iscrizioni (iscrizione_id, iscritto_id, evento_id, data, confermato) values (:iscrizione_id, :iscritto_id, :evento_id, current_date, true)"
    }

#DIVIDER: #EVENTI
#Comincia estrazione eventi per lista
set eventlist_html ""
db_foreach query "select e.evento_id, e.denominazione, substring(e.descrizione, 1, 500) as descrizione, to_char(e.start_time, 'HH24:MI') as start_time, e.permalink as evento_link, to_char(e.end_time, 'HH24:MI') as end_time, case when e.prezzo = 0::text::money then 'Percorso gratuito' else 'Percorso a pagamento*' end as prezzo, p.hex_color, p.descrizione as percorso, s.denominazione as sala from expo_eventi e, expo_percorsi p, expo_sale s, expo_edizioni d where e.percorso_id = p.percorso_id and e.sala_id = s.sala_id and e.expo_id = :expo_id order by e.start_time, e.sala_id" {
    set descrizione [string map {"<b>" "" "</b>" "" "<i>" "" "</i>" "" "<u>" "" "</u>" ""} $descrizione]
    append descrizione "..."
    #Prima e seconda colonna
    append eventlist_html "<div class=\"row\"><div class=\"col-md-4\"><p style=\"text-align:center\"><font color=\"$hex_color\">$percorso</font></p><h3 class=\"text-center\">$denominazione</h3><p class=\"text-center\" style=\"color:gray\"><b>$start_time - $end_time</b> Sala $sala <br>$prezzo</p></div><div class=\"col-md-8\"><p><i>$descrizione</i></p>"
    if {[db_0or1row query "select * from expo_relatori r, expo_eve_rel e where r.relatore_id = e.relatore_id and e.evento_id = :evento_id limit 1"] || [db_0or1row query "select * from docenti d, expo_eve_doc e where d.docente_id = e.docente_id and e.evento_id = :evento_id limit 1"]} {
	append eventlist_html "<br><div class=\"row\"><b>Speaker:</b><br>"
	# Estrae docenti legati all'evento
	db_foreach query "select d.nome, d.cognome, d.immagine, d.docente_id, d.permalink from docenti d, expo_eve_doc e where d.docente_id = e.docente_id and e.evento_id = :evento_id" {
            append eventlist_html "<a href=\"http://docenti.professionefinanza.com/$permalink\"><img class=\"img-circle\" src=\"http://images.professionefinanza.com/docenti/$immagine\" title=\"$nome $cognome\" width=\"50\" height=\"50\"></a>"
	}
	# Estrae relatori legati all'evento
	db_foreach query "select r.nome, r.cognome, r.immagine, r.relatore_id, r.permalink from expo_relatori r, expo_eve_rel e where r.relatore_id = e.relatore_id and e.evento_id = :evento_id" {
	    append eventlist_html "<a href=\"http://pfexpo.professionefinanza.com/relatori/$permalink\"><img class=\"img-circle\" src=\"http://images.professionefinanza.com/pfexpo/relatori_portraits/$immagine\" title=\"$nome $cognome\" width=\"50\" height=\"50\"></a>"
	}
	append eventlist_html "</div><br>" 
    } 
    if {[db_0or1row query "select * from expo_partners p, expo_eve_par e where e.evento_id = :evento_id and e.partner_id = p.partner_id limit 1"]} {
	append eventlist_html "<div class=\"row\"><b>Partner:</b><br>"
	#Estrae partners legati all'evento
	db_foreach query "select p.denominazione, p.partner_id, p.immagine, p.permalink from expo_partners p, expo_eve_par e where e.evento_id = :evento_id and e.partner_id = p.partner_id" {
	    append eventlist_html "<a href=\"http://pfexpo.professionefinanza.com/partners/$permalink\"><img height=\"70px\" class=\"img-circle\" src=\"http://images.professionefinanza.com/pfexpo/partners_portraits/$immagine\" alt=\"$denominazione\" width=\"auto\" /></a>"
	}
	append eventlist_html "</div>"
    }
    append eventlist_html "<button type=\"button\" class=\"btn btn-default\" onclick=\"window.location.href='http://expo.professionefinanza.com/programma/$evento_link'\">Dettagli</button></div></div><br>"
}

#DIVIDER: #RELATORI
#Estrae docenti
set speaker_list_html "<center><h3>Docenti</h3></center><br><div class=\"row\">"
db_foreach query "select d.docente_id, d.nome, d.cognome, d.immagine, d.permalink from docenti d, expo_eve_doc o, expo_eventi e where e.expo_id = :expo_id and e.evento_id = o.evento_id and d.docente_id = o.docente_id group by d.docente_id, d.nome, d.cognome, d.immagine, d.permalink order by d.cognome" {
    append permalink "?return_url=[ad_return_url -urlencode -qualified]"
    append speaker_list_html "<div class=\"col-lg-4\"><a href=\"http://docenti.professionefinanza.com/$permalink\"><img class=\"img-circle\" src=\"http://images.professionefinanza.com/docenti/$immagine\" alt=\"$nome $cognome\" width=\"140\" height=\"140\"><h2>$nome $cognome</h2></a></div><!-- /.col-lg-4 -->"
}
append speaker_list_html "</div><br></br>"
# Estrae relatori
append speaker_list_html "<center><h3>Relatori</h3></center><br><div class=\"row\">"
db_foreach query "select r.relatore_id, r.nome, r.cognome, r.immagine, r.permalink from expo_relatori r, expo_eventi e, expo_eve_rel l where e.expo_id = :expo_id and e.evento_id = l.evento_id and l.relatore_id = r.relatore_id order by cognome" {
    append speaker_list_html "<div class=\"col-lg-4\"><a href=\"relatori/$permalink\"><img class=\"img-circle\" src=\"http://images.professionefinanza.com/pfexpo/relatori_portraits/$immagine\" alt=\"$nome $cognome\" width=\"140\" height=\"140\"><h2>$nome $cognome</h2></a></div><!-- /.col-lg-4 -->"
}
append speaker_list_html "</div>"

#DIVIDER: #PARTNERS
set partners_list_html "<div class=\"container\"><div class=\"row\">"
db_foreach query "select categoria_id, descrizione as categoria from expo_par_cat order by item_order" {
    if {[db_0or1row query "select * from expo_partners where categoria_id = :categoria_id and visibile is true limit 1"]} {
	append partners_list_html "<div class=\"well well-sm\">$categoria</div><div style=\"overflow:hidden;display:block;position:relative;\"><ul style=\"display:block;list-style:none;margin:0;padding:0;\">"
	db_foreach query "select partner_id, immagine, permalink from expo_partners where categoria_id = :categoria_id and visibile is true order by item_order" {
	    append partners_list_html "<li rel=\"1\" style=\"position:relative;float:left;\"><a target=\"\" href=\"http://pfexpo.professionefinanza.com/partners/$permalink\"><img class=\"img-circle\" style=\"margin:25px;padding:10px;height:180px;\" src=\"http://images.professionefinanza.com/pfexpo/partners_portraits/$immagine\"></a></li>"
	}
	append partners_list_html "</ul></div><br>"
    }
}
append partners_list_html "</div></div>"

#DIVIDER: #EDIZIONI

#DIVIDER: #CONTATTI
set google_maps [db_string query "select l.google_maps from expo_luoghi l, expo_edizioni e where e.expo_id = :expo_id and e.luogo_id = l.luogo_id"]

ad_return_template
