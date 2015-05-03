/**
 *    Link Menu
 *      Contains the code to display a menu window to change the 
 *      variable delay of a given Link.
 *
 *    Alex Broadbent | 30/08/2013
**/

GTextField newDelay;
GButton save;
GButton can;
GWindow win;
Link link;
Font font = new Font("Serif", Font.PLAIN, 11);

void createLinkWindow(Link _link)
{
    link = _link;
    
    PVector n1 = link.nodeFrom.position; PVector n2 = link.nodeTo.position;
    PVector mid = new PVector(n1.x+((n2.x-n1.x)/2), n1.y+((n2.y-n1.y)/2));
    
    win = new GWindow(this, "Change Link Delay", frame.getX()+(int)mid.x-50, frame.getY()+(int)mid.y-12, 100, 25, true, JAVA2D);
    app = win.papplet;
    
    newDelay = new GTextField(app, 0, 0, 30, 25);
    newDelay.addEventHandler(this, "handleDelayTextEvent");
    newDelay.setText(link.getDelay().toString());
    
    save = new GButton(app, 30, 0, 30, 25, "Save");
    save.addEventHandler(this, "handleSaveButtonEvent");
    save.setFont(font);
    save.setLocalColorScheme(G4P.GREEN_SCHEME);
    
    can = new GButton(app, 60, 0, 40, 25, "Cancel");
    can.addEventHandler(this, "handleCancelButtonEvent");
    can.setFont(font);
    can.setLocalColorScheme(G4P.RED_SCHEME);
}

public void handleDelayTextEvent(GTextField textF, GEvent event)
{
    if (event == GEvent.ENTERED)
    {
        Float d = Float.parseFloat(textF.getText());
        if (d != null)
        {
            link.setDelay(d);
        }
        
        savedChanges = false;
    }
}

public void handleSaveButtonEvent(GButton button, GEvent event)
{
    if (event == GEvent.CLICKED)
    {
        Float d = Float.parseFloat(newDelay.getText());
        if (d != null)
        {
            link.setDelay(d);
            savedChanges = false;
            
            win.forceClose();
            app = null;
        }
    }
}

public void handleCancelButtonEvent(GButton button, GEvent event)
{
    if (event == GEvent.CLICKED)
    {
        //Check if delay has been changed
        Float d = new Float(newDelay.getText());
        if ((d != null) && !(d.equals(link.getDelay())))
        {
            int selectedOption = JOptionPane.showConfirmDialog(null, "Save changes to the delay?",
                    "Confirm", JOptionPane.YES_NO_OPTION);
            
            if (selectedOption == JOptionPane.YES_OPTION) 
            {            
                link.setDelay(Float.valueOf(newDelay.getText()));
                savedChanges = false;
            }
            
            win.forceClose();
            app = null;
        }
        else
        {
            win.forceClose();
            app = null;
        }
    }
}
