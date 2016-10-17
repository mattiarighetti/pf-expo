# 

ad_page_contract {
    
    Programma di estrazione degli speakers collegati all'edizione corrente.
    
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date 2016-10-11
    @cvs-id $Id$
} {
    {expo_id [pf::expo::id]}
} -properties {
} -validate {
} -errors {
}
set logo_url "http://images.professionefinanza.com/pfexpo/logos/"
append logo_url [db_string query "select immagine from expo_edizioni where expo_id = :expo_id"]
#DIVIDER: #SPEAKER
#Estrae special guest
set speaker_list_html "<center><h3>Special guest</h3></center><br><div class=\"row\">"
db_foreach query "select distinct(r.speaker_id), r.nome, r.cognome, r.immagine, r.permalink from expo_speakers r, expo_eventi e, expo_eventi_speakers l where e.expo_id = :expo_id and e.evento_id = l.evento_id and l.speaker_id = r.speaker_id and l.tipo_id = 3 order by cognome" {
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
    if {[db_0or1row query "select * from expo_speakers r, expo_eventi e, expo_eventi_speakers l where e.expo_id = :expo_id and e.evento_id = l.evento_id and l.speaker_id = r.speaker_id and l.tipo_id = :tipo_id limit 1"]} {
	append speaker_list_html "<br><center><h3>$tipologia</h3></center><br><div class=\"row\">"
	db_foreach query "select distinct(r.speaker_id), r.nome, r.cognome, r.immagine, r.permalink from expo_speakers r, expo_eventi e, expo_eventi_speakers l where e.expo_id = :expo_id and e.evento_id = l.evento_id and l.speaker_id = r.speaker_id and l.tipo_id = 1  order by cognome" {
	    append speaker_list_html "<div class=\"col-lg-4 col-md-4 col-sm-6 col-xs-12\"><center><a href=\"speakers/$permalink\"><img class=\"img-circle\" src=\"http://images.professionefinanza.com/pfexpo/speakers_portraits/$immagine\" alt=\"$nome $cognome\" width=\"140\" height=\"140\"><h4>$nome $cognome</h4></center></a></div><!-- /.col-lg-4 -->"
	}
	append speaker_list_html "</div>"
    }
}

#Estrae speaker
db_foreach query "select tipo_id, descrizione as tipologia from expo_speakers_tipo where tipo_id = 2 order by item_order" {
    if {[db_0or1row query "select * from expo_speakers r, expo_eventi e, expo_eventi_speakers l where e.expo_id = :expo_id and e.evento_id = l.evento_id and l.speaker_id = r.speaker_id and l.tipo_id = :tipo_id limit 1"]} {
	append speaker_list_html "<br><center><h3>$tipologia</h3></center><br><div class=\"row\">"
	db_foreach query "select distinct(r.speaker_id), r.nome, r.cognome, r.immagine, r.permalink from expo_speakers r, expo_eventi e, expo_eventi_speakers l where e.expo_id = :expo_id and e.evento_id = l.evento_id and l.speaker_id = r.speaker_id and l.tipo_id = 2  order by cognome" {
	    append speaker_list_html "<div class=\"col-lg-4 col-md-4 col-sm-6 col-xs-12\"><center><a href=\"speakers/$permalink\"><img class=\"img-circle\" src=\"http://images.professionefinanza.com/pfexpo/speakers_portraits/$immagine\" alt=\"$nome $cognome\" width=\"140\" height=\"140\"><h4>$nome $cognome</h4></center></a></div><!-- /.col-lg-4 -->"
	}
	append speaker_list_html "</div>"
    }
}
ad_return_template
