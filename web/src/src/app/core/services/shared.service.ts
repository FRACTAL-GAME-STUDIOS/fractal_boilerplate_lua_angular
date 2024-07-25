import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root',
})
export class SharedService {
  private dataStore: { [key: string]: any } = {};

  constructor() {}

  /***
   * Set a value in the data store
   * @param key
   * @param value
   * @returns void
   */
  set(key: string, value: any) {
    this.dataStore[key] = value;
  }

  /***
   * Get a value from the data store, previously set with the set method
   * @param key
   * @returns any
   */
  get(key: string): any {
    return this.dataStore[key];
  }
}
