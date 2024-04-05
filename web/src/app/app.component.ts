import {  Component, HostListener, OnInit } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { NuiService } from './core/services/nui.service';
import { ExampleContainerComponent } from "./example-container/example-container.component";

@Component({
    selector: 'app-root',
    standalone: true,
    templateUrl: './app.component.html',
    styleUrl: './app.component.scss',
    imports: [RouterOutlet, ExampleContainerComponent]
})
export class AppComponent {
  visible: boolean = false;

	constructor(private nui: NuiService) {}

	ngOnInit(): void {
		// This listens for the "setVisible" message
		this.nui.fromMessageAction<boolean>("setVisible").subscribe({
			next: (value) => {
				this.visible = value;
			}
		});

		// This will set the NUI to visible if we are developing in browser
		this.nui.dispatchBackEvents([
			{
				action: "setVisible",
				data: true
			}
		]);
	}

	@HostListener("window:keydown", ["$event"])
	handleKeyboardEvent(event: KeyboardEvent) {
		if (["Escape"].includes(event.code)) {
			if (!this.nui.isEnvBrowser()) this.nui.fetchNui("hideFrame");
			this.visible = false;
		}
	}
}
