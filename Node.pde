/**
 *  Node Class
 *    Contains the code for the Graph Nodes.
 *
 *  Alex Broadbent | 10/08/2013
**/
 
class Node
{
    //Variables
    private String id;
    private PVector position;
    private Float radius;    
    private Atom atom;
    
    
    //Constructor
    public Node(String _id, int _x, int _y, Float _radius, Atom _atom)
    {
        id = _id;
        position = new PVector(_x, _y);
        radius = _radius;
        atom = _atom;
    }
    
    
    //Getters and Setters
    public String getID()
    {
        return id;
    }
    
    public void setID(String _id)
    {
        id = _id;
    }
    
    public PVector getPosition()
    {
        return position;
    }
    
    public void setPosition(PVector _position)
    {
        position = _position;
    }
    
    public Float getRadius()
    {
        return radius;
    }
    
    public void setRadius(Float _radius)
    {
        radius = _radius;
    }
    
    
    //Methods
    public boolean mouseOvered() //Same thing as getNodeFromClick()...
    {
        if ((((position.x - radius) < mouseX) && ((position.x + radius) > mouseX)) 
              && (((position.y - radius) < mouseY) && ((position.y + radius) > mouseY)))
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    
    
    
    public String printNode()
    {
        String output = "ID=" + getID() + "\nPosition=(" + position.x + ", " + position.y + ")"+
          "\nRadius=" + getRadius() + "\n";
        output += "Atom:\n" + atom.printAtom();
        return output;
    }
    
    public JSONObject toJSON()
    {
        JSONObject jsonNode = new JSONObject();
        
        jsonNode.setString("nodeID", getID());
        jsonNode.setFloat("x", getPosition().x);
        jsonNode.setFloat("y", getPosition().y);
        jsonNode.setFloat("radius", getRadius());
        jsonNode.setJSONObject("atom", atom.toJSON());
        
        return jsonNode;
    }    
}
