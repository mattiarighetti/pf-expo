ad_page_contract {
} {
    iscritto_id:naturalnum
}
set page_title "Iscrizione - PFEXPO"
set context ""
set logo_url "http://images.professionefinanza.com/pfexpo/logos/"
append logo_url [db_string query "select immagine from expo_edizioni where attivo is true"]
#set expo_data [db_string query "select to_char(data, 'DD/MM/YYYY') from expo_edizioni where expo_id = :expo_id"]
#set expo_luogo [db_string query "select c.denominazione from comuni c, expo_edizioni e, expo_luoghi l where l.comune_id = c.comune_id and l.luogo_id = e.luogo_id and e.expo_id = :expo_id"]
ad_set_cookie -replace 1 session_id ""
set expo_id [db_string query "select expo_id from expo_edizioni where attivo is true"]
#Estrae lista eventi per riepilogo
set event_list "<table><tr><th>Corsi scelti</th>"
#<th colspan=\"2\">Note</th></tr>"
db_foreach query "select e.denominazione, s.denominazione as sala, to_char(e.start_time, 'HH24:MI') as orario, case when e.prezzo > 0::money then 'A pagamento' else 'Gratis' end as prezzo, i.voucher_id from expo_eventi e, expo_iscrizioni i, expo_sale s where s.sala_id = e.sala_id and i.evento_id = e.evento_id and i.iscritto_id = :iscritto_id" {
    append event_list "<tr><td>$denominazione <small>(Sala $sala, alle $orario)</small></td>"
    if {$voucher_id ne ""} {
	set voucher_code [db_string query "select codice from expo_voucher where voucher_id = :voucher_id"]
	append event_list "<td>Voucher: $voucher_code</td><td>Gratis</td>"
    } else {
	append event_list "<td></td><td>$prezzo</td>"
	if {$prezzo eq "A pagamento"} {
	    set da_pagare t
	}
    }    
    append event_list "</tr>"
}
append event_list "</table>"
#Imposta email
set nominativo [db_string query "select nome||' ' ||cognome from expo_iscritti where iscritto_id = :iscritto_id"]
set from_mail "info@pfexpo.it"
set to_mail [db_string query "select email from expo_iscritti where iscritto_id = :iscritto_id"]
set subject "Conferma iscrizione all'evento PFEXPO"
set body {
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  <title>[SUBJECT]</title>
  <style type="text/css">
body {
  padding-top: 0 !important;
  padding-bottom: 0 !important;
  padding-top: 0 !important;
  padding-bottom: 0 !important;
  margin: 0 !important;
  width: 100% !important;
  -webkit-text-size-adjust: 100% !important;
  -ms-text-size-adjust: 100% !important;
  -webkit-font-smoothing: antialiased !important;
}
.tableContent img {
  border: 0 !important;
  display: block !important;
  outline: none !important;
}
a {
  color: #000;
}
p, h1 {
  color: #382F2E;
  margin: 0;
}
div, p, ul, h1 {
  margin: 0;
}
p {
  font-size: 13px;
  color: #99A1A6;
  line-height: 19px;
}
h2, h1 {
  color: #444444;
  font-weight: normal;
  font-size: 22px;
  margin: 0;
}
a.link2 {
  padding: 15px;
  font-size: 13px;
  text-decoration: none;
  background: #2D94DF;
  color: #ffffff;
  border-radius: 6px;
  -moz-border-radius: 6px;
  -webkit-border-radius: 6px;
}
.bgBody {
  background: #f6f6f6;
}
.bgItem {
  background: #2C94E0;
}
</style>
  </head>
  <body paddingwidth="0" paddingheight="0" bgcolor="#d1d3d4" style="padding-top: 0; padding-bottom: 0; padding-top: 0; padding-bottom: 0; background-repeat: repeat; width: 100% !important; -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; -webkit-font-smoothing: antialiased;" offset="0" toppadding="0" leftpadding="0">
  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tableContent bgBody" align="center" style="font-family:Helvetica, Arial,serif;">
    
    <!-- =============================== Header ====================================== -->
    
    <tr>
      <td><table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
          <tr>
          <td class="movableContentContainer"><div class="movableContent">
              <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                <tr>
                  <td height="25" colspan="3"></td>
                </tr>
                <tr>
                  <td valign="top" colspan="3"><table width="600" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                      <tr>
                        <td align="left" valign="middle"><div class="contentEditableContainer contentImageEditable">
                            <div class="contentEditable">
                              <center>
<img src=}
append body $logo_url
append body { alt="Compagnie logo" data-default="placeholder" data-max-width="300" width="274" height="91" />
                              </center>
                            </div>
                          </div></td>
                      </tr>
                    </table></td>
                </tr>
              </table>
            </div>
              <div class="movableContent">
              <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                <tr>
                  <td><table width="600" border="0" cellspacing="0" cellpadding="0" align="center">
                      <tr>
                        <td height="25">&nbsp;</td>
                      </tr>
                      <tr>
                        <td style="border-bottom:3px solid #DDDDDD"></td>
                      </tr>
                      <tr>
                        <td height="10">&nbsp;</td>
                      </tr>
                    </table></td>
                </tr>
                </table>
            </div>
              <div class="movableContent">
              <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                <tr>
                  <td><table width="600" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                      <tr>
                        <td colspan="3" height="15"></td>
                      </tr>
                      <tr>
                        <td width="50"></td>
                        <td width="500"><table width="500" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                            <tr>
                              <td align="center"><div class="contentEditableContainer contentTextEditable">
                                  <div class="contentEditable">
                                    <h1 style="font-size:15px; color:#ffff" align="left">Gentile }
                                      append body $nominativo
                                      append body {</h1>
<h1 style="font-size:15px; color:#ffff" align="left">nel ringraziarti per esserti iscritto al prossimo <strong>PFEXPO del }
append body [db_string query "select to_char(data, 'DD/MM/YYYY') from expo_edizioni where expo_id = :expo_id"] " a " [db_string query "select c.denominazione from comuni c, expo_edizioni e, expo_luoghi l where l.comune_id = c.comune_id and l.luogo_id = e.luogo_id and e.expo_id = :expo_id"]
append body {</strong>, </h1>
                                    <h1 style="font-size:15px; color:#ffff" align="left">ti confermiamo che i percorsi a cui hai scelto di partecipare ci risultano essere i seguenti:</h1>
                                    <p style="font-size:15px; color:#ffff" align="left">&nbsp;</p>
}
db_foreach query "select e.denominazione, to_char(e.start_time, 'hh24:mi') as tempo, s.denominazione as sala from expo_iscrizioni i, expo_eventi e, expo_sale s where i.iscritto_id = :iscritto_id and i.evento_id = e.evento_id and s.sala_id = e.sala_id order by e.start_time" {
append body "<p style=\"font-size:15px;color:#000;\" align=\"left\"><i>-&nbsp;$denominazione, in sala $sala alle $tempo</i></p>"
                                    }
                                    append body {
                                    <p style="font-size:15px; color:#ffff" align="left">&nbsp;</p>
                                    <h1 style="font-size:15px; color:#ffff" align="left">
                                    Se preferisci valutare anche altri temi puoi andare sul sito <strong><a href="http://pfexpo.professionefinanza.com/">www.pfexpo.it</a></strong> dove, reinserendo sempre la tua mail (}
                                    append body $to_mail
					append body {), potrai eventualmente selezionare nuovi percorsi.
					<h3>N.B.: Ti ricordiamo che ogni nuova iscrizione canceller&agrave; le precedenti.
				  
                                    </p>
                                  </div>
                                </div></td>
                            </tr>
                            <tr>
                              <td align="center"><div class="contentEditableContainer contentTextEditable">
                                <div class="contentEditable">
                                
                                <!--bo-->
                                
                                <div class="movableContent">
                                  <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                                    <tr>
                                      <td><table width="200" border="0" cellspacing="0" cellpadding="0" align="center">
                                          <tr>
                                            <td height="15">&nbsp;</td>
                                          </tr>
                                          <tr>
                                            <td style="border-bottom:1px solid #DDDDDD"></td>
                                          </tr>
                                          <tr>
                                            <td height="15">&nbsp;</td>
                                          </tr>
                                        </table></td>
                                    </tr>
                                  </table>
                                </div>
                                }
                                if {[db_0or1row query "select * from expo_iscrizioni i, expo_eventi e where i.iscritto_id = :iscritto_id and i.evento_id = e.evento_id and e.prezzo > 0::money limit 1"]} {
                                append body {
                                <h1 style="font-size:15px; color:#ffff" align="left">Ti sei iscritto a un corso a pagamento, <b>in caso tu non abbia usufruito di un VOUCHER</b>, potrai procedere in due modi:<br><br />
                                  - effettuare un bonifico bancario di 120,78 € (99,00 + IVA) intestato a:<br />
                                  </br>
                                  <strong>PF Holding srl</strong> - IBAN: IT17P0103001610000000606927 SWIFT: PASCITM1MI - Causale: Corso PFEXPO + cognome partecipante <br />
                                  </br>
                                  - pagare con carta di credito <a href="https://www.paypal.com/it/cgi-bin/webscr?cmd=_flow&SESSION=R5G9-MM9jhLIeOHXBVPthdG-OAO58NXSIAcJbo9zCJg9NFdPbp7ha0vwsXO&dispatch=50a222a57771920b6a3d7b606239e4d529b525e0b7e69bf0224adecfb0124e9b61f737ba21b081984719ecfa9a8ffe80733a1a700ced90ae">cliccando qua</a>.<br> <br />
				    </br>
                                  <br />
                                  Per l'emissione della relativa fattura invia una mail con i propri dati fiscali all'indirizzo:<br />
                                <a href="mailto:fatturazione@professionefinanza.com">fatturazione@professionefinanza.com</a> </h1>
                                }
                                }
                                append body {
                                <div class="movableContent">
                                  <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                                    <tr>
                                      <td><table width="200" border="0" cellspacing="0" cellpadding="0" align="center">
                                          <tr>
                                            <td height="15">&nbsp;</td>
                                          </tr>
                                          <tr>
                                            <td style="border-bottom:1px solid #DDDDDD"></td>
                                          </tr>
                                          <tr>
                                            <td height="15">&nbsp;</td>
                                          </tr>
                                        </table></td>
                                    </tr>
                                  </table>
                                </div>
                                <div class="contentEditableContainer contentTextEditable">
                                  <div class="contentEditable">
                                    <h1> </h1>
                                    <h1 style="font-size:15px; color:#ffff">&nbsp;</h1>
                                    <p style="font-size:15px; color:#ffff">&nbsp;</p>
                                    <p style="font-size:15px; color:#ffff">&nbsp;</p>
                                    <h1 style="font-size:15px; color:#F90; font-weight: bold;" align="center">Ti ringraziamo per la disponibilità, ti aspettiamo il 7 giugno a Firenze.
                                      </p>
                                      <!---azzurro--> </h1>
                                    <div class="movableContent">
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                                        <tr>
                                          <td><table width="600" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                                              <tr>
                                                <td colspan="3" height="10"></td>
                                              </tr>
                                              <tr>
                                                <td width="50"></td>
                                                <td width="540"><table width="400" border="0" cellspacing="0" cellpadding="0" align="center"  bgcolor="#FF9900"valign="top">
                                                    <tr>
                                                      <td align="center"><div class="contentEditableContainer contentTextEditable">
                                                          <div class="contentEditable">
                                                            <h1 style="font-size:20px; color:#FFF; font-weight: bold;">Lo staff di Professione Finanza</h1>
                                                          </div>
                                                        </div></td>
                                                    </tr>
                                                    <tr>
                                                      <td align="center"></td>
                                                    </tr>
                                                  </table></td>
                                                <td width="50"></td>
                                              </tr>
                                              <tr>
                                                <td colspan="3" height="15"></td>
                                              </tr>
                                            </table></td>
                                        </tr>
                                      </table>
                                    </div>
                                    
                                    <!--fine azzurro--> 
                                    
                                  </div>
                                </div></td>
                            </tr>
                          </table></td>
                        <td width="50"></td>
                      </tr>
                      <tr>
                        <td colspan="3" height="18"></td>
                      </tr>
                    </table></td>
                </tr>
                </table>
            </div>
              <div class="movableContent">
              <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                <tr>
                  <td><table width="600" border="0" cellspacing="0" cellpadding="0" align="center">
                      <tr>
                        <td height="10">&nbsp;</td>
                      </tr>
                      <tr>
                        <td style="border-bottom:3px solid #DDDDDD"></td>
                      </tr>
                      <tr>
                        <td height="10">&nbsp;</td>
                      </tr>
                    </table></td>
                </tr>
                </table>
            </div>
              
              <!--data-->
              
              <div class="movableContent">
              <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                <tr>
                  <td><table width="600" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                      <tr>
                        <td colspan="3" height="15"></td>
                      </tr>
                      <tr>
                        <td width="50"></td>
                        <td width="500"><table width="549" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                            <tr>
                              <td align="center"><div class="contentEditableContainer contentTextEditable">
                                  <div class="contentEditable">
                                    <h1 style="font-size:36px; color:#27567E">}
append body [db_string query "select to_char(data, 'DD/MM/YYYY') from expo_edizioni where attivo is true"]
append body { - <strong>FIRENZE</strong></h1>
    <h1 style="font-size:16px; color:#999">}
append body [db_string query "select l.denominazione from expo_luoghi l, expo_edizioni e where e.attivo is true and e.luogo_id = l.luogo_id"]
append body {</h1>
                                  </div>
                                </div></td>
                            </tr>
                            <tr>
                              <td height="10"></td>
                            </tr>
                            <tr>
                              <td align="center"><div class="contentEditableContainer contentTextEditable">
                                  <div class="contentEditable">
                                    <h1 style="font-size:32px; color: #F90;"><strong>Ti aspettiamo!</strong> </h1>
                                    <p style="font-size:32px; color: #27567E;">&nbsp;</p>
                                    
                                    <!---azzurro-->
                                    <div class="movableContent">
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                                        <tr>
                                          <td><table width="600" border="0" cellspacing="0" cellpadding="0" align="center" bgcolor="27567E" valign="top">
                                              <tr>
                                                <td colspan="3" height="20"></td>
                                              </tr>
                                              <tr>
                                                <td width="50"></td>
                                                <td width="500"><table width="549" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                                                    <tr>
                                                      <td align="center"><div class="contentEditableContainer contentTextEditable">
                                                          <div class="contentEditable">
                                                            <h1 style="font-size:20px; color:#FFF" ></h1>
                                                          </div>
                                                        </div></td>
                                                    </tr>
                                                    <tr>
                                                      <td align="center"></td>
                                                    </tr>
                                                  </table></td>
                                                <td width="50"></td>
                                              </tr>
                                              <tr>
                                                <td colspan="3" height="15"></td>
                                              </tr>
                                            </table></td>
                                        </tr>
                                      </table>
                                    </div>
                                    
                                    <!--fine azzurro--> 
                                  </div>
                                </div></td>
                            </tr>
                          </table></td>
                        <td width="50"></td>
                      </tr>
                      <tr>
                        <td colspan="3" height="5"></td>
                      </tr>
                    </table></td>
                </tr>
                </table>
            </div>
              
              <!--data-->
              
              <div class="movableContent">
              <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                  <tr>
                  <td><table width="600" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                      <tr>
                        <td><table width="600" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                            <tr>
                              <td><table width="600" border="0" cellspacing="0" cellpadding="0" align="center">
                                  <tr>
                                    <td height="10">&nbsp;</td>
                                  </tr>
                                  <tr>
                                    <td style="border-bottom:1px solid #DDDDDD"></td>
                                  </tr>
                                  <tr>
                                    <td height="10">&nbsp;</td>
                                  </tr>
                                </table></td>
                            </tr>
                            <tr>
                              <td height="18">&nbsp;</td>
                            </tr>
                            <tr>
                              <td valign="top" align="center"><div class="contentEditableContainer contentImageEditable">
                                  <div class="contentEditable"> <img src="footer nuovo logo.png" /> </div>
                                </div></td>
                            </tr>
                            <tr>
                              <td height="28">&nbsp;</td>
                            </tr>
                            <tr>
                              <td valign="top" align="center"></td>
                            </tr>
                            <tr>
                              <td height="28">&nbsp;</td>
                            </tr>
                          </table></td>
                      </tr>
                    </table></td>
                </tr>
                </table>
            </div></td>
        </tr>
        </table></td>
    </tr>
  </table>
</body>
</html>
}
acs_mail_lite::send -to_addr $to_mail -from_addr $from_mail -mime_type "text/html" -subject $subject -body $body
ad_return_template