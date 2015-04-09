module InventoriesHelper
  def style_stock(stock)
    if stock.to_f < 0
      "<span class='text-danger'>#{format("%.2f", (stock.to_f).abs)}</span>".html_safe
    elsif stock.to_f > 0
      "<span class='text-success'>#{format("%.2f", stock)}</span>".html_safe
    else
      "<span class='text-muted'>#{format("%.2f", stock)}</span>".html_safe
    end
  end
end
