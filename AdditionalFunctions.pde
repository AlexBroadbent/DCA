/**
 *  Additional Functions
 *    Contains the extended code of main functions.
 *
 *  Alex Broadbent | 31/08/2013
**/

public int getNumber()
{
    //Create node ID
    number++;
    return number;
}

void drawArrow(Link link)
{
    Node nFrom = link.getNodeFrom();
    Node nTo = link.getNodeTo();
    
    //Bug - Reverse positions.
    int x2 = (int) nFrom.position.x;
    int y2 = (int) nFrom.position.y;
    int x1 = (int) nTo.position.x;
    int y1 = (int) nTo.position.y;
        
    if ((x1 == x2) && (y1 == y2))
    {
        noFill();
        
        //Draw arc over node
        arc(x1, y1-nFrom.radius-2, (nFrom.radius*2), (nFrom.radius*2), PI-(PI/5), TWO_PI+(PI/5));
        
        //Draw Arrow Head
        PVector point = new PVector(x1-(nTo.radius)+4, y1-(nTo.radius/2));
        line(point.x, point.y, point.x - 0.2, point.y - 10);
        line(point.x, point.y, point.x - 10, point.y - 3);
    }
    else
    {
        PVector p = new PVector(x1 - x2, y1 - y2);
        PVector q = new PVector(x1 - x2, y1 - y2);
    
        p.limit(nTo.radius);
        q.limit(dist(x2, y2, x1, y1)-(nFrom.radius));
        
        line(x2+p.x, y2+p.y, x2+q.x, y2+q. y);
        pushMatrix();
        translate(x2+q.x, y2+q.y);
        rotate(radians(30));
        line(0, 0, -p.x/2, -p.y/2);
        rotate(radians(-60));
        line(0, 0, -p.x/2, -p.y/2); 
        popMatrix();
        
        if (link.getBidirectional())
        {
            pushMatrix();
            translate(x1-q.x, y1-q.y);
            rotate(radians(30));
            line(0, 0, p.x/2, p.y/2);
            rotate(radians(-60));
            line(0, 0, p.x/2, p.y/2); 
            popMatrix();
        }
    }
}

void addUndo(PVector pos, Node node)
{
    if (undoStates.size() < 10)
    {
        undoStates.add(new undoState(node, pos));
    }
    else
    {
        undoStates.remove(0);
        undoStates.add(new undoState(node, pos));  
    }
}

void undo()
{
    if (undoStates.size() > 0)
    {
        undoState s = undoStates.get(undoStates.size()-1);
        s.node.setPosition(s.getPosition());
        undoStates.remove(s);
    }
}

void saveNetwork()
{
    if (!savedChanges)
    {
        if (saveFile == null)
        {
            selectOutput("Save Network As...", "saveJSON");
        }
        else
        {
            int selectedOption = JOptionPane.showConfirmDialog(null, 
                "Save changes to " + saveFile.getName().substring(0, (saveFile.getName().indexOf('.'))) + 
                "?", "Overwrite file", JOptionPane.YES_NO_OPTION);
           
            if (selectedOption == JOptionPane.YES_OPTION) 
            {
                saveJSON(saveFile);
            }
        }
    }
}

void loadNetwork()
{
    if (!savedChanges)
    {
        int selectedOption = JOptionPane.showConfirmDialog(null, "Save changes before importing a new network?\nLoading a new network will erase the current one.",
                "Save Network", JOptionPane.YES_NO_OPTION); 
               
        if (selectedOption == JOptionPane.YES_OPTION)
        {   
            if (saveFile != null)
            {
                saveJSON(saveFile);
            }
            else
            {
                selectOutput("Save Network As...", "saveJSON");
            }
        }
        selectInput("Select a JSON file to import from:", "loadJSON");
    }
    else
    {
        selectInput("Open A Network...", "loadJSON");
    }
}

void resetNetwork()
{
    if (!savedChanges)
    {
        int selectedOption = JOptionPane.showConfirmDialog(null, "Save changes before reseting?",
            "Reset", JOptionPane.YES_NO_CANCEL_OPTION); 
           
        if (selectedOption == JOptionPane.YES_OPTION) 
        {            
            if (saveFile != null)
            {
                saveJSON(saveFile);
            }
            else
            {
                selectOutput("Save Network As...", "saveJSON");
            }
            saveFile = null;
            
            number = 0;
            network.nodes.clear();
            network.links.clear();
            savedChanges = true;
        }
        else if (selectedOption == JOptionPane.NO_OPTION)
        {
            saveFile = null;
            number = 0;
            network.nodes.clear();
            network.links.clear();
            savedChanges = true;
        }
    }
    else
    {
        saveFile = null;
        number = 0;
        network.nodes.clear();
        network.links.clear();
        savedChanges = true;
    }
}

void displayProperties(Node node)
{
    if (node.atom.getType().equals("Sensory"))
    {
        String text = "Sensors:";
        
        text(text, node.position.x + 10, node.position.y - 10);
    }
    else if (node.atom.getType().equals("Motor"))
    {  
        MotorAtom atom = (MotorAtom) node.atom;
        
        String text = "Motors:        Parameters:";
        String motor = null;
        for (int i=0; i<atom.motors.size(); i++)
        {
            motor = null;
            if ((motor = atom.motors.get(i)) != null) 
            {
                println("Motor...");
                motor = atom.motors.get(i);
                text += motor;
            }
            if (atom.getParameters().size() <= i)
            {
                println("Parameter...");
                String parameter = atom.getParameters().toArray()[i].toString();
                //Spacers
                if (motor != null) {for (int s=0; s<15; s++) {text += " ";}}
                else {for (int s=0; s<(15-motor.length()); s++) {text += " ";}}
                text += parameter;
            }
            text += "\n";
        }
        
        text(text, node.position.x + 10, node.position.y - 10);
    }
    else if (node.atom.getType().equals("Game"))
    {
        GameAtom atom = (GameAtom) node.atom;
        String text = "States:\n";
        for (String state : atom.getPrintableStates())
        {
            if (state != null)
            {
                text += state + "\n";
            }
        }
        text(text, node.position.x + 10, node.position.y - 10);
    }
    else if (node.atom.getType().equals("Transform"))
    {
        TransformAtom atom = (TransformAtom) node.atom;
        String text = "Parameters:\n";
        for (String parameter : atom.getParameters())
        {
            text += parameter;
            if (!(parameter.equals(atom.getParameters().toArray()[atom.getParameters().size()-1])))
            {text += "\n";}
        }
        
        text(text, node.position.x + 10, node.position.y - 10);
    }
}
