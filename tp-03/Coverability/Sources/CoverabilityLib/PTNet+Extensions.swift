import PetriKit

public extension PTNet {

    // Turns a mark for the cover graph into a pullable mark
    public func convToPT(with marking : CoverabilityMarking, and p : [PTPlace]) -> PTMarking{
      var m : PTMarking = [:]

      for temp in p
      {
        let this = correctValue(to : marking[temp]!)!
        m[temp] = this
      }
      return m
    }

    // Turns a markable mark into a mark for the cover graph
    public func ptToConv(with marking: PTMarking, and p : [PTPlace]) ->CoverabilityMarking{
      var temp : CoverabilityMarking = [:]
      for val in p
      {
        temp[val] = .some(marking[val]!)
        if(500 < temp[val]!)
        {
          temp[val] = .omega
        }
      }
      return temp
    }

    //Correct errors that allow the draw (the presence of the omega)
    public func correctValue(to t: Token) -> UInt? {
      if case .some(let value) = t {
        return value
      }
      else {
        return 1000
      }
    }

    //Check if a node is contained in the list
    public func verify(at marking : [CoverabilityMarking], to markingToAdd : CoverabilityMarking) -> Int
    {
      var value = 0
      for i in 0...marking.count-1
      {
        if (marking[i] == markingToAdd)
        {
          value = 1
        }
        if (markingToAdd > marking[i])
        {
          value = i+2}
      }
      return value
    }

    // Add omega as a token if necessary
    public func convertOmega(from comp : CoverabilityMarking, with marking : CoverabilityMarking, and p : [PTPlace])  -> CoverabilityMarking?
    {
      var temp = marking
      for t in p
      {
        if (comp[t]! < temp[t]!)
        {
          temp[t] = .omega
        }
      }
      return temp
    }

    public func coverabilityGraph(from marking0: CoverabilityMarking) -> CoverabilityGraph? {
        // Write here the implementation of the coverability graph generation.
        // Note that CoverabilityMarking implements both `==` and `>` operators, meaning that you
        // may write `M > N` (with M and N instances of CoverabilityMarking) to check whether `M`
        // is a greater marking than `N`.
        // IMPORTANT: Your function MUST return a valid instance of CoverabilityGraph! The optional
        // print debug information you'll write in that function will NOT be taken into account to
        // evaluate your homework.

        //// transform into sets array transitions and places
        var transitionsC = Array (transitions) 
        transitionsC.sort{$0.name < $1.name}
        let placesC = Array(places)
        
        var markingList : [CoverabilityMarking] = [marking0]
        var graphList : [CoverabilityGraph] = []
        var this: CoverabilityMarking
        let returnedGraph = CoverabilityGraph(marking: marking0, successors: [:])
        var count = 0

        // Main loop that stops when count is greater than the size of the list of markings
        while(count < markingList.count)
        {
          
          for tran in transitionsC{
            
            let ptMarking = convToPT(with: markingList[count], and: placesC)
            if let firedTran = tran.fire(from: ptMarking){
                                 // Converted to marking for the cover graph
              let convMarking = ptToConv(with: firedTran, and: placesC)
                                // create the marking node
              let nouvCouv = CoverabilityGraph(marking: convMarking, successors: [:])
                                  // Add the new node to the successor
              returnedGraph.successors[tran] = nouvCouv
            }
            
            if(returnedGraph.successors[tran] != nil){
                              // add his markup to the variable this
              this = returnedGraph.successors[tran]!.marking
                              // We check if it is contained in the list
              let cur = verify(at: markingList, to: this)
              if (cur != 1)
              {
                if (cur > 1)
                {
                  this = convertOmega(from : markingList[cur-2], with : this, and : placesC)!
                }
                 // Add node to the list
                graphList.append(returnedGraph)
                
                markingList.append(this)
              }
            }
          }
          count = count + 1
        }
        return returnedGraph
      }
}