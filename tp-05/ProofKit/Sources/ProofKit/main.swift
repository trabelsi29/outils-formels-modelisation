import ProofKitLib


do{
  let a: Formula = "a"
  let b: Formula = "b"
  let c: Formula = "c"

  let f = !(a && (b || c))
  print("2.1")
  print("Expression: \(f)")
  print("NNF: \(f.nnf)")
  print("CNF: \(f.cnf)")
  print("DNF: \(f.dnf)")
}
do{
  let a: Formula = "a"
  let b: Formula = "b"
  let c: Formula = "c"

  let f = (a => b) || !(a && c)
  print("2.2")
  print("Expression: \(f)")
  print("NNF: \(f.nnf)")
  print("CNF: \(f.cnf)")
  print("DNF: \(f.dnf)")
}
do{
  let a: Formula = "a"
  let b: Formula = "b"
  let c: Formula = "c"

  let f = (!a || b && c) && a
  print("2.3")
  print("Expression: \(f)")
  print("NNF: \(f.nnf)")
  print("CNF: \(f.cnf)")
  print("DNF: \(f.dnf)")
}
// ------
print("-----------\n")
let a: Formula = "a"
let b: Formula = "b"
let f = a && b

print(f)

let booleanEvaluation = f.eval { (proposition) -> Bool in
    switch proposition {
        case "p": return true
        case "q": return false
        default : return false
    }
}
print(booleanEvaluation)

enum Fruit: BooleanAlgebra {

    case apple, orange

    static prefix func !(operand: Fruit) -> Fruit {
        switch operand {
        case .apple : return .orange
        case .orange: return .apple
        }
    }

    static func ||(lhs: Fruit, rhs: @autoclosure () throws -> Fruit) rethrows -> Fruit {
        switch (lhs, try rhs()) {
        case (.orange, .orange): return .orange
        case (_ , _)           : return .apple
        }
    }

    static func &&(lhs: Fruit, rhs: @autoclosure () throws -> Fruit) rethrows -> Fruit {
        switch (lhs, try rhs()) {
        case (.apple , .apple): return .apple
        case (_, _)           : return .orange
        }
    }

}

let fruityEvaluation = f.eval { (proposition) -> Fruit in
    switch proposition {
        case "p": return .apple
        case "q": return .orange
        default : return .orange
    }
}
print(fruityEvaluation)