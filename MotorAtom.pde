/**
 *   Motor Atom
 *     Extends Atom Class.
 *
 *   Alex Broadbent | 10/08/2013
**/

class MotorAtom extends Atom
{
    private ArrayList<String> motors;
    private ArrayList<String> parameters;    
  
    public MotorAtom()
    {
        super("Motor", red);
        motors = new ArrayList<String>();
        parameters = new ArrayList<String>();
    }
  
    public MotorAtom(ArrayList<String> motorsIn)
    {
        super("Motor", red);
        parameters = new ArrayList<String>();
        motors = motorsIn;
    }
    
    public MotorAtom(ArrayList<String> motorsIn, ArrayList<String> params)
    {
        super("Motor", red);
        parameters = params;
        motors = motorsIn;
    }
    
    //Base Parameters for loading JSON Network
    public MotorAtom(String id, String type, float actTime)
    {
        super(id, type, actTime, red);
        motors = new ArrayList<String>();
        parameters = new ArrayList<String>();
    }
    
    public MotorAtom(String id, String type, float actTime, ArrayList<String> _motors)
    {
        super(id, type, actTime, red);
        motors = _motors;
        parameters = new ArrayList<String>();
    }
    
    public MotorAtom(String id, String type, float actTime, ArrayList<String> _motors, ArrayList<String> _params)
    {
        super(id, type, actTime, red);
        motors = _motors;
        parameters = _params;
    }
  
  
    //Getters and Setters
    public ArrayList<String> getMotors()
    {
        return motors;
    }
  
    public void setMotors(ArrayList<String> motorsIn)
    {
        motors = motorsIn;
    }
  
    public ArrayList<String> getParameters()
    {
        return parameters;
    }
  
    public void setParameters(ArrayList<String> params)
    {
        parameters = params;
    }
  
  
    //Methods
    public void clearMotors()
    {
        motors.clear();
    }
    public void clearParameters()
    {
        parameters.clear();
    }
  
    public void addMotor(String motor)
    {
        //Check for duplicate
        boolean duplicate = false;     
        for (int i=0; i<motors.size(); i++)
        {
            if (motors.get(i).equals(motor))
            {
                duplicate = true;
            }
        }        
        if (!duplicate) {motors.add(motor);}
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
  
    public void removeMotor(String motor)
    {
        motors.remove(motor);
    }
  
    public void removeParameter(String param)
    {
        parameters.remove(param);
    }
    
    
    //Additional Methods
    public int numParameters()
    {
        return motors.size();
    }
    
    public int nextMotor()
    {
        return motors.size();
    }
    
    public String printMotors()
    {
        String output = "";
        if (motors.size() > 0)
        {
            output = "| Motors: ";
            for (int j=0; j<motors.size(); j++)
            {
                if (motors.get(j) != null)
                {
                    output += motors.get(j) + " | ";
                }
            }
            output+= "\n";
        }
        return output;
    }
    
    public String printParameters()
    {
        String output = "";
        if (parameters.size() > 0)
        {
            output = "| Parameters: ";
            for (String str : parameters)
            {
                output += str + " | ";
            }
            output+= "\n";
        }
        return output;
    }
    
    public String printAtom()
    {
        String output = super.printAtom();
        output += printMotors();
        output += printParameters();
        return output;
    }
    
    public JSONObject toJSON()
    {
        JSONObject json = super.toJSON();        
        
        if (!motors.isEmpty())
        {
            JSONArray values = new JSONArray();
            for (int m=0; m<motors.size(); m++)
            {
                String motor = motors.get(m);
                JSONObject jsonMotor = new JSONObject();
                jsonMotor.setString("motor", motor);
                values.setJSONObject(m, jsonMotor);
            }
            json.setJSONArray("motors", values);
        }
        
        if (!parameters.isEmpty())
        {
            JSONArray values = new JSONArray(); int i=0;
            for (String param : parameters)
            {
                JSONObject jsonParam = new JSONObject();
                jsonParam.setString("parameter", param);
                values.setJSONObject(i, jsonParam); i++;
            }
            json.setJSONArray("parameters", values);
        }
        
        return json;
    }
}
