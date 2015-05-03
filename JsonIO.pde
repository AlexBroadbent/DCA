/**
 *    JSON I/O
 *      Contains the extended main code for importing and exporting json networks
 *
 *    Expansion:
 *      Set a JSON Filter for selected files
 *
 *    Alex Broadbent | 10/08/2013
**/

//Save the JSON Network to the parsed file
void saveJSON(File selection)
{
    if (selection != null)
    {
        String folderLocation = selection.getParent();
        String fileName = selection.getName();
        if (!fileName.contains("."))
        {
            fileName += ".json";
        }
        
        if (fileName.endsWith(".json"))
        {
            saveFile = selection;
            savedChanges = true;
          
            JSONObject jsonNetwork = network.toJSON();
            saveJSONObject(jsonNetwork, folderLocation + "\\" + fileName);
            
            //println("Network Saved.");
        }
        else
        {
            println("Invalid file format. The file must be a JSON type.");
        }
    }
}


//Load a network from the parsed file
void loadJSON(File selection)
{
    if (selection != null)
    {        
        //String ext = selection.getAbsolutePath().substring(selection.getAbsolutePath().lastIndexOf('.'));
        if (selection.getName().endsWith(".json"))
        {
            print("Loading " + selection.getName() + "...");
            
            network = new Network();            
            number = 0;
            saveFile = selection;
            savedChanges = true;
            
            JSONObject nw = loadJSONObject(selection.getAbsolutePath());            
            JSONArray nodes = nw.getJSONArray("network");
            
            String[][] linksToProcess = new String[nodes.size()*50][2];
            Float[] delaysToProcess = new Float[nodes.size()*50];
            int counter = 0;
            
            for (int i=0; i<nodes.size(); i++)
            {
                JSONObject node = nodes.getJSONObject(i);
                
                //Load node
                String nodeID = node.getJSONObject("node").getString("nodeID");
                Float x = node.getJSONObject("node").getFloat("x");
                Float y = node.getJSONObject("node").getFloat("y");
                Float radius = node.getJSONObject("node").getFloat("radius");
                
                //Load atom from node
                JSONObject atom = node.getJSONObject("node").getJSONObject("atom");
                String id = atom.getString("id");
                String type = atom.getString("type");
                Float activeTime = atom.getFloat("activeTime");
                JSONArray linkTo = null;
                JSONArray linkFrom = null;
                
                if (atom.hasKey("linkTo"))
                {            
                    linkTo = atom.getJSONArray("linkTo");
                }
                
                if (atom.hasKey("linkFrom"))
                {
                    linkFrom = atom.getJSONArray("linkFrom");
                }
                
                //Create atom
                Atom newAtom = null;
                
                if (type.equals("Base"))
                {
                    newAtom = new Atom(id, type, activeTime, brown);
                }
                
                else if (type.equals("Sensory"))
                {
                    newAtom = new SensorAtom(id, type, activeTime);
                    if (atom.hasKey("sensors"))
                    {
                        JSONArray sensors = atom.getJSONArray("sensors");
                        HashMap<String, Float[]> newSensory_Conditions = new HashMap<String, Float[]>();
                        ArrayList<String> newSensors = new ArrayList<String>();
                    
                        //Convert from JSONArray to HashMap
                        for (int s=0; s<sensors.size(); s++)
                        {
                            JSONObject sensor = sensors.getJSONObject(s);
                            String atomID = sensor.getString("atomID");
                            newSensors.add(atomID);
                            
                            Float high = null; 
                            Float low = null;
                            if (sensor.hasKey("high"))
                            {
                                high = sensor.getFloat("high");
                            }
                            if (sensor.hasKey("low"))
                            {
                                low = sensor.getFloat("low");
                            }
                            
                            Float[] newFloatArray = {high, low};                        
                            newSensory_Conditions.put(atomID, newFloatArray);
                        }                        
                        newAtom = new SensorAtom(id, type, activeTime, newSensors, newSensory_Conditions);
                    }
                }
                
                else if (type.equals("Motor"))
                {
                    newAtom = new MotorAtom(id, type, activeTime);
                    
                    if (atom.hasKey("motors"))
                    {
                        JSONArray motors = atom.getJSONArray("motors");
                        ArrayList<String> newMotors = new ArrayList<String>();
                        
                        for (int m=0; m<motors.size(); m++)
                        {
                            JSONObject motor = motors.getJSONObject(m);
                            newMotors.add(motor.getString("motor"));
                        }
                        
                        newAtom = new MotorAtom(id, type, activeTime, newMotors);
                        
                        if (atom.hasKey("parameters"))
                        {
                            JSONArray parameters = atom.getJSONArray("parameters");
                            ArrayList<String> newParameters = new ArrayList<String>();
                            
                            for (int p=0; p<parameters.size(); p++)
                            {
                                JSONObject param = parameters.getJSONObject(p);
                                newParameters.add(param.getString("parameter"));
                            }
                            
                            newAtom = new MotorAtom(id, type, activeTime, newMotors, newParameters);
                        }
                    }
                }
                
                else if (type.equals("Game"))
                {
                    newAtom = new GameAtom(id, type, activeTime);
                    
                    if (atom.hasKey("states"))
                    {
                        JSONArray states = atom.getJSONArray("states");
                        ArrayList<String> newStates = new ArrayList<String>();
                        
                        for (int g=0; g<states.size(); g++)
                        {
                            JSONObject state = states.getJSONObject(g);
                            newStates.add(state.getString("state"));
                        }
                        newAtom = new GameAtom(id, type, activeTime, newStates);
                    }
                }
                
                else if (type.equals("Transform"))
                {
                    newAtom = new TransformAtom(id, type, activeTime);
                    
                    if (atom.hasKey("parameters"))
                    {
                        JSONArray parameters = atom.getJSONArray("parameters");
                        ArrayList<String> newParameters = new ArrayList<String>();
                        
                        for (int k=0; k<parameters.size(); k++)
                        {
                            JSONObject param = parameters.getJSONObject(k);
                            newParameters.add(param.getString("parameter"));
                        }
                        
                        newAtom = new TransformAtom(id, type, activeTime, newParameters);
                    }
                }
                
                //Add in LinksTo and LinksFrom for each atom and add to Network
                if (linkTo != null && linkFrom != null)
                {
                    for (int f=0; f<linkTo.size(); f++)
                    {
                        JSONObject link = linkTo.getJSONObject(f);
                        String atomID = link.getString("atomID");
                        Float delay = link.getFloat("delay");
                        boolean bidirectional = link.getBoolean("bidirectional");
                        
                        linksToProcess[counter][0] = atomID;
                        linksToProcess[counter][1] = id;
                        delaysToProcess[counter] = delay;
                        bidirsToProcess[counter] = bidirectional;
                        
                        counter++;
                    }
                }
                Node newNode = new Node(nodeID, x.intValue(), y.intValue(), radius, newAtom);
                network.addNode(newNode);
            }
            
            network.createLinkNetwork(linksToProcess, delaysToProcess);
            number = nodes.size();
            print(" Import Complete\n");
        }
        else
        {
            println("Invalid file type. Must be a json file");
        }
    }
    else
    {
        println("Error, please try again");
    }
}
