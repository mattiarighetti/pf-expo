  <master>
    <property name="page_title">@page_title;noquote@</property>
    <property name="context">@context;noquote@</property>
    
    <div class="container">
      @fe_html_menu;noquote@    
      <br>
	<div class="row">
	  <div class="col-md-2">
	    <a target="_blank" href="http://www.pfawards.it/"><img class="img-responsive" style="display:inline-block;" width="auto" src="http://images.professionefinanza.com/banners/pfawards16-short.gif" /></a>
	  </div>
	  <div class="col-md-8">
	    <center>
	      <img class="center-block" style="display:inline-block;" height="100px" width="auto" src="@logo_url;noquote@" />
	    </center>
	  </div>
	  <div class="col-md-2">
	    <a target="_blank" href="http://www.pfawards.it/"><img class="img-responsive" style="display:inline-block;" width="auto" src="http://images.professionefinanza.com/banners/pfawards16-short.gif" /></a>
	  </div>
	</div>
      </br> 
      <center>
      <formtemplate id="iscritto">
	<tr>
	  <td>
	    <formwidget id="email">
	  </td>
	  <td>
            <formwidget id="nome">
	  </td>
	  <td>
            <formwidget id="cognome">
	  </td>
	</tr>
	<tr>
	  <td>
	    <font color="red"><formerror id="email">Indirizzo email non valido.<br></formerror></font>
	  </td>
	  <td>
	    <font color="red"><formerror id="nome">Nome non valido.<br></formerror></font>
	  </td>
	  <td>
	    <font color="red"><formerror id="cognome">Cognome non valido.<br></formerror></font>
	  </td>
	</tr>
	<tr>
	  <td>
            <formwidget id="societa">
	  </td>
	  <td>
            <formwidget id="provincia">
	  </td>
	  <td>
            <formwidget id="telefono">
	  </td>
	</tr>
	<tr>
	  <td>
	    <font color="red"><formerror id="societa">Società non valida.</formerror></font>
	  </td>
	  <td>
	    <font color="red"><formerror id="provincia">Provincia non valida.<br></formerror></font>
	  </td>
	  <td>
	    <font color="red"><formerror id="telefono">Telefono non valido.<br></formerror></font>
	  </td>
	</tr>
	<tr>
	  <td colspan="3">
	    <formwidget id="morning1"><br>
		<font color="red"><formerror id="morning1"></formerror></font>
	  </td>
	</tr>
	<tr>
	  <td colspan="3">
	    <formwidget id="morning2"><br>
		<font color="red"><formerror id="morning2"></formerror></font>
	  </td>
        </tr>
        <tr>
          <td colspan="3">
	    <formwidget id="noon"><br>
		<font color="red"><formerror id="noon"></formerror></font>
	  </td>
        </tr>
        <tr>
          <td colspan="3">
	    <formwidget id="afternoon"><br>
		<font color="red"><formerror id="afternoon"></formerror></font>
	  </td>
	</tr>
	<tr>
	  <td>
	  <input type="checkbox" name="privacy" value="1" /><a href="http://www.professionefinanza.com/registrati.php" target="_blank">Accetto termini privacy e condizioni</a> (obbligatorio)	
	    <font color="red"><formerror id="privacy"><br>&Egrave; necessario accettare i termini e le condizioni.</formerror></font>
<br>	    	<small>Le informazioni raccolte attraverso la registrazione verranno usate per la registrazione all’evento e al sito, per il ricevimento della newsletter e delle informazioni sulle nostre iniziative.</small>	  
</td>
	</tr>
	<tr>
	  <td>
	    <center><br>
		<input class="btn btn-lg btn-primary" type="submit" name="formbutton:ok" value="Iscriviti!">
	    </center> 
	  </td>
	</tr>
      </formtemplate></center>
      <br></br>
      <!-- <table cellspacing="10" cellpadding="10" class="tbl">
	<tbody>
	  <tr class="blue">
	    <td>
	      <img class="center-block" height="auto" width="120px" src="http://images.professionefinanza.com/pfexpo/logos/roma-2015.png">
	    </td>
	    <td>
	      Sala 1<br>Loyola
	    </td>
	    <td>
	      Sala 2<br>Foscolo
	    </td>
	    <td>
	      Sala 3<br>Carducci
	    </td>
	    <td>
	      Sala 4<br>Alighieri
	    </td>
	    <td>
	      Sala 5<br>Leopardi
	    </td>
	  </tr>
	  <tr>
	    <td class="blue">
	      09.30 - 10.00
	    </td>
	    <td colspan="7" class="blue">
	      <img height="16px" width="auto" src="/timetable/registrazione.png">
		REGISTRAZIONE
	    </td>
	    </tr>
	    <tr>
	      <td class="blue">
		10.00 - 12.00
	      </td>
	      <td bgcolor="#F7AD5A" rowspan="2">
		<a href="/programma/tassi-su-tassi-giu">
		  Tassi su, tassi giù: le politiche monetarie<br>
		    <img height="18px" width="auto" src="/timetable/portafoglio.png" align="right">
		</a>
	      </td>
	      <td bgcolor="#2C4B80" rowspan="2">
		<a href="/programma/frontiere-consulenza-mifid">
		  La consulenza finanziaria con la MiFID II<br>
		    <img height="18px" width="auto" src="/timetable/conferenza.png" align="right">
		</a>
	      </td>
	      <td bgcolor="#F7AD5A" rowspan="2">
		<a href="/programma/mercato-immobiliare">
		  Scenari del mercato immobiliare<br><small>ULTIMI 10 POSTI</small>
		    <img height="18px" width="auto" src="/timetable/portafoglio.png" align="right">
		</a>
	      </td>
	      <td bgcolor="#47AE4B">
		<a href="/programma/pnl-linguaggio-non-verbale">
			<img height="18px" width="auto" src="timetable/pagamento.png" align="right"><br>
		      PNL e morfopsicologia del cliente<br><small><font color="red">SOLD OUT</font></small>
			<img height="18px" width="auto" src="/timetable/relazione.png" align="right">
		</a>
	      </td>
	      <td bgcolor="#47AE4B">
		<a href="/programma/consulente-coach">
		  <img height="18px" width="auto" src="timetable/pagamento.png" align="right"><br>
		      Il consulente coach: ascolto e guida del cliente<br>
			<img height="18px" width="auto" src="/timetable/relazione.png" align="right">
		</a>
	      </td>
	    </tr>
	    <tr>
	      <td class="blue">
		12.00 - 13.30
	      </td>
	      <td bgcolor="#F7AD5A">
		<a href="/programma/nav-promotore">
		  Il NAV del promotore<br><small><font color="red">SOLD OUT</font></small>
		    <img height="18px" width="auto" src="/timetable/portafoglio.png" align="right">
		</a>
	      </td>
	      <td bgcolor="#9A7F9D">
		<a href="/programma/gestire-stress-alimentazione">
		  <img height="18px" width="auto" src="timetable/pagamento.png" align="right"><br>
		      Cibo per la mente<br><small>Gestire lo stress con l'alimentazione</small><br><small><font color="red">SOLD OUT</font></small>
			  <img height="18px" width="auto" src="/timetable/imprenditori.png" align="right">
		</a>
	      </td>
	    </tr>
	    <tr>
	      <td class="blue">
		13.30 - 14.30
	      </td>
	      <td colspan="7" class="blue">
		Light Lunch
		<img height="12px" width="auto" src="/timetable/lunch.png">
	      </td>
	    </tr>
	    <tr>
	      <td class="blue">
		14.30 - 16.30
	      </td>
	      <td bgcolor="#F7AD5A">
		<a href="/programma/scenari-macroeconomici">
	    Scenari macroeconomici<br>
		    <img height="18px" width="auto" src="/timetable/portafoglio.png" align="right">
		</a>
	      </td>
	      <td bgcolor="#9A7F9D">
		<a href="/programma/superare-convinzioni-limitanti">
		  Come proporre la consulenza a parcella<br>
	    <img height="18px" width="auto" src="/timetable/imprenditori.png" align="right">
		</a>
	</td>
	      <td bgcolor="#F7AD5A">
		<a href="/programma/liquidita-in-portafoglio">
		  Come inserire nuove liquidità in portafoglio<br>
		    <img height="18px" width="auto" src="/timetable/portafoglio.png" align="right">
		</a>
	      </td>
	      <td bgcolor="#47AE4B">
		<a href="/programma/comunicazione-persuasiva">
		  <img height="18px" width="auto" src="timetable/pagamento.png" align="right"><br>
		      Comunicazione persuasiva e ipnosi conversazionale<br><small><font color="red">SOLD OUT</font></small>
			<img height="18px" width="auto" src="/timetable/relazione.png" align="right">
		</a>
	      </td>
	      <td bgcolor="#47AE4B">
		<a href="/programma/enneagramma-personalita-cliente">
		  <img height="18px" width="auto" src="timetable/pagamento.png" align="right"><br>
		      I 9 tipi di personalità del cliente<br>
			<img height="18px" width="auto" src="/timetable/relazione.png" align="right">
		</a>
	      </td>
	    </tr>
	    <tr>
	      <td class="blue">
		16.30 - 17.00
	      </td>
	      <td colspan="7" class="blue">
		<img width="auto" height="12px" src="/timetable/coffee.png">
		  Coffee break
	      </td>
	    </tr>
	    <tr>
	      <td class="blue">
		17.00 - 18.30
	      </td>
	      <td bgcolor="#F7AD5A">
		<a href="/programma/futuro-asset-allocation-pwc">
		  Robo-Advisor VS Human-Advisory<br>
		    <img height="18px" width="auto" src="/timetable/portafoglio.png" align="right">
		</a>
	      </td>
	      <td bgcolor="#4B4400">
		<a href="/programma/tavola-rotonda-tutela-patrimonio">
		  From black to white list: le frontiere del patrimonio<br><small><font color="red">SOLD OUT</font></small>
		    <img height="18px" width="auto" src="/timetable/tutela.png" align="right">
		</a></td>
	      <td bgcolor="#006DB7">
		<a href="/programma/business-coach-family-plan">
		  Business coach: come affrontare la continuità aziendale<br><small><font color="red">SOLD OUT</font></small>
		    <img height="18px" width="auto" src="/timetable/pianificazione.png" align="right">
		</a>
	      </td>
	      <td bgcolor="#9A7F9D">
		<a href="/programma/personal-branding">
		  <img height="18px" width="auto" src="timetable/pagamento.png" align="right"><br>
		      Personal Branding<br>
			<img height="18px" width="auto" src="/timetable/imprenditori.png" align="right">
		</a>
	      </td>
	      
	      <td bgcolor="#6EC6D6">
		<a href="/programma/consulenza-previdenziale">
		  <img height="18px" width="auto" src="timetable/pagamento.png" align="right"><br>
		      Le novità in tema di previdenza complementare<br>
			<img height="18px" width="auto" src="/timetable/previdenza.png" align="right">
		</a>
	      </td>
	    </tr>
	  </tbody></table>--> </br>
      <img width="100%" src="http://images.professionefinanza.com/pfexpo/programma-pd15.jpg">
	<div class="alert alert-info" role="alert">Se ti sei gi&agrave; iscritto all'evento, per modificare i corsi scelti reinserisci la mail utilizzata in fase di iscrizione e procedi alla modifica.<br>L'ultima scelta effettuata sarà quella definitiva.</div>
	<small>La partecipazione è gratuita e riservata esclusivamente ai Promotori Finanziari, Private Bankers e/o comunque solo a coloro che in qualità di dipendente, agente o mandatario, esercitano professionalmente l'offerta fuori sede o nella sede legale di strumenti finanziari e di servizi di investimento in rappresentanza di un intermediario abilitato, cioè di una banca, di una Società di intermediazione mobiliare (SIM) o di una Società di Gestione del Risparmio (SGR); oltrechè ai Consulenti Finanziari Indipendenti che esercitino nei confronti dei propri clienti attività di consulenza su strumenti finanziari e servizi d'investimento.</small>
    </div>	  