/**
 *  Link Class
 *    Contains code to join nodes together
 *
 *  Alex Broadbent | 10/08/2013
**/
 
class Link
{
    //Variables
    private Node nodeFrom;
    private Node nodeTo;
    private Float delay;
    private boolean bidirectional;
    
    //Contructor
    public Link(Node _nodeFrom, Node _nodeTo, Float _delay)
    {
        nodeFrom = _nodeFrom;
        nodeTo = _nodeTo;
        delay = _delay;
        bidirectional = false;
        
        //Add link to Atom code
        nodeTo.atom.addLinkTo(nodeFrom.atom.getID(), delay);
        nodeFrom.atom.addLinkFrom(nodeTo.atom.getID(), delay);
    }
    
    public Link(Node _nodeFrom, Node _nodeTo, Float _delay, boolean _bidirectional)
    {
        nodeFrom = _nodeFrom;
        nodeTo = _nodeTo;
        delay = _delay;
        bidirectional = _bidirectional;
        
        //Add link to Atom code
        nodeTo.atom.addLinkTo(nodeFrom.atom.getID(), delay);
        nodeFrom.atom.addLinkFrom(nodeTo.atom.getID(), delay);
    }
    
    //Getters and Setters
    public Node getNodeFrom()
    {
        return nodeFrom;
    }
    
    public void setNodeFrom(Node _nodeFrom)
    {
        nodeFrom = _nodeFrom;
    }
    
    public Node getNodeTo()
    {
        return nodeTo;
    }
    
    public void setNodeTo(Node _nodeTo)
    {
        nodeTo = _nodeTo;
    }
    
    public Float getDelay()
    {
        return delay;
    }
    
    public void setDelay(Float _delay)
    {
        delay = _delay;
    }
    
    public boolean getBidirectional()
    {
        return bidirectional;
    }
    
    public void setBidirectional(boolean di)
    {
        bidirectional = di;
    }
    
    //Methods
    public boolean contains(Node node)
    {
        if (nodeFrom.equals(node) || nodeTo.equals(node))
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    
    public boolean selected()
    {
        //Check to see if the mouse position is overlapping (or near) the link        
        int changeableWidth = 2;
        
        if (nodeTo.equals(nodeFrom))
        {
            //Draw a shape similar to the inside of the arc - close enough for now
            PVector bl = new PVector(nodeFrom.position.x - nodeFrom.radius + 4, nodeFrom.position.y - (nodeFrom.radius/2) + 1);
            PVector br = new PVector(nodeFrom.position.x + nodeFrom.radius - 4, nodeFrom.position.y - (nodeFrom.radius/2) + 1);
            PVector tl = new PVector(nodeFrom.position.x - nodeFrom.radius + 4, nodeFrom.position.y - nodeFrom.radius*1.6);
            PVector tr = new PVector(nodeFrom.position.x + nodeFrom.radius - 4, nodeFrom.position.y - nodeFrom.radius*1.6);
            PVector high = new PVector(nodeFrom.position.x, bl.y-(nodeFrom.radius*1.5));            
            PVector[] points = {bl, tl, high, tr, br};
            
            int i; int j;
            boolean result = false;
            for (i = 0, j = points.length - 1; i < points.length; j = i++)
            {
                if ((points[i].y > mouseY) != (points[j].y > mouseY) &&
                      (mouseX < (points[j].x - points[i].x) * (mouseY - points[i].y) / (points[j].y-points[i].y) + points[i].x)) {
                    result = !result;
                }
            }
            return result;
        }
        else
        {
            PVector p1 = new PVector(nodeFrom.position.x + changeableWidth, nodeFrom.position.y - changeableWidth);   //Top-right
            PVector p2 = new PVector(nodeFrom.position.x - changeableWidth, nodeFrom.position.y + changeableWidth);   //Top-left
            PVector p3 = new PVector(nodeTo.position.x + changeableWidth, nodeTo.position.y + changeableWidth);       //Bottom-right
            PVector p4 = new PVector(nodeTo.position.x - changeableWidth, nodeTo.position.y - changeableWidth);       //Bottom-left
            PVector[] points = {p1, p2, p3, p4};
            
            int i; int j;
            boolean result = false;
            for (i = 0, j = points.length - 1; i < points.length; j = i++)
            {
                if ((points[i].y > mouseY) != (points[j].y > mouseY) &&
                      (mouseX < (points[j].x - points[i].x) * (mouseY - points[i].y) / (points[j].y-points[i].y) + points[i].x)) {
                    result = !result;
                }
            }
            return result;
        }
    }
}
