# 

ad_page_contract {
    
    Programma prova per creazione tabella oraria pfexpo
    
    @author mattia (mattia.righetti@professionefinanza.com)
    @creation-date 2015-11-24
    @cvs-id $Id$
} {
    {expo_id "3"}
} -properties {
} -validate {
} -errors {
}
# Imposta colonne
set num_sale [db_string query "select count(*) from expo_edizioni e, expo_luoghi l, expo_sale s where s.luogo_id = l.luogo_id and 
