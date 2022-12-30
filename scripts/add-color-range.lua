--- loosly based on https://renderorder66.com/2020/03/23/AsepritePlugin.html

function generateColorList(baseColor, shades)
    local colorList = {}
    
    local diff = 1/(shades + 2); --- add 2 so we don't start from 0(white) and end on 1 black
    
    local startLight = 1-diff
    local endLight = 0+diff
    
    for light=startLight,endLight,-diff do
        local color = Color{h=baseColor.hslHue, s=baseColor.hslSaturation, l=light}
        table.insert(colorList, color)
    end

    return colorList
end

--- add colorList to existing palette
function addToPalette(pal, colorList)
    local j = #pal

    pal:resize(#pal+#colorList) --- it will end with black color -1 if not
    
    for i = 1,#colorList-1 do        
        j = j + 1
        pal:setColor(j, colorList[i])        
    end
end

do
    local spr = app.activeSprite
    if not spr then
        return app.alert("There is no active sprite")
    end
    
    local color = Dialog():color{ id="color", label="Pick base color", color=Color{r=0,g=0,b=0,a=255} }
    :slider{ id="shades", label="Color range", min=1, max=20, value=5 }
    :button{ id="ok", text="OK" }
    :button{ id="cancel", text="Cancel" }
    :show().data;

    if color.ok then        
        local pal = spr.palettes[1] --- get current palette
        local colorList = generateColorList(color.color, color.shades)
        addToPalette(pal, colorList);
        spr:setPalette(pal);
    end
end