/**
 *  Network Class
 *    Contains a list of nodes and links.
 *
 *  Alex Broadbent | 10/08/2013
**/


class Network
{
    //Variables
    private ArrayList<Node> nodes;
    private ArrayList<Link> links;
  
  
    //Constructor
    public Network()
    {
         nodes = new ArrayList<Node>();
         links = new ArrayList<Link>();
    }
    
    
    //Getters and Setters
    public ArrayList<Node> getNodes()
    {
        return nodes;
    }
    
    public void setNodes(ArrayList<Node> _nodes)
    {
        nodes = _nodes;
    }
    
    public ArrayList<Link> getLinks()
    {
        return links;
    }
    
    public void setLinks(ArrayList<Link> _links)
    {
        links = _links;
    }
    
    
    //Methods
    public void addNode(Node _node)
    {
        nodes.add(_node);
    }
    
    public void removeNode(Node _node)
    {
        //Remove Associated Links
        _node.atom.removeAllLinks();
        Link[] linkArray = links.toArray(new Link[0]);
        for (Link link : linkArray)
        {
            if (link.contains(_node))
            {
                removeLink(link);
            }
        }
        nodes.remove(_node);
    }

    public void addLink(Link _link)
    {
        //Check for a duplicate link before adding, if duplicate exists then remove link
        boolean duplicate = false;
        Link[] linkA = links.toArray(new Link[0]);
        for (Link link : linkA)
        {
            if (link.getNodeFrom().equals(_link.getNodeFrom()) && link.getNodeTo().equals(link.getNodeTo()) && link.getBidirectional())
            {
                link.setBidirectional(false);
                duplicate = true;
            }
            else if (link.getNodeFrom().equals(_link.getNodeTo()) && link.getNodeTo().equals(_link.getNodeFrom()) && link.getBidirectional())
            {
                removeLink(link);
            }
            else if (link.getNodeTo().equals(_link.getNodeTo()) && link.getNodeFrom().equals(_link.getNodeFrom()))
            {
                removeLink(link);
                links.remove(link);
                duplicate = true;
            }
            else if (link.getNodeFrom().equals(_link.getNodeTo()) && link.getNodeTo().equals(_link.getNodeFrom()))
            {
                link.setBidirectional(true);
                duplicate = true;
            }
        }
        
        if (duplicate == false)
        {
            links.add(_link);
        }
    }
    
    public void removeLink(Link _link)
    {
        Node n1 = _link.nodeFrom;
        Node n2 = _link.nodeTo;
        
        n1.atom.removeLink(n2.atom.getID());
        n2.atom.removeLink(n1.atom.getID());
    }
    
    public Node getNode(String id)
    {
        for (Node node : nodes)
        {
            if (node.atom.getID().equals(id))
            {
                return node;
            }
        }
        return null;
    }
        
    
    //Additional Methods
    public boolean intercept(Node _node)
    {
        
        for (Node node : nodes)
        {
            if (!node.equals(_node))
            {
                //If distance is less than the sum of radii then circles don't intercept
                double distance = Math.sqrt(Math.pow(node.position.y - _node.position.y, 2) +
                  Math.pow(node.position.x - _node.position.x, 2));                
              
                if ((node.radius + _node.radius) > distance)
                {
                    return true;
                }
            }
        }
        return false;
    }
    
    public Node getNodeFromClick(int _x, int _y)
    {
        for (Node node : nodes)
        {
            if ((((node.position.x - node.radius) < _x) && ((node.position.x + node.radius) > _x)) 
              && (((node.position.y - node.radius) < _y) && ((node.position.y + node.radius) > _y)))
            {
                return node;
            }
        }        
        return null;
    }
    
    public int numNodes()
    {
        return nodes.size();
    }
    
    public int numLinks()
    {
        return links.size();
    }
    
        
    //Creates links for each node's atom - mainly used when importing network
    public void createLinkNetwork(String[][] linksToProcess, Float[] delaysToProcess, boolean[] bidirsToProcess)
    {
        int counter = 0; boolean bidir = false;
        while (linksToProcess[counter][0] != null && linksToProcess[counter][1] != null)
        {
            bidir = false;
            String nodeIDFrom = linksToProcess[counter][0];
            String nodeIDTo = linksToProcess[counter][1];
            Float delay = delaysToProcess[counter];
            boolean bidir = bidirsToProcess[counter];
            
            if (nodeIDFrom != null && nodeIDTo != null)
            {                
                if (bidir)
                {
                    addLink(new Link(getNode(nodeIDFrom), getNode(nodeIDTo), delay, true));
                }
                else
                {
                    addLink(new Link(getNode(nodeIDFrom), getNode(nodeIDTo), delay));
                }
            }
            
            counter++;
        }
    }
    
    
    //Output whole network to JSON
    public JSONObject toJSON()
    {
        JSONObject network = new JSONObject();
        JSONArray nodesA = new JSONArray();
        
        int i=0;
        
        for (Node node : getNodes())
        {
            JSONObject jsonNode = new JSONObject();
            jsonNode.setJSONObject("node", node.toJSON());
            nodesA.setJSONObject(i, jsonNode); i++;
        }        
        network.setJSONArray("network", nodesA);
        
        return network;
    }
}
