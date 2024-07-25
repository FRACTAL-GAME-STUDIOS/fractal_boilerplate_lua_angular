import { Component } from '@angular/core';
import { NuiService } from '../core/services/nui.service';
import { CommonModule } from '@angular/common';

interface ReturnData {
    x: number;
    y: number;
    z: number;
}

@Component({
  selector: 'app-example',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './example.component.html',
  styleUrl: './example.component.scss'
})

export class ExampleComponent {
  clientData?: ReturnData;

  constructor(private nui: NuiService) {}

  handleGetClientData() {
    this.nui
        .fetchNui<ReturnData>("getClientData")
        .then((retData) => {
            console.log("Got return data from client scripts:");
            console.dir(retData);
            this.clientData = retData;
        })
        .catch((e) => {
            console.error("Setting mock data due to error", e);
            this.clientData = { x: 500, y: 300, z: 200 };
        });
  }
}
