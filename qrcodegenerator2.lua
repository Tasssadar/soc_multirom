qrencode = dofile("qrencode.lua")    --  <--- Ooooh! You cheater!

local function matrix_to_tikz( tab , size)
  if (size == nil) then size=10 end
  pixel_width = size / #tab
  pixel_cmd = string.format("\\filldraw[%%s] (%%f, %%f) +(-%f, %f) rectangle +(%f, -%f);",
          pixel_width/2, pixel_width/2, pixel_width/2, pixel_width/2)
  str_tab = {}
  for y=1,#tab do
    row = {}
    for x=1,#tab do
      if tab[x][y] > 0 then
          style = "pixel on"
      elseif tab[x][y] < 0 then
          style = "pixel off"
      else
          style = "pixel err"
      end
      if style=="pixel off" then
          row[x] = ""
      else
          row[x] = string.format(pixel_cmd, style, x*pixel_width, -y*pixel_width)
      end
    end
    str_tab[y] = table.concat(row, "\n")
  end
  local extra = {}
  extra[1] = string.format("\\coordinate (aux1) at (%f,-%f);", pixel_width/2, size+pixel_width/2)
  extra[2] = string.format("\\coordinate (aux2) at (%f, %f);", size+pixel_width/2, -pixel_width/2)
  extra[3] = "\\node[inner sep=0pt, fit=(aux1) (aux2)] (qrcode) {};"
  str_tab[#tab+1] =  table.concat(extra, "\n")
  return table.concat(str_tab,"\n")
end

function tikzQRCode(txt, size)
    local ok, tab_or_message = qrencode.qrcode(txt)
    if not ok then
        tex.print(tab_or_message)
    else
        tex.print(matrix_to_tikz(tab_or_message, size))
    end
end