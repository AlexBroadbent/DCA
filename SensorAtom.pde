/**
 *   Sensor Atom
 *     Extends Atom Class.
 *
 *   Alex Broadbent | 10/08/2013
**/
 
class SensorAtom extends Atom
{
    private ArrayList<String> sensors;
    private HashMap<String, Float[]> sensory_conditions;
        
    
    //Constructors
    public SensorAtom()
    {
        super("Sensory", orange);
        sensors = new ArrayList<String>();
        sensory_conditions = new HashMap<String, Float[]>();
    }
    
    public SensorAtom(ArrayList<String> sensorsIn)
    {
        super("Sensory", orange);
        sensors = sensorsIn;
        sensory_conditions = new HashMap<String, Float[]>();
    }
    
    public SensorAtom(String id, String type, float actTime)
    {
        super(id, type, actTime, orange);
        sensors = new ArrayList<String>();
        sensory_conditions = new HashMap<String, Float[]>();
    }
    
    public SensorAtom(String id, String type, float actTime, ArrayList<String> sensorsIn, HashMap<String, Float[]> sensory_conditionsIn)
    {
        super(id, type, actTime, orange);
        sensors = sensorsIn;
        sensory_conditions = sensory_conditionsIn;
    }
    
    public SensorAtom(ArrayList<String> sensorsIn, HashMap<String, Float[]> sensory_conditionsIn)
    {
        super("Sensory", orange);
        sensors = sensorsIn;
        sensory_conditions = sensory_conditionsIn;
    }
   
    
    //Getters and Setters
    public ArrayList<String> getSensors()
    {
        return sensors;
    }
    
    public void setSensors(ArrayList<String> sensor)
    {
        sensors = sensor;
    }
    
    public HashMap<String, Float[]> getAllSensory_Conditions()
    {
        return sensory_conditions;
    }
    
    public Float[] getSensory_Conditions(String atomID)
    {
        return sensory_conditions.get(atomID);
    }
        
    public void setSensory_Conditions(HashMap<String, Float[]> sens)
    {
        sensory_conditions = sens;
    }
    
    public Float getHighOf(String atomID)
    {
        Float[] vals = sensory_conditions.get(atomID);
        if (vals != null) {if (vals[0] != null) {return vals[0];}}
        return null;
    }
    
    public Float getLowOf(String atomID)
    {
        Float[] vals = sensory_conditions.get(atomID);
        if (vals != null) {if (vals[1] != null) {return vals[1];}}
        return null;
    }
   
   
    //Methods
    public void addSensor(String sensor)
    {
        sensors.add(sensor);
    }
    
    public void removeSensor(String sensor)
    {
        sensors.remove(sensor);
        
        if (sensory_conditions.containsKey(sensor))
        {
            sensory_conditions.remove(sensor);
        }
    }
    
    public void removeSensor(int row)
    {
        String sensor = sensors.get(row);
        
        //Remove Conditions, if they exist
        if (sensory_conditions.containsKey(sensor))
        {
            sensory_conditions.remove(sensor);
        }
    }
    
    public void addSensory_Condition(String atom, Float[] con)
    {
        sensory_conditions.put(atom, con);
    }
    
    public void removeSensory_Condition(String atom)
    {
        sensory_conditions.remove(atom);
    }    
    
    public void setSensory_Condition(String atom, Float high, Float low)       //for position - 0=high, 1=low
    {
        Float[] values = {high, low};
        sensory_conditions.put(atom, values);  //put() replaces any float values under atom value
    }
    
    public void renameSensor(int row, String newSensor)
    {
        String sensor = sensors.get(row);
        
        //If Sensor has conditions, change the key
        if (sensory_conditions.containsKey(sensor))
        {
            Float[] values = sensory_conditions.get(sensor);
            sensory_conditions.remove(sensor);
            sensory_conditions.put(newSensor, values);
        }
        
        //Rename Sensor in the Sensors Array
        sensors.toArray()[row] = newSensor;
    }
    
    
    //Additional Methods
    public int numParameters()
    {
        return sensors.size();
    }
    
    public String printSensors()
    {
        ArrayList<String> sensors = getSensors();
        
        String output = "";
        
        if (sensors.size() > 0)
        {
            output = "| Sensors, Conditions: ";
            for (String str : sensors)
            {
                output += str + ": ";
                Float[] cond = getSensory_Conditions(str);
                
                if (cond[0] != null && cond[1] != null)
                {
                    output += "H: " + cond[0] + " L: " + cond[1];
                }
                else if (cond[0] != null)
                {
                    output += "H: " + cond[0];
                }
                else if (cond[1] != null)
                {
                    output += "L: " + cond[1];
                }
                else
                {
                    output += "No Conditions";
                }
                output += " | ";
            }
            output += "\n";
        }
        
        return output;
    }
    
    public String printAtom()
    {
        String output = super.printAtom();
        output += printSensors();
        
        return output;
    }
    
    public JSONObject toJSON()
    {
        JSONObject json = super.toJSON();
        if (!sensory_conditions.isEmpty())
        {
            JSONArray jsonSensors = new JSONArray(); int i=0;
            for (String sensor : sensors)
            {
                JSONObject jsonSensor = new JSONObject();
                jsonSensor.setString("atomID", sensor);
                
                Float[] cons = getSensory_Conditions(sensor);
                if (cons != null)
                {
                    if (cons[0] != null && cons[1] != null)
                    {
                        jsonSensor.setFloat("high", cons[0]);
                        jsonSensor.setFloat("low", cons[1]);
                    }
                    else if (cons[0] != null)
                    {
                        jsonSensor.setFloat("high", cons[0]);
                    }
                    else if (cons[1] != null)
                    {
                        jsonSensor.setFloat("low", cons[1]);
                    }
                }
                
                jsonSensors.setJSONObject(i, jsonSensor); i++;
            }
            json.setJSONArray("sensors", jsonSensors);
        }
        return json;
    }
}
