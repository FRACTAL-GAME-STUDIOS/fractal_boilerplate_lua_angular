export interface InvoiceItem {
  id: string;
  description: string;
  total: number;
  quantity?: number;
}

export interface Invoice {
  id: number;
  items: InvoiceItem[];
  total: number;
}
