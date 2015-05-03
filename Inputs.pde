/**
 *  Inputs
 *    Contains the extended main code to react to mouse and keyboard events
 *
 *  Alex Broadbent | 10/08/2013
**/
void mousePressed()
{
    if (mouseButton == LEFT)
    {
        clickTime = millis();
        
        //Check if mouse is clicking a menu node
        if (mouseX < 390 && mouseY <80)
        {
            nodeType = null;
            for (MenuItem item : menuItems)
            {
                if ((((item.getImagePosition().x - 20) < mouseX) && ((item.getImagePosition().x + 20) > mouseX)) &&
                        (((item.getImagePosition().y - 20) < mouseY) && ((item.getImagePosition().y + 20) > mouseY)))
                {
                    nodeType = item.getName();
                    offSet = new PVector(item.getImagePosition().x - mouseX, item.getImagePosition().y - mouseY);
                }
            }
      
            if (nodeType != null)
            {                
                newAtom = null;
                newNode = null;
        
                if (nodeType.equals("Base"))
                {
                    newAtom = new Atom();
                }
                else if (nodeType.equals("Sensor"))
                {
                    newAtom = new SensorAtom();
                }
                else if (nodeType.equals("Motor"))
                {
                    newAtom = new MotorAtom();
                }
                else if (nodeType.equals("Game"))
                {
                    newAtom = new GameAtom();
                }
                else if (nodeType.equals("Transform"))
                {
                    newAtom = new TransformAtom();
                }
                //NAO ATOMS
                else if (nodeType.equals("NAO Sensor"))
                {
                    newAtom = new Atom();
                }
                else if (nodeType.equals("SHCLt Internal Sensor"))
                {
                    newAtom = new Atom();
                }
                else if (nodeType.equals("NAO Motor"))
                {
                    newAtom = new Atom();
                }
                //ARDUINO ATOMS
                else if (nodeType.equals("Base Sensor"))
                {
                    newAtom = new Atom();
                }
                else if (nodeType.equals("Data Sensor"))
                {
                    newAtom = new Atom();
                }
                else if (nodeType.equals("Arduino Motor"))
                {
                    newAtom = new Atom();
                }
                
                //Display Node
                fill(newAtom._color);
                ellipse(mouseX, mouseY, 40, 40);
                
                //Create Node and add to Network
                newNode = new Node("" + getNumber(), mouseX, mouseY, 20.0, newAtom);
                network.addNode(newNode);
                drawn = true;
        
                //Make node draggable
                selected = newNode.getID();            
                hold = true;
                holdNode = newNode;
                created = true;
                holdNode.atom.active = true;
                
                //Deselect any link (just in case)
                selectedLink = null;
            }
        }
        else
        {
            if (network.numNodes() > 0)
            {
                //Check if mouse is clicking a node
                for (Node node : network.nodes)
                {
                    if (node.mouseOvered() && !hold)
                    {
                        //Set dragging variables
                        selected = node.getID();                
                        hold = true;
                        holdNode = node;
                        holdNode.atom.active = true;                    
                        offSet = new PVector(holdNode.position.x-mouseX, holdNode.position.y-mouseY);
                        
                        //Deselect any link (just in case)
                        selectedLink = null;
              
                        //Set old position for undo function
                        addUndo(new PVector(holdNode.position.x, holdNode.position.y), node);
              
                        //Check double click
                        if (mouseEvent.getClickCount() == 2)
                        {
                            if (app != null)
                            {
                                println("Close the properties box first");
                                if (!app.focused)
                                {
                                    app.requestFocus();
                                }
                            }
                            else if (node.atom.getType().equals("Base"))
                            {
                                //No variables for base types
                                node.atom.active = false;
                            }
                            else
                            {
                                createMenuWindow(node);
                            }
                        }
                    }
                    else
                    {
                        node.atom.active = false;
                    }
                }
            }
            
            if (network.numLinks() > 0 && app == null)
            {
                boolean nothingSelected = true;
                //Check if link is being clicked
                for (Link link : network.links)
                {
                    if (link.selected())
                    {
                        selectedLink = link;
                        nothingSelected = false;                        
                        //createLinkWindow(link);
                    }
                }
                
                if (nothingSelected) {selectedLink = null;}
            }
        }
    }
  
    if (mouseButton == RIGHT)
    {
        if (linkNode1 == null)
        {
            //Save clicked node as link1 (From Node)
            linkNode1 = network.getNodeFromClick(mouseX, mouseY);
            
            if (linkNode1 != null)
            {
                linkNode1.atom.active = true;
            }
        }
      else if (linkNode2 == null)
      {
          //Get second node, nodeTo
          linkNode2 = network.getNodeFromClick(mouseX, mouseY);
          
          //Draw arrow
          if (linkNode2 != null)
          {
              Float distDelay;
              if (!linkNode2.equals(linkNode1))
              {
                  //Create delay based on the distance of the two nodes - convert range from 800x600 to a range of 0-2
                  distDelay = (dist(linkNode1.position.x, linkNode1.position.y, linkNode2.position.x, linkNode2.position.y) * 2) / 1000;
                  distDelay = Float.valueOf(new java.text.DecimalFormat("#.##").format(distDelay));
              }
              else {distDelay = 0.2;}
              
              //Add new link to Network Links -- From: linkNode1 - To: linkNode2
              network.addLink(new Link(linkNode1, linkNode2, distDelay));
      
              //Clear both linking node variables
              linkNode1.atom.active = false;
              linkNode1 = null;
              linkNode2 = null;
      
              savedChanges = false;
          }
          else
          {
              //Cancel link operation
              linkNode1.atom.active = false;
              linkNode1 = null;
              selected = null;
          }
        }
     }
}

void mouseDragged()
{
    if (hold)
    {
        //Stop nodes going into menu bar or off the screen
        if (created)
        {
            holdNode.position.x = mouseX + offSet.x;
            holdNode.position.y = mouseY + offSet.y;
      
            //Out of menu area - don't let it back in
            if (holdNode.position.y > (80 + holdNode.radius))
            {
                created = false;
            }
        }
        else
        {
            holdNode.position.x = mouseX + offSet.x;
            holdNode.position.y = mouseY + offSet.y;
            
            //Stop the node going off screen
            if (holdNode.position.y < (80 + holdNode.radius))
            {
                holdNode.position.y = 85 + holdNode.radius;
                hold = false;
                holdNode.atom.active = false;
            }
            if (holdNode.position.x < holdNode.radius)
            {
                holdNode.position.x = 5 + holdNode.radius;
                hold = false;
                holdNode.atom.active = false;
            }
            if (holdNode.position.x > width - holdNode.radius)
            {
                holdNode.position.x = width - holdNode.radius - 5;
                hold = false;
                holdNode.atom.active = false;
            }
            if (holdNode.position.y > height - (85 + holdNode.radius))
            {
                holdNode.position.y = height - holdNode.radius - 85;
                hold = false;
                holdNode.atom.active = false;
            }
      
            //Unsaved changes have been made
            savedChanges = false;
        }
    }
}

void mouseReleased()
{
    clickLength = millis() - clickTime;
    
    if (created)
    {
        //If new atom is released within the menu area then delete it
        if (holdNode.position.y < (80+holdNode.radius))
        {
            network.removeNode(holdNode);
            holdNode = null;
            hold = false;
            selected = null;
            offSet = null;
            
            created = false;
        }
    }
  
    if (hold)
    {
        hold = false;
    }
  
    //Clear 
    if (holdNode != null)
    {
        //Check if not moved or selected - using time as a factor
        if (undoStates.size() > 0)
        {
            if (undoStates.get(undoStates.size()-1).node != holdNode || 
                (undoStates.get(undoStates.size()-1).position.x != holdNode.position.x || 
                 undoStates.get(undoStates.size()-1).position.y != holdNode.position.y))
            {
                holdNode.atom.active = false;
                holdNode = null;
                selected = null;
            }
        }
        else if (clickLength > 250)
        {
            holdNode.atom.active = false;
            holdNode = null;
            selected = null;
        }
    }
    drawn = false;
}

boolean checkKey(int k)
{
    if (keys.length >= k) 
    {
        return keys[k];  
    }
    return false;
}

void keyPressed()
{
    keys[keyCode] = true;
    
    if (checkKey(CONTROL) && checkKey(KeyEvent.VK_S))
    {
        saveNetwork();
    }
    else if (checkKey(CONTROL) && checkKey(KeyEvent.VK_O))
    {
        loadNetwork();
    }
    else if (checkKey(CONTROL) && checkKey(KeyEvent.VK_Z))
    {
        if (undoStates.size() > 0)
        {
            undo();        
            savedChanges = false;
        }
    }
    else if (checkKey(CONTROL) && checkKey(KeyEvent.VK_P))
    {
        createOptionsMenu();
    }
    else if (checkKey(CONTROL) && checkKey(KeyEvent.VK_R))
    {
        resetNetwork();
    }
    else if (checkKey(CONTROL) && checkKey(SHIFT) && checkKey(KeyEvent.VK_S))
    {
        saveFile = null;
        selectOutput("Select a JSON file to export to:", "saveJSON");
    }
    else
    {
        //Operation Keys
        if (key == DELETE)
        {
            //Delete a Node
            if (!network.nodes.isEmpty() && holdNode != null)
            {
                int selectedOption = JOptionPane.showConfirmDialog(null, "Are you sure you want to delete this node?",
                                                                   "Confirm Deletion", JOptionPane.YES_NO_CANCEL_OPTION); 
               
                if (selectedOption == JOptionPane.YES_OPTION) 
                {            
                    network.removeNode(holdNode);
                
                    holdNode = null;
                    hold = false;
                    selected = null;
                    offSet = null;
                    
                    savedChanges = false;
                }
            }
            //Delete a Link
            else if (selectedLink != null)
            {
                network.removeLink(link);
            }
        }
    }
}

void keyReleased()
{
    keys[keyCode] = false;
    keys[CONTROL] = false;
}

public void controlEvent(ControlEvent theEvent) 
{    
    if (theEvent.getController().getName().equals("Save Network"))
    {
        saveNetwork();
    }
    if (theEvent.getController().getName().equals("Load Network"))
    {
        loadNetwork();
    }
    if (theEvent.getController().getName().equals("Run"))
    {
        println("Running...");
    }
    if (theEvent.getController().getName().equals("Add Molecule"))
    {
        if (app != null)
        {
            //listMolecules();
        }
    }
    if (theEvent.getController().getName().equals("Options..."))
    {
        createOptionsMenu();
    }
}
