import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs';
import { Invoice, InvoiceItem } from '../interfaces/invoice';

@Injectable({
  providedIn: 'root'
})
export class InvoiceService {
  private invoiceSubject = new BehaviorSubject<Invoice>({ items: [], total: 0, id: 0 });
  invoice$ = this.invoiceSubject.asObservable();

  /***
   * Get fully built invoice object
   * @returns Observable<Invoice>
   */
  getInvoice(): Observable<Invoice> {
    return this.invoice$;
  }

  /***
   * Check if an item exists in the invoice
   * @param itemId - the item ID to check
   * @returns boolean indicating if the item exists
   */
  hasItem(itemId: string): boolean {
    const invoice = this.invoiceSubject.value;
    return invoice.items.some(i => i.id === itemId);
  }

  /***
   * Update an item in the invoice
   * @param item - the item to update
   * @returns void
   */
  updateInvoiceItem(item: InvoiceItem): void {
    const invoice = this.invoiceSubject.value;
    const index = invoice.items.findIndex(i => i.id === item.id);
    if (index !== -1) {
      const updatedItems = [...invoice.items];
      updatedItems[index] = item;
      this.invoiceSubject.next({...invoice, items: updatedItems});
      this.calculateTotal();
    }
  }

  /***
   * Add an item to the invoice
   * @param item - the item to add
   * @returns void
   */
  addInvoiceItem(item: InvoiceItem): void {
    const invoice = this.invoiceSubject.value;
    const updatedItems = [...invoice.items, item];
    this.invoiceSubject.next({...invoice, items: updatedItems});
    this.calculateTotal();
  }

  /***
   * Remove an item from the invoice
   * @param itemId - the ID of the item to remove
   * @returns void
   */
  removeInvoiceItem(itemId: string): void {
    const invoice = this.invoiceSubject.value;
    const updatedItems = invoice.items.filter(i => i.id !== itemId);
    this.invoiceSubject.next({...invoice, items: updatedItems});
    this.calculateTotal();
  }

  /***
   * Calculate the total of the invoice
   * @returns void
   * @private
   */
  private calculateTotal(): void {
    const invoice = this.invoiceSubject.value;
    const total = invoice.items.reduce((sum, item) => sum + item.total, 0);
    this.invoiceSubject.next({...invoice, total});
  }

  /***
   * Clear the invoice
   * @returns void
   */
  clearInvoice(): void {
    this.invoiceSubject.next({ items: [], total: 0, id: 0 });
  }
}
