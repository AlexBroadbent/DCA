/**                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 /*
 *   Atom Class
 *     Contains all types of atom class.
 *
 *   Alex Broadbent | 10/08/2013
**/


class Atom
{
    private String id; 
    private String type;  
    private HashMap<String, Float> linkTo;    // Link from another node to this one, with the delay
    private HashMap<String, Float> linkFrom;  // Link to another node from this one, with the delay
    private float activeTime;
    boolean active;
    color _color;
    
    int linkLimit = 50;
  
    public Atom()
    {
        id = createID();
        type = "Base";
        linkTo = new HashMap<String, Float>(linkLimit);
        linkFrom = new HashMap<String, Float>(linkLimit);
        _color = brown;
        active = false;
        activeTime = 0;
    }
  
    public Atom(String typeIn)
    {
        id = createID();
        type = typeIn;
        activeTime = 0;
        linkTo = new HashMap<String, Float>(linkLimit);
        linkFrom = new HashMap<String, Float>(linkLimit);
        _color = brown;
        active = false;
    }
    
    public Atom(String typeIn, color _col)
    {
        id = createID();
        type = typeIn;
        linkTo = new HashMap<String, Float>(linkLimit);
        linkFrom = new HashMap<String, Float>(linkLimit);
        _color = _col;
        activeTime = 0;
        active = false;
    }
    
    public Atom(String typeIn, float actTime)
    {
        id = createID();
        type = typeIn;
        linkTo = new HashMap<String, Float>(linkLimit);
        linkFrom = new HashMap<String, Float>(linkLimit);
        activeTime = actTime;
        _color = brown;
        active = false;

    }
    
    //Special Constructor for JSON Import of Atoms
    public Atom(String _id, String _type, float actTime, color _col)
    {
        id = _id;
        type = _type;
        linkTo = new HashMap<String, Float>(linkLimit);
        linkFrom = new HashMap<String, Float>(linkLimit);
        activeTime = actTime;
        _color = _col;
        active = false;
    }
    
    public Atom(String typeIn, float actTime, HashMap<String, Float> linkT, 
                  HashMap<String, Float> linkF, color _col)
    {
        id = createID();
        type = typeIn;
        linkTo = linkT;
        linkFrom = linkF;
        activeTime = actTime;
        _color = _col;
        active = false;
    }
  
  
    //Setters and Getters
    public String getID()
    {
        return id;
    }
  
    public String getType()
    {
        return type;
    }
    
    public float getActiveTime()
    {
        return activeTime; 
    }
    
    public void setActiveTime(float actTime)
    {
        activeTime = actTime;
    }
    
    
    //Methods
    public String createID()
    {
        char c1 = ((random(0, 1) > 0.5) ? (char)int(random(97, 122)) : (char)int(random(65, 90)));
        char c2 = ((random(0, 1) > 0.5) ? (char)int(random(97, 122)) : (char)int(random(65, 90)));
        return "a-" + (int)random(1, 5000) + "-" + c1 + c2;
    }
    
    public void addLinkTo(String atomID, Float delay)
    {
        linkTo.put(atomID, delay);
    }
  
    public void addLinkFrom(String atomID, Float delay)
    {
        linkFrom.put(atomID, delay);
    }    
    
    public Float getDelayLinkTo(String atomID)
    {
        return linkTo.get(atomID);
    }
  
    public Float getDelayLinkFrom(String atomID)
    {
        return linkFrom.get(atomID);
    }
    
    public void setAtomDelayLinkTo(String atomID, Float delay)
    {
        linkTo.put(atomID, delay);
    }
    
    public void setAtomDelayLinkFrom(String atomID, Float delay)
    {
        linkFrom.put(atomID, delay);
    }
  
  
    //Remove atomID from both linkTo and linkFrom maps.
    public void removeLink(String atomID)
    {
        if (linkTo.containsKey(atomID)) {
            linkTo.remove(atomID);
        }
        if (linkFrom.containsKey(atomID)) {
            linkFrom.remove(atomID);
        }
    }
  
    public HashMap<String, Float> getLinksTo()
    {
        return linkTo;
    }
    
    public HashMap<String, Float> getLinksFrom()
    {
        return linkFrom;
    }
  
    public void removeAllLinks()
    {
        linkTo.clear();
        linkFrom.clear();
    }
    
    
    //Additional Methods
    public int numParameters()
    {
        return 0;
    }
    
    public String printAtom()
    {
        String output = "\nID: " + id + "\n" + "Type: " + type + "\n";
        if (linkTo.size() != 0) 
        {
            String atomID = "";
            output += "Links To: ";
            for (int i = 0; i<linkTo.size(); i++)
            {
                atomID = linkTo.keySet().toArray()[i].toString();
                output += atomID;
                
                if (i<linkTo.size()-1)
                {
                    output += ", ";
                }
            }
            output += "\n";
        }
        if (linkFrom.size() != 0) 
        {
            String atomID = "";
            output += "| Links From: ";
            for (int i = 0; i<linkFrom.size(); i++)
            {
                atomID = linkFrom.keySet().toArray()[i].toString();
                output += atomID;
                
                if (i<linkFrom.size()-1)
                {
                    output += ", ";
                }
            }
            output += "\n";
        }    
        return output;
    }
    
    public JSONObject toJSON()
    {
        JSONObject json = new JSONObject();
        
        json.setString("id", getID());
        json.setString("type", getType());
        json.setFloat("activeTime", getActiveTime());
        
        if (!linkTo.isEmpty())
        {
            String atomID = "";
            Float delay = 0.0;
            JSONArray jsonLinkTo = new JSONArray();
            
            for (int i=0; i<linkTo.size(); i++)
            {
                JSONObject link = new JSONObject();
                atomID = linkTo.keySet().toArray()[i].toString();
                delay = linkTo.get(atomID);
                link.setString("atomID", atomID);
                link.setFloat("delay", delay);                
                jsonLinkTo.setJSONObject(i, link);
            }
            
            json.setJSONArray("linkTo", jsonLinkTo);
        }
        
        if (!linkFrom.isEmpty())
        {
            String atomID = "";
            Float delay = 0.0;
            JSONArray jsonLinkFrom = new JSONArray();
            
            for (int i=0; i<linkFrom.size(); i++)
            {
                JSONObject link = new JSONObject();
                atomID = linkFrom.keySet().toArray()[i].toString();
                delay = linkFrom.get(atomID);
                link.setString("atomID", atomID);
                link.setFloat("delay", delay);
                jsonLinkFrom.setJSONObject(i, link);
            }
            
            json.setJSONArray("linkFrom", jsonLinkFrom);
        }
        
        return json;
    }
}
