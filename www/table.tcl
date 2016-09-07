# 

ad_page_contract {
    
    
    
    @author mattia (mattia.righetti@professionefinanza.com)
    @creation-date 2016-06-06
    @cvs-id $Id$
} {
    {expo_id 4}
} -properties {
} -validate {
} -errors {
}
template::head::add_css -href "/timetable.css"
template::add_body_handler -event "style" -script "position:relative;"
template::head::add_css -href "expo_style.css" 

set orari [db_list query "select * from (select start_time as orari from expo_eventi where expo_id = :expo_id union select end_time as orari from expo_eventi where expo_id = :expo_id) t order by orari"]
set table "<table cellspacing=\"5\" cellpadding=\"5\" class=\"tbl\"><tbody><tr class=\"blue\"><td><img class=\"center-block\" height=\"auto\" width=\"120px\" src=\"@logo_url;noquote@\"></td>"
#Estrazione sale
db_foreach query "select s.denominazione from expo_sale s, expo_luoghi l, expo_edizioni e where e.expo_id = :expo_id and e.luogo_id = l.luogo_id and s.luogo_id = l.luogo_id order by s.sala_id" {
    append table "<td>" $denominazione "<br></td>"
}
append table "</tr>"
foreach orario $orari {
append table "<tr><td class=\"blue\">" $orario "</td>"
    db_foreach query "select e.denominazione,  c.hex_color, e.permalink, e.start_time, e.end_time from expo_eventi e, expo_percorsi c where e.start_time = :orario and c.percorso_id = e.percorso_id order by sala_id" {
	set rowspan [expr [lsearch $orari $end_time] - [lsearch $orari $start_time] + 1]
	append table "<td rowspan=\"" $rowspan "\" bgcolor=\"" $hex_color "\"><a href=\"" $permalink "\">" $denominazione "<br></a></td>"
    }
    append table "</tr>"
}
append table "</tbody></table>"
ad_return_template
		
