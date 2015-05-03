/**
 *   UndoState
 *     Used to create a state of an undo operation
 *
 *   Alex Broadbent | 10/08/2013
**/

class undoState
{
    Node node;
    PVector position;
    //enum operation;
    
    public undoState(Node _node, PVector _position)
    {
        node = _node;
        position = _position;
    }
    
    public Node getNode()
    {
        return node;
    }
    
    public void setNode(Node _node)
    {
        node = _node;
    }
    
    public PVector getPosition()
    {
        return position;
    }
    
    public void setPosition(PVector _position)
    {
        position = _position;
    }
}
