/**
 *   MenuItem
 *     Used to create an atom object for the menu
 *      and contain the code to load the items from a JSON file
 *
 *   Menu's can be stored in the Menus folder, and must be in json format.
 *   Each file must contain a name, color, image_position and name_position property.
 *
 *   Alex Broadbent | 10/09/2013
**/

class MenuItem
{
    String name;
    color col;
    PVector imagePosition;
    PVector namePosition;

    public MenuItem(String _name, color _color, PVector image_position, PVector name_position)
    {
        name = _name;
        col = _color;
        imagePosition = image_position;
        namePosition = name_position;
    }

    //Constructor for 
    public MenuItem(String _name, String _color, String image_position, String name_position)
    {
        name = _name;

        int[] split = int(split(_color, ", "));
        col = color(split[0], split[1], split[2]);

        float[] pos = float(split(image_position, ","));
        imagePosition = new PVector(pos[0], pos[1]);
        
        pos = float(split(name_position, ","));
        namePosition = new PVector(pos[0], pos[1]);
    }

    public String getName()
    {
        return name;
    }
    public void setName(String _name)
    {
        name = _name;
    }
    public color getColor()
    {
        return col;
    }
    public void setColor(color _color)
    {
        col = _color;
    }
    public PVector getImagePosition()
    {
        return imagePosition;
    }
    public void setImagePosition(PVector image_position)
    {
        imagePosition = image_position;
    }
    public PVector getNamePosition()
    {
        return namePosition;
    }
    public void setNamePosition(PVector name_position)
    {
        namePosition = name_position;
    }
}


public void loadMenu(String type)
{
    if (type.equals("Standard"))
    {
        loadStandardMenu();
    }
    else if (type.equals("NAO"))
    {
        loadNAOMenu();
    }
    else if (type.equals("Arduino"))
    {
        loadArduinoMenu();
    }
}

public void loadStandardMenu()
{
    menuItems.clear();
    JSONObject menu = loadJSONObject(sketchPath("Menus\\standard.json"));            
    JSONArray items = menu.getJSONArray("menu");
        
    for (int i=0; i<items.size(); i++)
    {
        JSONObject item = items.getJSONObject(i).getJSONObject("item");
        
        MenuItem newItem = new MenuItem(item.getString("name"), item.getString("color"), item.getString("image_position"), item.getString("name_position"));
        menuItems.add(newItem);
    }
}

public void loadNAOMenu()
{
    menuItems.clear();
    JSONObject menu = loadJSONObject(sketchPath("Menus\\nao.json"));            
    JSONArray items = menu.getJSONArray("menu");
        
    for (int i=0; i<items.size(); i++)
    {
        JSONObject item = items.getJSONObject(i).getJSONObject("item");
        
        MenuItem newItem = new MenuItem(item.getString("name"), item.getString("color"), item.getString("image_position"), item.getString("name_position"));
        menuItems.add(newItem);
    }
}

public void loadArduinoMenu()
{
    menuItems.clear();
    JSONObject menu = loadJSONObject(sketchPath("Menus\\arduino.json"));            
    JSONArray items = menu.getJSONArray("menu");
        
    for (int i=0; i<items.size(); i++)
    {
        JSONObject item = items.getJSONObject(i).getJSONObject("item");
        
        MenuItem newItem = new MenuItem(item.getString("name"), item.getString("color"), item.getString("image_position"), item.getString("name_position"));
        menuItems.add(newItem);
    }
}
