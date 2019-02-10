# TOTALS
totals = []

# Subtotal
totals << [pdf.make_cell(content: I18n.t('spree.subtotal')), invoice.display_item_total.to_s]

# Tax
totals << [pdf.make_cell(content: I18n.t('spree.tax')), invoice.display_tax_total.to_s]

# Adjustments
invoice.adjustments.each do |adjustment|
  totals << [pdf.make_cell(content: adjustment.label), adjustment.display_amount.to_s]
end

# Shipments
invoice.shipments.each do |shipment|
  totals << [pdf.make_cell(content: shipment.shipping_method.name), shipment.display_cost.to_s]
end

# Totals
totals << [pdf.make_cell(content: I18n.t('spree.order_total')), invoice.display_total.to_s]

# Payments
total_payments = 0.0
invoice.payments.completed.each do |payment|
  totals << [
    pdf.make_cell(
      content: I18n.t('spree.payment_via',
      gateway: (payment.source_type || I18n.t('spree.unprocessed', scope: :print_invoice)),
      number: payment.number,
      date: I18n.l(payment.updated_at.to_date, format: :long),
      scope: :print_invoice)
    ),
    payment.display_amount.to_s
  ]
  total_payments += payment.amount
end

totals_table_width = [0.875, 0.125].map { |w| w * pdf.bounds.width }
pdf.table(totals, column_widths: totals_table_width) do
  row(0..6).style align: :right
  column(0).style borders: [], font_style: :bold
end