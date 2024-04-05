import { Injectable } from '@angular/core';
import { Invoice, InvoiceItem } from '../interfaces/invoice';

@Injectable({
  providedIn: 'root'
})
export class InvoiceService {
  private invoice: Invoice = { items: [], total: 0, id: 0 };

  /***
   * Get fully built invoice object
   * @returns Invoice
   */
  getInvoice(): Invoice {
    return this.invoice;
  }

  /***
   * Check if an item exists in the invoice
   * @param itemId
   * @returns boolean
   */
  hasItem(itemId: string): boolean {
    return this.invoice.items.some(i => i.id === itemId);
  }

  /***
   * Update an item in the invoice
   * @param item
   * @returns void
   */
  updateInvoiceItem(item: InvoiceItem): void {
    const index = this.invoice.items.findIndex(i => i.id === item.id);
    if (index !== -1) {
      this.invoice.items[index] = item;
      this.calculateTotal();
    }
  }

  /***
   * Add an item to the invoice
   * @param item
   * @returns void
   */
  addInvoiceItem(item: InvoiceItem): void {
    this.invoice.items.push(item);
    this.calculateTotal();
  }

  /***
   * Remove an item from the invoice
   * @param itemId
   * @returns void
   */
  removeInvoiceItem(itemId: string): void {
    this.invoice.items = this.invoice.items.filter(i => i.id !== itemId);
    this.calculateTotal();
  }

  /***
   * Calculate the total of the invoice
   * @returns void
   * @private
   */
  private calculateTotal(): void {
    this.invoice.total = this.invoice.items.reduce((sum, item) => sum + item.total, 0);
  }

  /***
   * Clear the invoice
   * @returns void
   */
  clearInvoice(): void {
    this.invoice = { items: [], total: 0, id: 0 };
  }
}
