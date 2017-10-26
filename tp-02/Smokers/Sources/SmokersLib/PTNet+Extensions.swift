import PetriKit

public class MarkingGraph {

    public let marking   : PTMarking
    public var successors: [PTTransition: MarkingGraph]

    public init(marking: PTMarking, successors: [PTTransition: MarkingGraph] = [:]) {
        self.marking    = marking
        self.successors = successors
    }
    // Counts the number of states in a tagging graph from a node 
    public func countMark(input:MarkingGraph) -> Int{
      var visitedNode: [MarkingGraph] = []
      var nodeToVisit: [MarkingGraph] = [input]

      while let current = nodeToVisit.popLast(){
        visitedNode.append(current)
        for (_, successor) in current.successors{
          if !visitedNode.contains(where: {$0 === successor}) && !nodeToVisit.contains(where: {$0 === successor}){
            nodeToVisit.append(successor)
          }
        }
      }
      return visitedNode.count
    }
    // Lets you know if there are two smokers in the graph 
    public func isTwoSmokers(input:MarkingGraph) -> Bool{
      var visitedNode: [MarkingGraph] = []
      var nodeToVisit: [MarkingGraph] = [input]

      while let current = nodeToVisit.popLast(){
        visitedNode.append(current)
        for (place, token) in current.marking{
          var nbSmoke = 0;
          for (place, token) in current.marking {
            if (place.name == "s1" || place.name == "s2" || place.name == "s3"){
              nbSmoke += Int(token)
            }
          }
          if (nbSmoke > 1) {
            return true
          }
        }
        for (_, successor) in current.successors{
          if !visitedNode.contains(where: {$0 === successor}) && !nodeToVisit.contains(where: {$0 === successor}){
            nodeToVisit.append(successor)
          }
        }
      }
      return false
    }
    // Lets find out if two ingredients are on the table 
    public func isTwoIng(input:MarkingGraph) -> Bool{
      var visitedNode: [MarkingGraph] = []
      var nodeToVisit: [MarkingGraph] = [input]

      while let current = nodeToVisit.popLast(){
        visitedNode.append(current)
        for (place, token) in current.marking{
          if place.name == "p" || place.name == "m" || place.name == "t"{
            if(token > 1){
                 return true
            }
          }
        }
        for (_, successor) in current.successors{
          if !visitedNode.contains(where: {$0 === successor}) && !nodeToVisit.contains(where: {$0 === successor}){
            nodeToVisit.append(successor)
          }
        }
      }
      return false
    }

}

public extension PTNet {
  public func markingGraph(from marking: PTMarking) -> MarkingGraph? {
      // Write here the implementation of the marking graph generation.
      // Initialize values
      let m0 = MarkingGraph(marking: marking)
      var nodeToVisit : [MarkingGraph] = [m0]
      var visitedNode : [MarkingGraph] = []
      // Close the list to visit
      while(!nodeToVisit.isEmpty) {
          let cur = nodeToVisit.remove(at:0)
          visitedNode.append(cur)
          // Loop transitions
          for tran in transitions {
              if let firedMark = tran.fire(from: cur.marking) {
                      if let alreadyVisitedNode = visitedNode.first(where: { $0.marking == firedMark }) {
                          cur.successors[tran] = alreadyVisitedNode
                      } else {
                          let temp = MarkingGraph(marking: firedMark)
                          cur.successors[tran] = temp
                          if (!nodeToVisit.contains(where: { $0.marking == temp.marking})) {
                              nodeToVisit.append(temp)
                          }
                  }
              }
          }
      }
      return m0
  } }
