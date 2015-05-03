/**
 *   Game Atom Class
 *       Extends Atom Class
 *
 *   Alex Broadbent | 10/08/2013
**/
 
class GameAtom extends Atom
{
    private ArrayList<String> states;
    
    //Constructors
    public GameAtom()
    {
        super("Game", green);
        states = new ArrayList<String>();
    }
    
    public GameAtom(ArrayList<String> stateIn)
    {
        super("Game", green);
        states = stateIn;
    }
    
    public GameAtom(String id, String type, float actTime)
    {
        super(id, type, actTime, green);
        states = new ArrayList<String>();
    }
    
    public GameAtom(String id, String type, float actTime, ArrayList<String> _states)
    {
        super(id, type, actTime, green);
        states = _states;
    }
    
    
    //Getters and Setters
    public ArrayList<String> getStates()
    {
        return states;
    }    
    
    public void setStates(ArrayList<String> stateIn)
    {
        states = stateIn;
    }
    
    
    //Methods    
    public void addState(String sta)
    {
        //Check for duplicate
        boolean duplicate = false;
        
        for (int i=0; i<states.size(); i++)
        {
            if (states.get(i).equals(sta))
            {
                duplicate = true;
            }
        }
        
        if (!duplicate) {states.add(sta);}
    }
    
    public void removeState(String sta)
    {
        states.remove(sta);
    }
    
    public String[] getPrintableStates()
    {
        String[] output = new String[10];
        int counter = 0;
        if (states.size() > 0)
        {
            for (String state : states)
            {
                if (state != null)
                {
                    output[counter] = state;
                    counter++;
                }
            }
        }
        else
        {
            output[counter] = "None";
        }
        return output;
    }
    
    public String printState()
    {
        String output = "";
        if (states.size() > 0)
        {
            output = "| States: ";
            for (String str : states)
            {
                output += str + " | ";
            }
            output += "\n";
        }
        
        return output;
    }
    
    public int numParameters()
    {
        return states.size();
    }
    
    public String printAtom()
    {
        String output = super.printAtom();
        output += printState();
        return output;
    }
    
    public JSONObject toJSON()
    {
        JSONObject json = super.toJSON();
        if (!states.isEmpty())
        {
            JSONArray values = new JSONArray(); int i=0;
            for (String state : states)
            {
                JSONObject jsonState = new JSONObject();
                jsonState.setString("state", state);
                values.setJSONObject(i, jsonState); i++;
            }
            json.setJSONArray("states", values);
        }
        return json;
    }
}
