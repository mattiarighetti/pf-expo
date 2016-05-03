ad_page_contract {  
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date 2015-11-16
    @cvs-id $Id$set oacs:msg
} {
    {expo_id "4"}
    {msg ""}
}
# Se ID Expo vuoto, prende quello attivo
if {$expo_id eq ""} {
    set expo_id [db_string query "select expo_id from expo_edizioni where attivo is true"]
}
set session_id [ad_get_cookie session_id]
if {$session_id eq ""} {
    ad_set_cookie -max_age "inf" session_id [ad_get_cookie ad_session_id]
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
template::head::add_css -href "expo_style.css" 

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
#Imposta messaggio per overlap
if {$msg ne ""} {
    set msg_html "<div class=\"alert alert-danger alert-dismissible\" role=\"alert\"><strong>Attenzione!</strong><button type=\"button\" class=\"close\" data-dismiss=\"alert\" aria-label=\"Close\"><span aria-hidden=\"true\">&times;</span></button> Non puoi selezionare eventi in contemporanea</div>"
} else {
    set msg_html ""
}
set session_id [ad_get_cookie session_id]
# Imposta link per tabella
db_foreach query "select evento_id from expo_eventi where expo_id = :expo_id" {
    if {[db_0or1row query "select * from expo_tmp where evento_id = :evento_id and session_id = '[ad_get_cookie session_id]'"]} {
	set button_event_$evento_id "<br><a class=\"btn btn-danger btn-xs\" href=\"tmp?evento_id=$evento_id\"><span class=\"fa fa-times\"></span> Disiscriviti</a>"
    } else {
	set button_event_$evento_id "<br><a class=\"btn btn-primary btn-xs\" href=\"tmp?evento_id=$evento_id\"><span class=\"fa fa-check\"></span> Iscriviti</a>"
    }
}
#Imposta bottone conferma
if {[db_0or1row query "select * from expo_tmp where session_id = '[ad_get_cookie session_id]' limit 1"]} {
    set confirm_button "<a class=\"btn btn-success btn-lg\" href=\"form\"><span class=\"fa fa-check-circle\"></span> Conferma</a>"
} else {
    set confirm_button ""
}

#DIVIDER: #EVENTI
#Comincia estrazione eventi per lista
set eventlist_html ""
db_foreach query "select e.evento_id, e.denominazione, substring(e.descrizione, 1, 500) as descrizione, to_char(e.start_time, 'HH24:MI') as start_time, e.permalink as evento_link, to_char(e.end_time, 'HH24:MI') as end_time, case when e.prezzo = 0::text::money then 'Percorso gratuito' else 'Percorso a pagamento*' end as prezzo, p.hex_color, p.descrizione as percorso, s.denominazione as sala from expo_eventi e, expo_percorsi p, expo_sale s where e.percorso_id = p.percorso_id and e.sala_id = s.sala_id and e.expo_id = :expo_id order by e.start_time, e.sala_id" {
    set descrizione [string map {"<b>" "" "</b>" "" "<i>" "" "</i>" "" "<u>" "" "</u>" ""} $descrizione]
    append descrizione "..."
    #Prima e seconda colonna
    append eventlist_html "<div class=\"row\" style=\"background: -webkit-linear-gradient(white, $hex_color);background: -o-linear-gradient(white, $hex_color);background: -moz-linear-gradient(white, $hex_color);background: linear-gradient(white, $hex_color);\"><div class=\"col-md-4\"><p style=\"text-align:center\"><font color=\"$hex_color\">$percorso</font></p><h3 class=\"text-center\">$denominazione</h3><p class=\"text-center\" style=\"color:gray\"><b>$start_time - $end_time</b> Sala $sala <br>$prezzo</p></div><div class=\"col-md-8\"><p><i>$descrizione</i></p>"
    if {[db_0or1row query "select * from expo_speakers r, expo_eventi_speakers e where r.speaker_id = e.speaker_id and e.evento_id = :evento_id limit 1"] || [db_0or1row query "select * from docenti d, expo_eve_doc e where d.docente_id = e.docente_id and e.evento_id = :evento_id limit 1"]} {
	append eventlist_html "<br><div class=\"row\"><b>Speaker:</b><br>"
	set return_url [ns_urlencode http://pfexpo.professionefinanza.com/#programma]
	# Estrae docenti legati all'evento
	db_foreach query "select d.nome, d.cognome, d.immagine, d.docente_id, d.permalink from docenti d, expo_eve_doc e where d.docente_id = e.docente_id and e.evento_id = :evento_id" {
	    set permalink [export_vars -base $permalink {return_url}]
            append eventlist_html "<a href=\"http://docenti.professionefinanza.com/$permalink\"><img class=\"img-circle\" src=\"http://images.professionefinanza.com/docenti/$immagine\" title=\"$nome $cognome\" width=\"50\" height=\"50\"></a>"
	}
	# Estrae speaker legati all'evento
	db_foreach query "select r.nome, r.cognome, r.immagine, r.speaker_id, r.permalink from expo_speakers r, expo_eventi_speakers e where r.speaker_id = e.speaker_id and e.evento_id = :evento_id" {
	    append eventlist_html "<a href=\"http://pfexpo.professionefinanza.com/speakers/$permalink\"><img class=\"img-circle\" src=\"http://images.professionefinanza.com/pfexpo/speakers_portraits/$immagine\" title=\"$nome $cognome\" width=\"50\" height=\"50\"></a>"
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
    append eventlist_html "<button type=\"button\" class=\"btn btn-default\" onclick=\"window.location.href='http://pfexpo.professionefinanza.com/programma/$evento_link'\">Dettagli</button></div></div><br>"
}

#DIVIDER: #SPEAKER
#Estrae special guest
set speaker_list_html "<center><h3>Special guest</h3></center><br><div class=\"row\">"
db_foreach query "select distinct(r.speaker_id), r.nome, r.cognome, r.immagine, r.permalink from expo_speakers r, expo_eventi e, expo_eventi_speakers l where e.expo_id = :expo_id and e.evento_id = l.evento_id and l.speaker_id = r.speaker_id and r.tipo_id = 3 order by cognome" {
    append speaker_list_html "<div class=\"col-lg-4 col-md-4 col-sm-6 col-xs-12\"><center><a href=\"speakers/$permalink\"><img class=\"img-circle\" src=\"http://images.professionefinanza.com/pfexpo/speakers_portraits/$immagine\" alt=\"$nome $cognome\" width=\"140\" height=\"140\"><h4>$nome $cognome</h4></center></a></div>"
}
append speaker_list_html "</div>"
#Estrae docenti
append speaker_list_html "<br><center><h3>Docenti</h3></center><br><div class=\"row\">"
db_foreach query "select d.docente_id, d.nome, d.cognome, d.immagine, d.permalink from docenti d, expo_eve_doc o, expo_eventi e where e.expo_id = :expo_id and e.evento_id = o.evento_id and d.docente_id = o.docente_id group by d.docente_id, d.nome, d.cognome, d.immagine, d.permalink order by d.cognome" {
    append permalink "?return_url=[ad_return_url -urlencode -qualified]"
    append speaker_list_html "<div class=\"col-lg-4 col-md-4 col-sm-6 col-xs-12\"><center><a href=\"http://docenti.professionefinanza.com/$permalink\"><img class=\"img-circle\" src=\"http://images.professionefinanza.com/docenti/$immagine\" alt=\"$nome $cognome\" width=\"140\" height=\"140\"><h4>$nome $cognome</h4></center></a></div><!-- /.col-lg-4 -->"
}
append speaker_list_html "</div><br></br>"
#Estrae Moderatori
db_foreach query "select tipo_id, descrizione as tipologia from expo_speakers_tipo where tipo_id = 1 order by item_order" {
    if {[db_0or1row query "select * from expo_speakers r, expo_eventi e, expo_eventi_speakers l where e.expo_id = :expo_id and e.evento_id = l.evento_id and l.speaker_id = r.speaker_id and r.tipo_id = :tipo_id limit 1"]} {
	append speaker_list_html "<br><center><h3>$tipologia</h3></center><br><div class=\"row\">"
	db_foreach query "select distinct(r.speaker_id), r.nome, r.cognome, r.immagine, r.permalink from expo_speakers r, expo_eventi e, expo_eventi_speakers l where e.expo_id = :expo_id and e.evento_id = l.evento_id and l.speaker_id = r.speaker_id and r.tipo_id = 1  order by cognome" {
	    append speaker_list_html "<div class=\"col-lg-4 col-md-4 col-sm-6 col-xs-12\"><center><a href=\"speakers/$permalink\"><img class=\"img-circle\" src=\"http://images.professionefinanza.com/pfexpo/speakers_portraits/$immagine\" alt=\"$nome $cognome\" width=\"140\" height=\"140\"><h4>$nome $cognome</h4></center></a></div><!-- /.col-lg-4 -->"
	}
	append speaker_list_html "</div>"
    }
}
# Estrae speaker
db_foreach query "select tipo_id, descrizione as tipologia from expo_speakers_tipo where tipo_id = 2 order by item_order" {
    if {[db_0or1row query "select * from expo_speakers r, expo_eventi e, expo_eventi_speakers l where e.expo_id = :expo_id and e.evento_id = l.evento_id and l.speaker_id = r.speaker_id and r.tipo_id = :tipo_id limit 1"]} {
	append speaker_list_html "<br><center><h3>$tipologia</h3></center><br><div class=\"row\">"
	db_foreach query "select distinct(r.speaker_id), r.nome, r.cognome, r.immagine, r.permalink from expo_speakers r, expo_eventi e, expo_eventi_speakers l where e.expo_id = :expo_id and e.evento_id = l.evento_id and l.speaker_id = r.speaker_id and r.tipo_id = 2  order by cognome" {
	    append speaker_list_html "<div class=\"col-lg-4 col-md-4 col-sm-6 col-xs-12\"><center><a href=\"speakers/$permalink\"><img class=\"img-circle\" src=\"http://images.professionefinanza.com/pfexpo/speakers_portraits/$immagine\" alt=\"$nome $cognome\" width=\"140\" height=\"140\"><h4>$nome $cognome</h4></center></a></div><!-- /.col-lg-4 -->"
	}
	append speaker_list_html "</div>"
    }
}
#DIVIDER: #PARTNERS
set partners_list_html "<div class=\"container\"><div class=\"row\">"
db_foreach query "select categoria_id, descrizione as categoria from expo_par_cat order by item_order" {
    if {[db_0or1row query "select * from expo_partners where categoria_id = :categoria_id and visibile is true limit 1"]} {
	append partners_list_html "<center><h2>$categoria</h2></center><div class=\"row\">"
	db_foreach query "select partner_id, immagine, permalink from expo_partners where categoria_id = :categoria_id and visibile is true order by item_order, denominazione" {
	    append partners_list_html "<div class=\"text-center col-lg-4 col-md-4 col-sm-6 col-xs-12\">
<a target=\"\" href=\"http://pfexpo.professionefinanza.com/partners/$permalink\">
<img class=\"img-circle\" style=\"margin:25px;padding:10px;height:180px;\" src=\"http://images.professionefinanza.com/pfexpo/partners_portraits/$immagine\">
</a>
</div>"
	}
	append partners_list_html "</div><br>"
    }
}
append partners_list_html "</div></div>"

#DIVIDER: #EDIZIONI

#DIVIDER: #CONTATTI
set google_maps [db_string query "select l.google_maps from expo_luoghi l, expo_edizioni e where e.expo_id = :expo_id and e.luogo_id = l.luogo_id"]

ad_return_template
