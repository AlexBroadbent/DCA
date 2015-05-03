/**
 *   Transform Atom
 *     Extends Atom Class.
 *
 *   Alex Broadbent | 10/08/2013
**/
 
class TransformAtom extends Atom
{
    private ArrayList<String> parameters;
    
    //Constructors
    public TransformAtom()
    {
        super("Transform", blue);
        parameters = new ArrayList<String>();
    }
    
    public TransformAtom(ArrayList<String> parametersIn)
    {
        super("Transform", blue);
        parameters = parametersIn;
    }

    public TransformAtom(String id, String type, float actTime)
    {
        super(id, type, actTime, blue);
        parameters = new ArrayList<String>();
    }
    
    public TransformAtom(String id, String type, float actTime, ArrayList<String> _params)
    {
        super(id, type, actTime, blue);
        parameters = _params;
    }
    
    
    //Getters and Setters
    public ArrayList<String> getParameters()
    {
        return parameters;
    }
    
    public void setParameters(ArrayList<String> params)
    {
        parameters = params;
    }
    
    
    //Methods
    public int numParameters()
    {
        return parameters.size();
    }
    
    public void clearParameters()
    {
        parameters.clear();
    }
    
    public void addParameter(String param)
    {
        //Check for duplicate
        boolean duplicate = false;
        
        for (int i=0; i<parameters.size(); i++)
        {
            if (parameters.get(i).equals(param))
            {
                duplicate = true;
            }
        }
        
        if (!duplicate) {parameters.add(param);}
    }
    
    public void removeParameter(String param)
    {
        parameters.remove(param);
    }
    
    public String printParameters()
    {
        ArrayList<String> params = getParameters();
        String output = "";
        if (params.size() > 0)
        {
            output = "| Parameters: ";
            for (String par : params)
            {
                output += par + " | ";
            }
            output += "\n";
        }
        
        return output;
    }
    
    public String printAtom()
    {
        String output = super.printAtom();
        output += printParameters();
        
        return output;
    }
    
    public JSONObject toJSON()
    {
        JSONObject json = super.toJSON();
        if (!parameters.isEmpty())
        {
            JSONArray values = new JSONArray(); int i=0;
            for (String param : parameters)
            {
                JSONObject jsonParam = new JSONObject();
                jsonParam.setString("parameter", param);
                values.setJSONObject(i, jsonParam); i++;
            }
            json.setJSONArray("states", values);
        }
        return json;
    }
}
