ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Tuesday 26 May 2015
} {
    evento_id:integer
    {message ""}
}
db_1row query "select e.denominazione as evento, p.hex_color, case when e.prezzo = 0::money then 'Partecipazione gratuita' else '<img src=\"http://pfexpo.professionefinanza.com/timetable/pagamento.png\"/> Partecipazione a pagamento<br>Costo: € 99.00 + IVA.<br>' end as prezzo, s.denominazione as sala, to_char(e.start_time, 'HH24:MI') as start_time, to_char(e.end_time, 'HH24:MI') as end_time, case when e.soldout is true then '<div class=\"alert alert-warning alert-dismissible\"><button type=\"button\" class=\"close\" data-dismiss=\"alert\" aria-label=\"Close\"><span aria-hidden=\"true\">&times;</span></button>Il corso è in stato di Sold Out.</br>' else '' end as soldout_msg from expo_eventi e, expo_percorsi p, expo_sale s where s.sala_id = e.sala_id and p.percorso_id = e.percorso_id and e.evento_id = :evento_id"
set page_title $evento
set logo_url "http://images.professionefinanza.com/pfexpo/logos/"
append logo_url [db_string query "select immagine from expo_edizioni where attivo is true"]
set context [list [list /programma "Programma"] $page_title]
set fe_html_menu [pf::fe_html_menu -id 7]

#Estrae docenti
if {[db_0or1row query "select * from docenti d, expo_eve_doc e where d.docente_id = e.docente_id and e.evento_id = :evento_id limit 1"]} {
    set docenti "<center><h4>Docenti</h4><table><tr>"
    db_foreach query "select d.nome, d.cognome, d.immagine, d.permalink, d.docente_id from docenti d, expo_eve_doc e where d.docente_id = e.docente_id and e.evento_id = :evento_id" {
	append permalink "?return_url=[ad_return_url -urlencode]"
	append docenti "<td><center><a href=\"http://docenti.professionefinanza.com/$permalink\"><img class=\"img-circle img-responsive\" style=\"display:inline-block;\" src=\"http://images.professionefinanza.com/docenti/$immagine\" alt=\"$nome $cognome\" width=\"100\" height=\"100\"><p><center><b>$nome $cognome</b></center></p></center></td>"
    }
    append docenti "</tr></table>"
} else {
    set docenti ""
}
#Estrae speakers per ogni categoria
set speakers "<center>"
db_foreach query "select tipo_id, descrizione from expo_speakers_tipo order by item_order" {
    if {[db_0or1row query "select * from expo_eventi_speakers e, expo_speakers s where s.speaker_id = e.speaker_id and e.evento_id = :evento_id and e.tipo_id = :tipo_id limit 1"]} {
	append speakers "<h4>$descrizione</h4><table border=\"0\"><tr>"
	set speaker_partners ""
	db_foreach query "select r.nome, r.cognome, r.immagine, r.permalink, r.speaker_id, r.partner_id from expo_speakers r, expo_eventi_speakers e where r.speaker_id = e.speaker_id and e.evento_id = :evento_id and e.tipo_id = :tipo_id order by r.partner_id, r.cognome" {
	    append speakers "<td><center><a href=\"http://pfexpo.professionefinanza.com/speakers/$permalink\"><img class=\"img-circle img-responsive\" style=\"display:inline-block;\" src=\"http://images.professionefinanza.com/pfexpo/speakers_portraits/$immagine\" alt=\"$nome $cognome\" width=\"100\" height=\"100\"><p><b>$nome $cognome</b></p></center></td>"
	    if {$partner_id ne ""} {
		db_1row query "select immagine, permalink from expo_partners where partner_id = :partner_id"
		append speaker_partners "<td><center><a href=\"http://pfexpo.professionefinanza.com/partners/$permalink\"><img class=\"img-circle img-responsive\" style=\"display:inline-block;\" src=\"http://images.professionefinanza.com/pfexpo/partners_portraits/$immagine\" width=\"150\" height=\"150\"></a></center></td>"
	    } else {
		append speaker_partners "<td></td>"
	    }
	}
	append speakers "</tr><tr>" $speaker_partners "</tr></table>"
    }
}
append speakers "</center>"
#Estrae partners
set partners ""
db_foreach query "select p.denominazione, p.partner_id, p.immagine, p.permalink from expo_partners p, expo_eve_par e where e.evento_id = :evento_id and e.partner_id = p.partner_id" {
    append partners "<a href=\"http://pfexpo.professionefinanza.com/partners/$permalink\"><img height=\"70px\" class=\"img-circle\" src=\"http://images.professionefinanza.com/pfexpo/partners_portraits/$immagine\" alt=\"$denominazione\" width=\"auto\" /></a>"
}
set descrizione [string map {\r <br> \n <br>} [db_string query "select descrizione from expo_eventi where evento_id = :evento_id"]]
if {[db_0or1row query "select * from expo_tmp where evento_id = :evento_id and session_id = '[ad_get_cookie session_id]'"]} {
    set button "<center><a class=\"btn btn-danger\" href=\"/tmp?evento_id=$evento_id&return_url=[ns_urlencode [ns_conn url]]\"><span class=\"fa fa-times\"> Disiscriviti</span></a></center>"
} else {
    set button "<center><a class=\"btn btn-success\" href=\"/tmp?evento_id=$evento_id\"><span class=\"fa fa-check-circle\"> Iscriviti</span></a></center>"
}
template::head::add_css -href "/expo_style.css" 
ad_return_template
