import { Component, Injectable } from '@angular/core';
import {HttpClient} from '@angular/common/http';

@Injectable()
@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})

export class AppComponent {

  shell = "";

  constructor(private http : HttpClient){
    this.http.get('http://localhost:3000').toPromise<any>().then(data => {
      // this.shell = JSON.stringify(data);
      // var myObj = JSON.parse(this.shell);
      // this.shell = myObj['message'];
      this.shell = data.message;
    });
  }
}
