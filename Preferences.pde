/**
 *   Preferences
 *    - Contains code to be able to load and save user preferences, and view options menu
 *    - Created using GUI Builder Tool - http://www.lagers.org.uk/g4ptool/index.html
 *
 *   Alex Broadbent | 10/08/2013
**/   


//Window Variables
GWindow options;

//Form Variables
GLabel lblEnvironmentOptions;
GLabel lblType;
GDropList drpEnvironmentTypes;
GLabel lblStartupOptions;
GCheckbox chkRememberFile;
GButton btnPickFile;
GLabel lblFileName;
GLabel lblDisplayOptions;
GCheckbox chkDisplayAtomID; 
GCheckbox chkDisplayProperties;
GCheckbox chkDisplayBox;
GCheckbox chkVariableShowFrame;
GButton btnSave;
GButton btnClose;
GLabel error = null;

public void createOptionsMenu()
{
    options = new GWindow(this, "Options", frame.getX()+(width/3), frame.getY()+100, 230, 390, false, JAVA2D);
    options.setResizable(false);
    options.setOnTop(false);
    app = options.papplet;
    
    G4P.messagesEnabled(false);
  
    //Place elements onto GWindow
    new GLabel(app, 0, 0, 50, 25, "Options");
    
    lblEnvironmentOptions = new GLabel(app, 10, 10, 220, 30);
    lblEnvironmentOptions.setText("Environment Options");
    lblEnvironmentOptions.setTextBold();
    lblEnvironmentOptions.setOpaque(false);
    
    lblType = new GLabel(app, 10, 38, 80, 25);
    lblType.setText("Type");
    lblType.setOpaque(false);
    
    drpEnvironmentTypes = new GDropList(app, 100, 40, 132, 66, 3);
    drpEnvironmentTypes.setItems(robots, 0);                        //Robots = "Standard", "NAO", "Arduino" - Graph
    for (int i=0; i<robots.length; i++) 
    {
        if (robots[i].equals(environment)) 
        {
            drpEnvironmentTypes.setSelected(i);
        }
    }
    drpEnvironmentTypes.addEventHandler(this, "drpEnvironmentTypes_Clicked");
    
    lblStartupOptions = new GLabel(app, 10, 80, 220, 30);
    lblStartupOptions.setText("Startup Options");
    lblStartupOptions.setTextBold();
    lblStartupOptions.setOpaque(false);
    
    chkRememberFile = new GCheckbox(app, 10, 110, 150, 25);
    chkRememberFile.setText("Remember File");
    chkRememberFile.setOpaque(false);
    chkRememberFile.addEventHandler(this, "chkRememberFile_Clicked");
    if (startupFile) {chkRememberFile.setSelected(true);}
    else {chkRememberFile.setSelected(false);}
    
    btnPickFile = new GButton(app, 130, 110, 100, 25);
    btnPickFile.setText("Select New File");
    btnPickFile.addEventHandler(this, "btnPickFile_Clicked");
    
    lblFileName = new GLabel(app, 10, 140, 210, 25);
    lblFileName.setText("File: None Selected");
    lblFileName.setTextItalic();
    lblFileName.setOpaque(false);
    if (saveFile != null) {lblFileName.setText("File: " + saveFile.getName());}
    
    lblDisplayOptions = new GLabel(app, 10, 170, 220, 30);
    lblDisplayOptions.setText("Display Options");
    lblDisplayOptions.setTextBold();
    lblDisplayOptions.setOpaque(false);
    
    chkDisplayAtomID = new GCheckbox(app, 10, 210, 120, 25);
    chkDisplayAtomID.setText("Display Atom ID");
    chkDisplayAtomID.setOpaque(false);
    chkDisplayAtomID.addEventHandler(this, "chkDisplayAtomID_Clicked");
    if (displayAtomID) {chkDisplayAtomID.setSelected(true);}
    else {chkDisplayAtomID.setSelected(false);}
    
    chkDisplayBox = new GCheckbox(app, 10, 240, 150, 25);
    chkDisplayBox.setText("Display Box");
    chkDisplayBox.setOpaque(false);
    chkDisplayBox.addEventHandler(this, "chkDisplayBox_CLICKED");
    if (displayBox && displayAtomID) {chkDisplayBox.setSelected(true);}
    else {chkDisplayBox.setSelected(false);}
    
    chkDisplayProperties = new GCheckbox(app, 10, 270, 200, 25);
    chkDisplayProperties.setText("Display Properties on Mouse Over");
    chkDisplayProperties.setOpaque(false);
    chkDisplayProperties.addEventHandler(this, "chkDisplayProperties_Clicked");
    if (displayProperties) {chkDisplayProperties.setSelected(true);}
    else {chkDisplayProperties.setSelected(false);}
    
    chkVariableShowFrame = new GCheckbox(app, 10, 310, 200, 25);
    chkVariableShowFrame.setText("Display Frame around Atom Properties");
    chkVariableShowFrame.setOpaque(false);
    chkVariableShowFrame.addEventHandler(this, "chkVariableShowFrame_Clicked");
    if (propertiesShowFrame) {chkVariableShowFrame.setSelected(true);}
    else {chkVariableShowFrame.setSelected(false);}
    
    btnClose = new GButton(app, 10, 360, 100, 30);
    btnClose.setText("Close");
    btnClose.setTextBold();
    btnClose.addEventHandler(this, "btnClose_Clicked");
    
    btnSave = new GButton(app, 120, 360, 100, 30);
    btnSave.setText("Save");
    btnSave.setTextBold();
    btnSave.addEventHandler(this, "btnSave_Clicked");
}


public void drpEnvironmentTypes_Clicked(GDropList source, GEvent event) 
{
    if (event == GEvent.SELECTED)
    {
        resetNetwork();
        
        environment = robots[source.getSelectedIndex()];        
        loadMenu(environment);
    }
}

public void chkRememberFile_Clicked(GCheckbox source, GEvent event) 
{
    if (source.isSelected())
    {
        if (saveFile == null)
        {
            error = new GLabel(app, 10, 200, 200, 25, "Select a file first...");
            error.setLocalColorScheme(G4P.RED_SCHEME);
        }
        else
        {
            if (error != null)
            {
                error.dispose();
                error = null;
            }            
            startupFile = !startupFile;
        }
    }  
    else
    {
        if (error != null)
        {
            error.dispose();
            error = null;
        }
        startupFile = !startupFile;
    }
}

public void btnPickFile_Clicked(GButton source, GEvent event) 
{
    String fname = G4P.selectInput("Select Network...", "json", "JSON Networks");
    
    if (fname != null)
    {
        saveFile = new File(fname);
        lblFileName.setText("File: " + saveFile.getName().substring(0, (saveFile.getName().indexOf('.'))));
        
        int selectedOption = JOptionPane.showConfirmDialog(null, "Do you want to load the network " + saveFile.getName()  + "?",
                    "Load Network", JOptionPane.YES_NO_OPTION);
                   
        if (selectedOption == JOptionPane.YES_OPTION) 
        {
            loadJSON(saveFile);
        }
    }
}

public void chkDisplayAtomID_Clicked(GCheckbox source, GEvent event) 
{
    displayAtomID = !displayAtomID;
    if (displayBox && !displayAtomID)
    {
        displayBox = false;
        chkDisplayBox.setSelected(false);
    }
}

public void chkDisplayProperties_Clicked(GCheckbox source, GEvent event) 
{    
    displayProperties = !displayProperties;
}

public void chkDisplayBox_CLICKED(GCheckbox source, GEvent event) 
{
    displayBox = !displayBox;
    
    if (source.isSelected())
    {
        if (!displayAtomID)
        {
            chkDisplayAtomID.setSelected(true);
            displayAtomID = true;
        }
    }
}

public void chkVariableShowFrame_Clicked(GCheckbox source, GEvent event)
{
    propertiesShowFrame = !propertiesShowFrame;
}

public void btnClose_Clicked(GButton source, GEvent event) 
{
    options.forceClose();
    app = null;
}

public void btnSave_Clicked(GButton source, GEvent event)
{
    savePreferences();
    
    options.forceClose();
    app = null;
}



// Load and Save Preferences
void loadPreferences()
{  
    File options = new File(sketchPath("options.properties"));
    
    String[] lines = loadStrings(options);
    for (int i=0; i<lines.length; i++)
    {
        String line = lines[i];
        if (line.charAt(0) != ('#'))
        {
            String[] result = split(line, '=');
            String type = result[0];
            String value = result[1];
                        
            //Go Through Options
            if (type.equals("environment"))
            {
                environment = value;
            }
            
            else if (type.equals("startupFile"))
            {
                if (value.equals("true"))
                {
                    startupFile = true;
                }
                else if (value.equals("false"))
                {
                    startupFile = false;
                }
            }
            else if (type.equals("saveFile"))
            {
                saveFile = new File(value);
            }
            
            else if (type.equals("displayAtomID"))
            {
                if (value.equals("true"))
                {
                    displayAtomID = true;
                }
                else if (value.equals("false"))
                {
                    displayAtomID = false;
                }
            }
            else if (type.equals("displayBox"))
            {
                if (!displayAtomID)
                {
                    displayBox = true;
                }
                else
                {
                    if (value.equals("true"))
                    {
                        displayBox = true;
                    }
                    else if (value.equals("false"))
                    {
                        displayBox = false;
                    }
                }
            }
            else if (type.equals("displayProperties"))
            {
                if (value.equals("true"))
                {
                    displayProperties = true;
                }
                else if (value.equals("false"))
                {
                    displayProperties = false;
                }
            }
            else if (type.equals("propertiesShowFrame"))
            {
                if (value.equals("true"))
                {
                    propertiesShowFrame = true;
                }
                else if (value.equals("false"))
                {
                    propertiesShowFrame = true;
                }
            }
        } 
    }
}

void savePreferences()
{
    File options = new File(sketchPath("options.properties"));
    
    String[] lines = loadStrings(options);    
    String[] newLines = new String[lines.length];
    
    for (int i=0; i<lines.length; i++)
    {
        String line = lines[i];
        if (line.charAt(0) != ('#'))
        {
            String[] result = split(line, '=');
            String type = result[0];
                        
            //Go Through Options
            if (type.equals("environment"))
            {
                newLines[i] = type + "=" + environment;
            }
            else if (type.equals("startupFile"))
            {
                //Don't allow startupFile to be true with no saveFile, will result in crash on loading
                if (saveFile == null)
                {
                    newLines[i] = type + "=" + false;
                }
                else
                {
                    newLines[i] = type + "=" + startupFile;
                }
            }
            else if (type.equals("saveFile"))
            {
                if (saveFile != null)
                {
                    newLines[i] = type + "=" + saveFile;
                }
                else
                {
                    newLines[i] = type + "=" + "null";
                }
            }
            else if (type.equals("displayBox"))
            {
                if (!displayAtomID)
                {
                    newLines[i] = type + "=" + false;
                }
                else 
                {
                    newLines[i] = type + "=" + displayBox;
                }
            }
            else if (type.equals("displayAtomID"))
            {
                newLines[i] = type + "=" + displayAtomID;
            }
            else if (type.equals("displayProperties"))
            {
                newLines[i] = type + "=" + displayProperties;
            }
            else if (type.equals("propertiesShowFrame"))
            {
                newLines[i] = type + "=" + propertiesShowFrame;
            }
        }
        else
        {
            newLines[i] = lines[i];
        }
    }
    
    saveStrings(options, newLines);
}
