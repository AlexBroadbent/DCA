/**
 *  Graph
 *    Contains the code to create and control a network.
 *
 *  Alex Broadbent | 31/08/2013
**/

import java.awt.*;
import java.awt.event.*;
import java.awt.event.KeyEvent;
import javax.swing.*;
import controlP5.*;
import g4p_controls.*;

//Set up colors to use throughout, makes it easier than typing out every time!!
color brown = color(95, 47, 11);
color orange = color(255, 160, 5);
color red = color(255, 15, 15);
color green = color(15, 150, 15);
color blue = color(15, 15, 255);
color silver = color(131, 131, 131);

//Declare Network Variables
Network network;
float FPS = 30;

//CHANGEABLE DEFAULT DELAY - Used for self-links
Float delay = new Float(0.2);

//Menu Variables                                                               - Can change depending on environment for robot type -
ArrayList<MenuItem> menuItems;
String menuText = "Left Click:      Select a Node, Drag a Node       Right Click: Join two Atoms/Nodes to create link\n"+
         "Operations:     ctrl+s - save network                      ctrl+o - load network                  ctrl+r - reset\n"+
         "                           delete - delete selected node       ctrl+shift+a - save as...             ctrl+p - options                   ctrl+z - undo moved node";

//Robot Environments Variables
String[] robots = {"Standard", "NAO", "Arduino"};
String environment;

//Drawing variables
int number = 0;
boolean drawn;

//Variables for Drag and Drop
String selected;
boolean hold;
boolean created;
Node holdNode;
PVector offSet;

//Variables for changing Link delay
Link selectedLink;

//Variables for Undo
ArrayList<undoState> undoStates;

//Variables for Linking Nodes
Node linkNode1;
Node linkNode2;

//Variables for Node Creation
String nodeType;
Atom newAtom;
Node newNode;

//Variables for save before exit
boolean savedChanges;
boolean saveThenExit;
File saveFile;

//Variables for Environment Preferences
boolean startupFile = false;   //If true, load up saveFile on startup
boolean displayAtomID = true;
boolean displayBox = false;
boolean displayProperties = false;

//Vairables for input
boolean[] keys = new boolean[526];
float clickTime;
float clickLength;

//Variables for preferences
PApplet app;
boolean propertiesShowFrame;



void setup()
{
    //Initialise Network Area
    size(800, 600, P2D);
    frameRate(FPS);
    smooth(4);
    background(255);
    hint(ENABLE_STROKE_PURE);
    imageMode(CENTER);
    
    //Stop G4P warnings
    G4P.messagesEnabled(false);
    
    //Initialise Network
    network = new Network();
    
    //Initialise draw variables
    drawn = false;
    
    //Initialise dragging variables
    selected = null;
    hold = false;
    holdNode = null;
    offSet = new PVector();
    
    //Initialise link delay change variables
    selectedLink = null;
    
    //Initialise undo variables
    undoStates = new ArrayList<undoState>();
    created = false;
    
    //Initialise saving variables
    savedChanges = true;
    saveThenExit = false;
    saveFile = null;
    
    //Initialise linking node variables
    linkNode1 = null;
    linkNode2 = null;
    
    //Initialise environment/robots variables              - Add load from properties file to check for a robot!!
    environment = "Standard";
    menuItems = new ArrayList<MenuItem>();
    loadStandardMenu();
    
    //Add Menu Buttons
    ControlP5 cp5 = new ControlP5(this);
    cp5.addButton("Save Network").setPosition(410, 20).setSize(74, 40);    
    cp5.addButton("Load Network").setPosition(510, 20).setSize(74, 40);       
    cp5.addButton("Run").setPosition(620, 20).setSize(74, 40);    
    cp5.addButton("Options...").setPosition(710, 20).setSize(74, 40);    
    
    //Load Prefernces
    loadPreferences();
    if (startupFile)
    {
        loadJSON(saveFile);
        println("Network loaded on Startup. This can be changed in the options menu.\n");
    }
    else
    {
        saveFile = null;
    }
    
    app = null;
}


void draw()
{    
    //Set title depending on saveFile and if changes have been saved
    String title = "";
    if (!savedChanges) {title += "*";}
    if (saveFile != null)
    {
        if (saveFile.getName().contains(".")) {
            title += saveFile.getName().substring(0, (saveFile.getName().indexOf('.')));
        }
        else
        {
            title += saveFile.getName();
        }
    }
    else
    {
        title += "New Graph";
    }
    title += " | Nodes " + network.numNodes() + " | Links " + network.numLinks();
    frame.setTitle(title);

    //Draw each node and link
    background(255);
    fill(0);
    
    //Draw Menu
    text("Atoms:", 10, 40);
    for (MenuItem item : menuItems)
    {
        fill(item.getColor()); noTint(); noStroke();
        ellipse(item.getImagePosition().x, item.getImagePosition().y, 40, 40);
        fill(0);
        text(item.getName(), item.getNamePosition().x, item.getNamePosition().y);
    }
    stroke(silver);
    line(0, 80, width, 80);
    line(390, 0, 390, 80);  //Atom Divider
    line(603, 0, 603, 80);  //Load/Save Divider
    
    //If MouseOvered menu - draw help text
    if (mouseY < 80)
    {
        fill(0);
        text(menuText, 10, 560);
    }
    
    //Draw each node
    for (Node node : network.nodes)
    {
        //Check if node is atom to add tint to image
        if (node.atom.active) {fill(node.atom._color, 100);}
        else {fill(node.atom._color);}
        
        noStroke();
        ellipse(node.position.x, node.position.y, node.radius*2, node.radius*2);
        
        if (!(node.mouseOvered() && displayProperties))
        {
            //Draw a rectangle around atom ID
            if (displayBox)
            {
                fill(240); noStroke();
                rect(node.position.x-7, node.position.y-10, (node.atom.getID().length() * 8), 20, 5);
            }
            if (displayAtomID)
            {
                fill(0);
                text(node.atom.getID(), node.position.x-5, node.position.y+5);
            }
        }
        else if (app == null)
        {
            displayProperties(node);
        }
    }
    
    for (Link link : network.links)
    {
        stroke(silver);
        if (selectedLink != null) {if (link.equals(selectedLink)) {stroke(silver, 100);}}        
        drawArrow(link);
    }
}

void exit()
{
    //Check save on exit...
    if (!savedChanges)
    {
        int selectedOption = JOptionPane.showConfirmDialog(null, "Save changes before exiting?",
                    "Close", JOptionPane.YES_NO_OPTION);
                   
        if (selectedOption == JOptionPane.YES_OPTION) 
        {
            if (saveFile != null)
            {
                saveJSON(saveFile);
                super.exit();
            }
            else
            {  
                saveThenExit = true;
                selectOutput("Save Network As...:", "saveJSON");
                return;
            }
        }
        else if (selectedOption == JOptionPane.NO_OPTION)
        {
            super.exit();
        }
    }
    else
    {
        super.exit();
    }
    
    if (saveThenExit)
    {
        super.exit();
    }
}
