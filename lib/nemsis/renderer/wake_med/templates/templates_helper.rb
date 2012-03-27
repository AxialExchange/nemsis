   def labeled_cell(label, value, value_colspan=0)
     text = "    <td class='label'>#{label}</td>
<td class='value' #{(value_colspan > 0) ? "colspan='#{value_colspan}'" : '' } >#{value}</td>"
     text
   end
