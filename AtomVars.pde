/**
 *    Variable Changer
 *      Contains the code for changing the instance variables of nodes
 *        through G4P
 *
 *    Expansions:
 *      - Add an enabled option for each of the atom's variables
 *
 *    Alex Broadbent | 10/08/2013
**/

//Window Variables
GWindow menu;
Node node;

//Element Variables
GButton cancel;
GButton add;
GLabel sensorInvalid;

//Fixed Width and Height of text boxes (can be used for labels too)
int txtHeight = 20;
int txtWidthLarge = 80;
int txtWidthSmall = 35;

//Window width and height
int _width;
int _height;

//Properties' labels, text fields and remove buttons
GLabel[] sensorsLabelList = null;
GLabel[] sensorsLabelList_high = null;
GLabel[] sensorsLabelList_low = null;
GTextField[] sensorsList = null;
GTextField[] sensorsList_high = null;
GTextField[] sensorsList_low = null;
GButton[] removeSensorList = null;
GLabel[] motorLabelList = null;
GLabel[] motorParameterLabelList = null;
GTextField[] motorList = null;
GTextField[] motorParameterList = null;
GButton[] removeMotorList = null;
GLabel[] stateLabelList = null;
GTextField[] stateList = null;
GButton[] removeStateList = null;
GLabel[] transformLabelList = null;
GTextField[] transformList = null;
GButton[] removeTransformList = null;

public void createMenuWindow(Node _node)
{
    node = _node;
    
    //Set up Menu
    String title = "Properties of " + node.atom.getID();
    int _x = frame.getX() + (int) node.position.x - 40;
    int _y = frame.getY() + (int) node.position.y - 40;
    
    //Set defauly height and width
    _width = 200;
    _height = 220;
        
    //Make width wider for Sensory and Motor Atoms
    if (node.atom.getType().equals("Sensory")) {_width = 400;}
    else if (node.atom.getType().equals("Motor")) {_width = 320;}
    else if (node.atom.getType().equals("Transform")) {_width = 220;}
    
    //Increase height based upon number of parameters
    if (node.atom.numParameters() > 5)
    {
        _height += ((node.atom.numParameters()-5) * 30);
    }
    
    //Create window and add it to app
    menu = new GWindow(this, title, _x, _y, _width, _height, !propertiesShowFrame, JAVA2D);
    menu.setResizable(false);
    app = menu.papplet;
    
    //Display the atom's ID in the top left corner
    new GLabel(app, 0, 10, 100, 10, "ID: " + node.atom.getID());
    
    if(node.atom.getType().equals("Sensory"))
      {
          SensorAtom atom = (SensorAtom) node.atom;
          
          //Initiate Controls
          sensorsLabelList = new GLabel[10];
          sensorsLabelList_high = new GLabel[10];
          sensorsLabelList_low = new GLabel[10];
          sensorsList = new GTextField[10];
          sensorsList_high = new GTextField[10];
          sensorsList_low = new GTextField[10];
          removeSensorList = new GButton[10];
          
          add = new GButton(app, app.width-50, 10, txtWidthSmall, txtHeight, "+");
          add.addEventHandler(this, "handleSensorAddButton");
          
          if (atom.getSensors().size() > 0)
          {
              for (int r=0; r<atom.getSensors().size(); r++)
              {
                  try
                  {
                      String sensor = atom.getSensors().get(r);
                    
                      sensorsLabelList[r] = new GLabel(app, 10, (r*30)+40, 50, txtHeight, "Sensor:");
                      sensorsList[r] = new GTextField(app, 60, (r*30)+40, txtWidthLarge, txtHeight);
                      sensorsList[r].setText(sensor);
                      sensorsList[r].tagNo = r;
                      
                      sensorsLabelList_high[r] = new GLabel(app, 190, (r*30)+40, 35, txtHeight, "High:");
                      sensorsList_high[r] = new GTextField(app, 230, (r*30)+40, txtWidthSmall, txtHeight);
                      sensorsList_high[r].tagNo = r;
                      
                      sensorsLabelList_low[r] = new GLabel(app, 275, (r*30)+40, 35, txtHeight, "Low:");
                      sensorsList_low[r] = new GTextField(app, 310, (r*30)+40, txtWidthSmall, txtHeight);
                      sensorsList_low[r].tagNo = r;
                      
                      if (atom.getHighOf(sensor) != null) {sensorsList_high[r].setText(""+atom.getHighOf(sensor));}
                      if (atom.getLowOf(sensor) != null) {sensorsList_low[r].setText(""+atom.getLowOf(sensor));}
                      
                      sensorsList[r].addEventHandler(this, "handleSensorAtomTextEvent");
                      sensorsList_high[r].addEventHandler(this, "handleSensorAtomTextEvent");
                      sensorsList_low[r].addEventHandler(this, "handleSensorAtomTextEvent");
                      
                      removeSensorList[r] = new GButton(app, 350, (r*30)+40, txtWidthSmall, txtHeight, "-");
                      removeSensorList[r].tagNo = r;
                      removeSensorList[r].addEventHandler(this, "handleSensorRemoveButton");
                  }
                  catch (ArrayIndexOutOfBoundsException sex)
                  {}
              }
          }
          else
          {
              sensorsLabelList[0] = new GLabel(app, 10, 40, 50, txtHeight, "Sensor:");
              sensorsList[0] = new GTextField(app, 60, 40, txtWidthLarge, txtHeight);
              sensorsList[0].tagNo = 0;
              
              sensorsLabelList_high[0] = new GLabel(app, 190, 40, 35, txtHeight, "High:");
              sensorsList_high[0] = new GTextField(app, 230, 40, txtWidthSmall, txtHeight);
              sensorsList_high[0].tagNo = 0;
              
              sensorsLabelList_low[0] = new GLabel(app, 275, 40, 35, txtHeight, "Low:");
              sensorsList_low[0] =  new GTextField(app, 310, 40, txtWidthSmall, txtHeight);
              sensorsList_low[0].tagNo = 0;
              
              
              sensorsList[0].addEventHandler(this, "handleSensorAtomTextEvent");
              sensorsList_high[0].addEventHandler(this, "handleSensorAtomTextEvent");
              sensorsList_low[0].addEventHandler(this, "handleSensorAtomTextEvent");
              
              removeSensorList[0] = new GButton(app, 350, 40, txtWidthSmall, txtHeight, "-");
              removeSensorList[0].tagNo = 0;
              removeSensorList[0].addEventHandler(this, "handleSensorRemoveButton");
          }
      }
      
      else if(node.atom.getType().equals("Motor"))
      {
          MotorAtom atom = (MotorAtom) node.atom;
          
          //Initiate Controls
          motorLabelList = new GLabel[10];
          motorParameterLabelList = new GLabel[10];
          motorList = new GTextField[10];
          motorParameterList = new GTextField[10];
          removeMotorList = new GButton[10];
          
          //Add New Line Button
          add = new GButton(app, app.width-45, 10, txtWidthSmall, txtHeight, "+");
          add.addEventHandler(this, "handleMotorAddButton");
          
          if (atom.motors.size() > 0)        //lastMotor() initialises with -1, returned is where last non-null item is
          {
              for (int r=0; r<atom.nextMotor(); r++)
              {
                  
                  motorLabelList[r] = new GLabel(app, 10, (r*30)+40, txtWidthSmall, txtHeight, "Motor:");
                  motorList[r] = new GTextField(app, 55, (r*30)+40, txtWidthLarge, txtHeight);
                  motorList[r].setText(atom.motors.get(r));
                  motorList[r].tagNo = r;
                  motorList[r].addEventHandler(this, "handleMotorAtomTextEvent");
                  
                  motorParameterLabelList[r] = new GLabel(app, 160, (r*30)+40, 65, txtHeight, "Parameter:");
                  motorParameterList[r] = new GTextField(app, 230, (r*30)+40, txtWidthLarge, txtHeight);
                  try {if (atom.parameters.get(r) != null){motorParameterList[r].setText(atom.parameters.get(r));}}
                  catch (ArrayIndexOutOfBoundsException pex) {}
                  motorParameterList[r].tagNo = r;
                  motorParameterList[r].addEventHandler(this, "handleMotorParameterAtomTextEvent");
                  
                  removeMotorList[r] = new GButton(app, 350, (r*30)+40, txtWidthSmall, txtHeight, "-");
                  removeMotorList[r].tagNo = r;
                  removeMotorList[r].addEventHandler(this, "handleMotorRemoveButton");
              }
          }
          else
          {
              motorLabelList[0] = new GLabel(app, 10, 40, 45, txtHeight, "Motor:");
              motorList[0] = new GTextField(app, 55, 40, txtWidthLarge, txtHeight);
              motorList[0].tagNo = 0;
              motorList[0].addEventHandler(this, "handleMotorAtomTextEvent");
              
              motorParameterLabelList[0] = new GLabel(app, 160, 40, 65, txtHeight, "Parameter:");
              motorParameterList[0] = new GTextField(app, 230, 40, txtWidthLarge, txtHeight);
              motorParameterList[0].tagNo = 0;
              motorParameterList[0].addEventHandler(this, "handleMotorParameterAtomTextEvent");
              
              removeMotorList[0] = new GButton(app, 350, 40, txtWidthSmall, txtHeight, "-");
              removeMotorList[0].tagNo = 0;
              removeMotorList[0].addEventHandler(this, "handleMotorRemoveButton");
          }
      }   
      
      else if(node.atom.getType().equals("Game"))
      {
          GameAtom atom = (GameAtom) node.atom;
          
          //Controls
          stateList = new GTextField[10];
          removeStateList = new GButton[10];
          stateLabelList = new GLabel[10];
          
          //Add New Line Button
          add = new GButton(app, app.width-40, 10, txtWidthSmall, txtHeight, "+");
          add.addEventHandler(this, "handleGameAddButton");
          
          if (atom.getStates().size() > 0)
          {
              for (int r=0; r<atom.getStates().size(); r++)
              {
                  stateLabelList[r] = new GLabel(app, 10, (r*30)+40, txtWidthSmall, txtHeight, "State:");
                  
                  stateList[r] = new GTextField(app, 55, (r*30)+40, txtWidthLarge, txtHeight);
                  stateList[r].setText(atom.getStates().get(r));
                  stateList[r].tagNo = r;
                  stateList[r].addEventHandler(this, "handleGameAtomTextEvent");
                  
                  removeStateList[r] = new GButton(app, 160, (r*30)+40, txtWidthSmall, txtHeight, "-");
                  removeStateList[r].tagNo = r;
                  removeStateList[r].addEventHandler(this, "handleStateRemoveButton");
              }
          }
          else
          {
              stateLabelList[0] = new GLabel(app, 10, 40, txtWidthSmall, txtHeight, "State:");
              
              stateList[0] = new GTextField(app, 55, 40, txtWidthLarge, txtHeight);
              stateList[0].tagNo = 0;
              stateList[0].addEventHandler(this, "handleGameAtomTextEvent");
              
              removeStateList[0] = new GButton(app, 160, 40, txtWidthSmall, txtHeight, "-");
              removeStateList[0].tagNo = 0;
              removeStateList[0].addEventHandler(this, "handleStateRemoveButton");
          }
      }
  
      else if (node.atom.getType().equals("Transform"))
      {
          TransformAtom atom = (TransformAtom) node.atom;
          
          //Controls
          transformLabelList = new GLabel[10];
          transformList = new GTextField[10];
          removeTransformList = new GButton[10];
          
          //Add New Line Button
          add = new GButton(app, app.width-50, 10, txtWidthSmall, txtHeight, "+");
          add.addEventHandler(this, "handleTransformAddButton");
          
          if (atom.parameters.size() > 0)
          {
              for (int r=0; r<atom.parameters.size(); r++)
              {
                  transformLabelList[r] = new GLabel(app, 0, (r*30)+40, txtWidthLarge, txtHeight, "Parameter:");
                  
                  transformList[r] = new GTextField(app, 80, (r*30)+40, txtWidthLarge, txtHeight);
                  transformList[r].setText(atom.getParameters().get(r));
                  transformList[r].tagNo = r;
                  transformList[r].addEventHandler(this, "handleTransformAtomTextEvent");
                  
                  removeTransformList[r] = new GButton(app, 170, (r*30)+40, txtWidthSmall, txtHeight, "-");
                  removeTransformList[r].tagNo = r;
                  removeTransformList[r].addEventHandler(this, "handleTransformRemoveButton");
              }
          }
          else
          {
              transformLabelList[0] = new GLabel(app, 0, 40, txtWidthLarge, txtHeight, "Parameter:");
              
              transformList[0] = new GTextField(app, 80, 40, txtWidthLarge, txtHeight);
              transformList[0].tagNo = 0;
              transformList[0].addEventHandler(this, "handleTransformAtomTextEvent");
              
              removeTransformList[0] = new GButton(app, 170, 40, txtWidthSmall, txtHeight, "-");
              removeTransformList[0].tagNo = 0;
              removeTransformList[0].addEventHandler(this, "handleTransformRemoveButton");
          }
      }
      
      //Place Cancel button dependant on frame's height
      cancel = new GButton(app, 25, app.height-30, app.width-40, txtHeight, "Close");
}


/*
 *  Text Change Handlers
 */ 
public void handleSensorAtomTextEvent(GTextField textF, GEvent event)
{
    int tag = textF.tagNo;
    SensorAtom atom = (SensorAtom) node.atom;
 
    if (event == GEvent.CHANGED)
    {
        if (textF != sensorsList[tag])
        {
            //If high or low is being changed, change the background color
            /*
            if (textF == sensorsList_high[tag] && sensorsList_high[tag].getLocalColorScheme() == G4P.RED_SCHEME)
            {sensorsList_high[tag].setLocalColorScheme(G4P.BLUE_SCHEME);}
            else if (textF == sensorsList_low[tag] && sensorsList_low[tag].getLocalColorScheme() == G4P.RED_SCHEME)
            {sensorsList_low[tag].setLocalColorScheme(G4P.BLUE_SCHEME);}
            
            //Check that low is not greater than high
            Float high, low; low = high = null;
            if (!sensorsList_high[tag].getText().equals("")) {high = Float.parseFloat(sensorsList_high[tag].getText());}
            if (!sensorsList_low[tag].getText().equals("")) {low = Float.parseFloat(sensorsList_low[tag].getText());}
            Float[] vals = {high, low};
            
            if (low != null && high != null)
            {
                if (low > high)
                {
                    sensorInvalid = new GLabel(app, 150, 10, 150, 20, "Error: Low is greater than High");                    
                    sensorsList_high[tag].setLocalColorScheme(G4P.RED_SCHEME);
                    sensorsList_low[tag].setLocalColorScheme(G4P.RED_SCHEME);
                    textF.setFocus(true);
                }
                else
                {
                    //Values are valid
                    sensorInvalid.dispose();
                    sensorInvalid = null;                    
                    sensorsList_high[tag].setLocalColorScheme(G4P.GREEN_SCHEME);
                    sensorsList_low[tag].setLocalColorScheme(G4P.GREEN_SCHEME);
                
                    if (atom.getSensory_Conditions(sensorsList[tag].getText()) != null)
                    {
                        atom.setSensory_Condition(sensorsList[tag].getText(), high, low);
                    }
                    else
                    {
                        atom.addSensory_Condition(sensorsList[tag].getText(), vals);
                    }
                    
                    savedChanges = false;
                }
            }
            else
            {*/
                Float high, low; high = low = null;
                String sensor = sensorsList[tag].getText();
                
                try {if (!sensorsList_high[tag].getText().equals("")) {high = Float.valueOf(sensorsList_high[tag].getText());}} 
                catch (NumberFormatException ex) {high = null;}
                try {if (!sensorsList_low[tag].getText().equals("")) {low = Float.valueOf(sensorsList_low[tag].getText());}}
                catch (NumberFormatException ex) {low = null;}
                
                atom.setSensory_Condition(sensor, high, low);
            //}
        }
        else
        {
            try
            {
                String s = atom.sensors.get(tag);
                if (s != null) {atom.renameSensor(tag, textF.getText());}
            }
            catch (IndexOutOfBoundsException ex)
            {
                atom.addSensor(sensorsList[tag].getText());
            }
            println(atom.printAtom());
        }
            
    }
}

public void handleMotorAtomTextEvent(GTextField textF, GEvent event)
{
    if (event == GEvent.CHANGED)
    {
        int tag = textF.tagNo;
        MotorAtom atom = (MotorAtom) node.atom;
        if (motorList[tag].getLocalColorScheme() != G4P.RED_SCHEME) {motorList[tag].setLocalColorScheme(G4P.RED_SCHEME);}
        
        String motor = textF.getText();        
        try
        {
            atom.motors.set(tag, motor);
        }
        catch (ArrayIndexOutOfBoundsException ex)
        {
            atom.addMotor(motor);
        }
        
        if (motorList[tag].getLocalColorScheme() != G4P.GOLD_SCHEME) {motorList[tag].setLocalColorScheme(G4P.GOLD_SCHEME);}
        savedChanges = false;
    }
}

public void handleMotorParameterAtomTextEvent(GTextField textF, GEvent event)
{
    if (event == GEvent.CHANGED)
    {
        MotorAtom atom = (MotorAtom) node.atom;
        String parameter = textF.getText();
        int tag = textF.tagNo;
        
        try
        {
            atom.parameters.toArray()[tag] = parameter;
        }
        catch (IndexOutOfBoundsException ex)
        {
            atom.addParameter(parameter);
        }
        
        savedChanges = false;
    }
}

public void handleGameAtomTextEvent(GTextField textF, GEvent event)
{
    GameAtom atom = (GameAtom) node.atom;
    String state = textF.getText();
    int tag = textF.tagNo;
    
    try
    {
        atom.states.set(tag, state);
    }
    catch (IndexOutOfBoundsException ex)
    {
        atom.addState(state);
    }
    
    savedChanges = false;
}

public void handleTransformAtomTextEvent(GTextField textF, GEvent event)
{
    TransformAtom atom = (TransformAtom) node.atom;
    String parameter = textF.getText();
    int tag = textF.tagNo;
    
    try
    {
        atom.parameters.set(tag, parameter);
    }
    catch (IndexOutOfBoundsException ex)
    {
        atom.addParameter(parameter);
    }
    
    savedChanges = false;
}




/*
 *     Button Click Handlers
 */
 
public void handleButtonEvents(GButton button, GEvent event)
{
    if (button == cancel && event == GEvent.CLICKED)
    {
        node.atom.active = false;
        
        //Set All Elements back to null
        sensorsLabelList = null;
        sensorsLabelList_high = null;
        sensorsLabelList_low = null;
        sensorsList = null;
        sensorsList_high = null;
        sensorsList_low = null;
        removeSensorList = null;
        motorLabelList = null;
        motorParameterLabelList = null;
        motorList = null;
        motorParameterList = null;
        removeMotorList = null;
        stateLabelList = null;
        stateList = null;
        removeStateList = null;
        transformLabelList = null;
        transformList = null;
        removeTransformList = null;
        
        menu.forceClose();
        app = null;
    }
}

public void handleSensorAddButton(GButton button, GEvent event)
{
    int r = getNextEmptyPosition(sensorsList);
    
    if (r < 10)
    {
        if (r > 4)
        {
            if (r == 5) {_height += 60;}
            else {_height += 30;}
            
            menu.setSize(menu.getWidth(), _height);
            cancel.moveTo(cancel.getX(), cancel.getY()+30);
        }
        
        sensorsLabelList[r] = new GLabel(app, 10, (r*30)+40, 50, txtHeight, "Sensor:");
        sensorsList[r] = new GTextField(app, 60, (r*30)+40, txtWidthLarge, txtHeight);
        sensorsList[r].tagNo = r;
        
        sensorsLabelList_high[r] = new GLabel(app, 190, (r*30)+40, 35, txtHeight, "High:");
        sensorsList_high[r] = new GTextField(app, 230, (r*30)+40, txtWidthSmall, txtHeight);
        sensorsList_high[r].tagNo = r;
        
        sensorsLabelList_low[r] = new GLabel(app, 275, (r*30)+40, 35, txtHeight, "Low:");
        sensorsList_low[r] = new GTextField(app, 310, (r*30)+40, txtWidthSmall, txtHeight);
        sensorsList_low[r].tagNo = r;
        
        sensorsList[r].addEventHandler(this, "handleSensorAtomTextEvent");
        sensorsList_high[r].addEventHandler(this, "handleSensorAtomTextEvent");
        sensorsList_low[r].addEventHandler(this, "handleSensorAtomTextEvent");    
        
        removeSensorList[r] = new GButton(app, 350, (r*30)+40, txtWidthSmall, txtHeight, "-");
        removeSensorList[r].tagNo = r;
        removeSensorList[r].addEventHandler(this, "handleSensorRemoveButton");
    }
}

public void handleMotorAddButton(GButton button, GEvent event)
{
    int r = getNextEmptyPosition(motorList);
    if (r < 10)
    {
        if (r > 4)
        {
            if (r == 5) {_height += 60;}
            else {_height += 30;}
            
            menu.setSize(menu.getWidth(), _height);
            cancel.moveTo(cancel.getX(), cancel.getY()+30);
        }
        
        motorLabelList[r] = new GLabel(app, 10, (r*30)+40, txtWidthSmall, txtHeight, "Motor:");
        motorList[r] = new GTextField(app, 55, (r*30)+40, txtWidthLarge, txtHeight);
        motorList[r].tagNo = r;
        
        
        motorParameterLabelList[r] = new GLabel(app, 160, (r*30)+40, 65, txtHeight, "Parameter:");
        motorParameterList[r] = new GTextField(app, 230, (r*30)+40, txtWidthLarge, txtHeight);
        motorParameterList[r].tagNo = r;
        
        motorList[r].addEventHandler(this, "handleMotorAtomTextEvent");
        motorParameterList[r].addEventHandler(this, "handleMotorParameterAtomTextEvent");
    }
}

public void handleGameAddButton(GButton button, GEvent event)
{
    int r = getNextEmptyPosition(stateList);
    
    if (r < 10)
    {
        if (r > 4)
        {
            if (r == 5) {_height += 60;}
            else {_height += 30;}
            
            menu.setSize(menu.getWidth(), _height);
            cancel.moveTo(cancel.getX(), cancel.getY()+30);
        }
        
        stateLabelList[r] = new GLabel(app, 10, (r*30)+40, txtWidthSmall, txtHeight, "State:");
                      
        stateList[r] = new GTextField(app, 55, (r*30)+40, txtWidthLarge, txtHeight);
        stateList[r].tagNo = r;
        stateList[r].addEventHandler(this, "handleGameAtomTextEvent");
        
        removeStateList[r] = new GButton(app, 160, (r*30)+40, txtWidthSmall, txtHeight, "-");
        removeStateList[r].tagNo = r;
        removeStateList[r].addEventHandler(this, "handleStateRemoveButton");
    }
}

public void handleTransformAddButton(GButton button, GEvent event)
{
    int r = getNextEmptyPosition(transformList);
    if (r < 10)
    {  
        if (r > 4)
        {
            if (r == 5) {_height += 60;}
            else {_height += 30;}
            
            menu.setSize(menu.getWidth(), _height);
            cancel.moveTo(cancel.getX(), cancel.getY()+30);
        }
        
        transformLabelList[r] = new GLabel(app, 0, (r*30)+40, txtWidthLarge, txtHeight, "Parameter:");
        
        transformList[r] = new GTextField(app, 80, (r*30)+40, txtWidthLarge, txtHeight);
        transformList[r].tagNo = r;
        transformList[r].addEventHandler(this, "handleTransformAtomTextEvent");
        
        removeTransformList[r] = new GButton(app, 170, (r*30)+40, txtWidthSmall, txtHeight, "-");
        removeTransformList[r].tagNo = r;
        removeTransformList[r].addEventHandler(this, "handleTransformRemoveButton");
    }
}



/*
 *    Remove Sensor Button
 */
public void handleSensorRemoveButton(GButton button, GEvent event)
{
    if (event == GEvent.CLICKED)
    {
        SensorAtom atom = (SensorAtom) node.atom;
        int tag = button.tagNo;
        
        //Confirmation
        int confirm = JOptionPane.showConfirmDialog(null, "Are you sure you want to remove the sensor " + sensorsList[tag].getText() + "?",
                        "Confirm Removal", JOptionPane.YES_NO_OPTION);
        
        if (confirm == JOptionPane.YES_OPTION)
        {
            atom.removeSensor(tag);
            
            if (getNextEmptyPosition(sensorsList)-1 > tag)
            {
                for (int i=tag; i<getNextEmptyPosition(sensorsList)-1; i++)
                {
                    sensorsList[i].setText(sensorsList[i+1].getText());
                    sensorsList_high[i].setText(sensorsList_high[i+1].getText());
                    sensorsList_low[i].setText(sensorsList_low[i+1].getText());
                }
            }
            
            if (sensorsList[getNextEmptyPosition(sensorsList)-1] != null)
            {
                  sensorsList[getNextEmptyPosition(sensorsList)-1] = null;
                  sensorsList_low[getNextEmptyPosition(sensorsList)-1] = null;
                  sensorsList_high[getNextEmptyPosition(sensorsList)-1] = null;
            }
        }
    }
}

public void handleMotorRemoveButton(GButton button, GEvent event)
{
    int tag = button.tagNo;
    int last = getNextEmptyPosition(stateList)-1;

    MotorAtom atom = (MotorAtom) node.atom;

    if (atom.motors.size() > 0)
    {
        atom.motors.remove(tag);
        atom.parameters.remove(tag);
    }
    
    if (last > tag)
    {
        for (int i=tag; i<atom.motors.size(); i++)
        {
            motorList[i].setText(atom.motors.get(i));
            motorParameterList[i].setText(atom.parameters.get(i));
        }
        
        motorLabelList[last].dispose();
        motorLabelList[last] = null;
        motorList[last].dispose();
        motorList[last] = null;
        removeMotorList[last].dispose();
        removeMotorList[last] = null;
        motorParameterLabelList[last].dispose();
        motorParameterLabelList[last] = null;
        motorParameterList[last].dispose();
        motorParameterList[last] = null;
    }
    else if (tag == 0)
    {
        motorList[0].setText("");
        motorParameterList[0].setText("");
    }
}

public void handleStateRemoveButton(GButton button, GEvent event)
{
    int tag = button.tagNo;
    int last = getNextEmptyPosition(stateList)-1;
    
    GameAtom atom = (GameAtom) node.atom;
    if (atom.states.size() > 0)
    {
        atom.states.remove(tag);
    }
    
    if (last > tag)
    {
        //Push Other values up to their new position in the arraylist
        if (atom.states.size() > 0)
        {
            for (int i=tag; i<atom.states.size(); i++)
            {
                stateList[i].setText(atom.states.get(i));
            }
        }
        
        //Remove last text field
        stateLabelList[last].dispose();
        stateLabelList[last] = null;
        stateList[last].dispose();
        stateList[last] = null;
        removeStateList[last].dispose();
        removeStateList[last] = null;
    }
    else if (tag == 0)
    {
        stateList[0].setText("");
        atom.states.clear();        
    }
}

public void handleTransformRemoveButton(GButton button, GEvent event)
{
    int tag = button.tagNo;
    int last = getNextEmptyPosition(transformList)-1;
    
    TransformAtom atom = (TransformAtom) node.atom;
    atom.parameters.remove(tag);
    
    if (last > tag)
    {
        //Push Other values up to their new position in the arraylist
        if (atom.parameters.size() > 0)
        {
            for (int i=0; i<atom.parameters.size(); i++)
            {
                transformList[i].setText(atom.parameters.get(i));
            }
        }
        
        //Remove last text field
        if (transformList[last] != null)
        {
            transformLabelList[last].dispose();
            transformLabelList[last] = null;
            transformList[last].dispose();
            transformList[last] = null;
            removeTransformList[last].dispose();
            removeTransformList[last] = null;
        }
    }
    else if (tag == 0 && atom.parameters.size() == 1)
    {
        transformList[0].setText("");
        atom.parameters.clear();
    }
}

public int getNextEmptyPosition(GTextField[] gt)
{
    for (int i=0; i<gt.length; i++)
    {
        if (gt[i] == null)
        {
            return i;
        }
        else if (i > 0 && gt[i].getText().equals(""))
        {
            return i;
        }
    }
    return 0;
}
