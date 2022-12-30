--- loosely based on https://renderorder66.com/2020/03/23/AsepritePlugin.html

function generateColorList(data)
    local colorList = {}
    
    local diff = 1/data.shades;
    if (data.step) then
        diff = data.step
    end

    local lightValue = data.color.lightness
    for i = 1, data.shades + 1 do
        local color = Color{h=data.color.hslHue, s=data.color.hslSaturation, l=lightValue}        
        table.insert(colorList, color)
        if (data.lighten) then
            lightValue = lightValue + diff
        else
            lightValue = lightValue - diff
        end
    end

    return colorList
end

--- add colorList to existing palette
function addToPalette(pal, colorList)
    local j = #pal

    pal:resize(#pal+#colorList) --- it will start with black
    
    for i = 1, #colorList - 1 do        
        j = j + 1
        pal:setColor(j, colorList[i])        
    end
end

do
    local spr = app.activeSprite
    if not spr then
        return app.alert("There is no active sprite")
    end
    
    local data = Dialog():color{ id="color", label="Pick base color", color=Color{r=0,g=0,b=0,a=255} }
    :slider{ id="shades", label="Shades number", min=1, max=20, value=10 }    
    :check{id="lighten", label="Lighten if checked / darken if unchecked", selected=true}    
    :number{id="step", label="Step(optional) if empty it's calculated as 1/shades", decimals=3}
    :button{ id="ok", text="OK" }
    :button{ id="cancel", text="Cancel" }
    :show().data;

    if data.ok then                
        local colorList = generateColorList(data)
        local pal = spr.palettes[1] --- get current palette
        
        addToPalette(pal, colorList);
        
        -- modify current palette
        spr:setPalette(pal);
    end
end