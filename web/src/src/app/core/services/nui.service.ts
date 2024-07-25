import { Injectable, isDevMode } from '@angular/core';
import { fromEvent, Observable, Subject } from "rxjs";

interface NuiMessage<T = any> {
  action: string;
  data: T;
}

@Injectable({
  providedIn: 'root'
})
export class NuiService {
  private resourceName: string = (window as any).GetParentResourceName
    ? (window as any).GetParentResourceName()
    : "fractal-nui-app";

  private messageObservable: Observable<MessageEvent>;
  private actionObservables: Record<string, Subject<any>> = {};
  private lastMessages: Record<string, any> = {};

  constructor() {
    this.messageObservable = fromEvent<MessageEvent<NuiMessage>>(window, "message");
    this.messageObservable.subscribe({
      next: (event: MessageEvent<NuiMessage>) => {
        this.lastMessages[event.data.action] = event.data;
        this.actionObservables[event.data.action]?.next(event.data.data);
      },
      error: err => console.error('Error handling message event:', err)
    });
  }

  public isEnvBrowser(): boolean {
    return !(window as any).invokeNative;
  }

  async fetchNui<T = any>(eventName: string, data?: any, mockData?: T): Promise<T> {
    if (this.isEnvBrowser() && mockData) {
      return Promise.resolve(mockData);
    }
    try {
      const options = {
        method: "post",
        headers: { "Content-Type": "application/json; charset=UTF-8" },
        body: JSON.stringify(data)
      };
      const response = await fetch(`https://${this.resourceName}/${eventName}`, options);
      return response.json();
    } catch (error) {
      console.error('Failed to fetch Nui:', error);
      throw error;
    }
  }

  public fromMessageAction<T = any>(action: string): Subject<T> {
    return this.actionObservables[action] ||= new Subject<T>();
  }

  public getLastMessageData<T = any>(action: string): T | false {
    return this.lastMessages[action] ?? false;
  }

  public dispatchBackEvents<P>(events: NuiMessage<P>[], timeout = 1000): void {
    if (isDevMode() && this.isEnvBrowser()) {
      events.forEach(event => {
        setTimeout(() => window.dispatchEvent(new MessageEvent("message", { data: event })), timeout);
      });
    }
  }
}
