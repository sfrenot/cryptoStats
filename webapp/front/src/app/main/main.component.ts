import { Component, AfterViewInit, ViewChild } from '@angular/core';
import { NgTerminal } from 'ng-terminal';
import {HttpClient, HttpHeaders, HttpParams} from '@angular/common/http';
import { DisplayOption } from 'ng-terminal';


@Component({
  selector: 'app-main',
  templateUrl: './main.component.html',
  styleUrls: ['./main.component.scss']
})
export class MainComponent implements AfterViewInit{

  @ViewChild('termA', { static: true }) child! : NgTerminal;
  @ViewChild('termB', { static: true }) childBis! : NgTerminal;
  retourScript = 'null';
  lesScripts =[''];
  currentScript = 'null';
  saved = false;
  displayOption: DisplayOption = {};
  style = {
    "padding-left" : "5px"
  }

  // appel api liste scripts
  constructor(private http : HttpClient){
    this.http.get('http://localhost:3000/api/ls').toPromise<any>().then(data => {
      this.lesScripts = data.message.split('\n');
      this.lesScripts.length --;
    });
  }

  selectScript(script : string){
    this.child.underlying.reset();
    this.currentScript = script;
    this.child.write('$ ' + script);
  }


  lanceScript(){
    if (this.currentScript == 'null'){
      window.alert('Veuillez sélectionner un script à lancer');
    }
    else{
      this.http.get('http://localhost:3000/api/lancescript?script=' + this.currentScript).toPromise<any>().then(data => {
        this.retourScript = JSON.parse(JSON.stringify(data.message).replace(/\\n/g,"\\r\\n"));
        this.child.write('\r\n' + this.retourScript + '\r\n$ ');
        var icon = document.getElementById(this.currentScript);
        icon?.setAttribute("style", "color: #989034")
        this.currentScript = 'null';
      });
    }
    
  }

  scrollTop(){
    this.child.underlying.scrollToTop();
  }

  scrollBottom(){
    this.child.underlying.scrollToBottom();
  }

  scrollTopBis(){
    this.childBis.underlying.scrollToTop();
  }

  scrollBottomBis(){
    this.childBis.underlying.scrollToBottom();
  }

  editScript(){
    if (this.currentScript == 'null'){
      window.alert('Veuillez sélectionner un script à éditer');
    }
    else{
      this.childBis.underlying.reset();
      var terminalA = document.getElementById("terminalA");
      var termA = document.getElementById("termA");
      var terminalB = document.getElementById("terminalB");
      var termB = document.getElementById("termB");

      terminalA?.setAttribute("style", "visibility: hidden");
      termA?.setAttribute("style", "visibility: hidden");
      terminalB?.setAttribute("style", "visibility: visible");
      termB?.setAttribute("style", "visibility: visible");
      this.http.get('http://localhost:3000/api/affichescript?script=' + this.currentScript).toPromise<any>().then(data => {
        this.retourScript = JSON.parse(JSON.stringify(data.message).replace(/\\n/g,"\\r\\n"));
        this.childBis.write(this.retourScript);
      });
      
    }
  }


  quit(){
    this.child.underlying.reset();
    this.child.write('$ ');
    var terminalA = document.getElementById("terminalA");
    var termA = document.getElementById("termA");
    var terminalB = document.getElementById("terminalB");
    var termB = document.getElementById("termB");

    if (this.saved == true){
      terminalA?.setAttribute("style", "visibility: visible");
      termA?.setAttribute("style", "visibility: visible");
      terminalB?.setAttribute("style", "visibility: hidden");
      termB?.setAttribute("style", "visibility: hidden");
    }
    else {
      var answer = window.confirm("Quitter sans sauver ?");
      if (answer) {
        terminalA?.setAttribute("style", "visibility: visible");
        termA?.setAttribute("style", "visibility: visible");
        terminalB?.setAttribute("style", "visibility: hidden");
        termB?.setAttribute("style", "visibility: hidden");
        this.saved = false;
      }
    }
  }

  save(){
    var tailleBuffer = this.childBis.underlying.buffer.active.length;
    var modifiedScript = "";

    if (tailleBuffer > 33){
      for (let i=0; i<this.childBis.underlying.buffer.active.length; i++){
        modifiedScript += this.childBis.underlying.buffer.active.getLine(i)?.translateToString(false) + "\n";
       }
    }
    else{
      for (let i=0; i<this.childBis.underlying.buffer.active.length; i++){
        modifiedScript += this.childBis.underlying.buffer.active.getLine(i)?.translateToString(false) + "\n";
       }
       modifiedScript = modifiedScript.replace(/^\s*\n/gm, "");
    }

    this.saved = true;
    var params = new HttpParams()
    .set('fichier', this.currentScript)
    .set('code', modifiedScript);
    var myheaders = new HttpHeaders({'Content-Type' : 'application/x-www-form-urlencoded'});
    this.http.post('http://localhost:3000/api/savescript', params, {headers:myheaders}).subscribe(data => {});
    window.alert("Script enregistré")
  }

  ngAfterViewInit(){
    this.child.underlying.setOption("fontSize" , "14");
    this.child.underlying.setOption('scrollback', 1000000);
    this.child.setStyle(this.style);
    this.child.write('$ ');

    this.childBis.underlying.setOption("fontSize" , "14");
    this.childBis.underlying.setOption('scrollback', 1000000);
    this.childBis.underlying.setOption('cursorStyle', 'bar');
    this.childBis.setStyle(this.style);
    

    // ecoute clavier
    this.childBis.keyEventInput.subscribe(e => {
      if (e.domEvent.keyCode === 13) {
        //enter
        this.currentScript = '';
        this.childBis.write('\r\n');
      } 
      else if (!e.domEvent.altKey && !e.domEvent.ctrlKey && !e.domEvent.metaKey) {
        this.childBis.write(e.key);
      } 
      else if (e.domEvent.keyCode === 8) {
        // backspace
        this.childBis.write('\b \b');
      }
    });

  }

}