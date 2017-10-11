import TaskManagerLib

// Partie 3
print("Ex3: Analyse du probleme"  )

let taskManager = createTaskManager()

// Creation des transitions et des places du taskManager

let create = taskManager.transitions.filter{$0.name == "create"}[0]
let spawn = taskManager.transitions.filter{$0.name == "spawn"}[0]
let exec = taskManager.transitions.filter{$0.name == "exec"}[0]
let success = taskManager.transitions.filter{$0.name == "success"}[0]
let fail = taskManager.transitions.filter{$0.name == "fail"}[0]

let taskPool = taskManager.places.filter{$0.name == "taskPool"}[0]
let processPool = taskManager.places.filter{$0.name == "processPool"}[0]
let inProgress = taskManager.places.filter{$0.name == "inProgress"}[0]

// Execution de la gestionnaire des taches

let t1 = create.fire(from: [taskPool: 0, processPool: 0, inProgress: 0])
print("t1 (create) ",t1!)
let t2 = spawn.fire(from: t1!)
print("t2 (spawn) ",t2!)
let t3 = spawn.fire(from: t2!)
print("t3 (spawn)",t3!) 

// t1 - t3 : creation d 1 jeton dans taskPool, et 2 jetons dans processPool

let t4 = exec.fire(from: t3!)
print("t4 (exec) ",t4!)
let t5 = exec.fire(from: t4!)
print("t5 (exec)",t5!) 
// t4 - t5 : execution deux fois est possible, vu le nombre de jetons
let t6 = success.fire(from: t5!)
print("t6 (success) ",t6!) // Transition:  success

// Un jeton est encore dans la place "inProgress" ce qui nous pose un probleme
// Parce que la tache possible c'est "fail", qui a été deja supprimee du taskPool




//Partie 4
print("Ex 4: Correction du probleme")
let correctTaskManager = createCorrectTaskManager()

// Creation des transitions et des places du taskManager
let create2 = correctTaskManager.transitions.filter{$0.name == "create"}[0]
let spawn2 = correctTaskManager.transitions.filter{$0.name == "spawn"}[0]
let exec2 = correctTaskManager.transitions.filter{$0.name == "exec"}[0]
let success2 = correctTaskManager.transitions.filter{$0.name == "success"}[0]
let fail2 = correctTaskManager.transitions.filter{$0.name == "fail"}[0]

let taskPool2 = correctTaskManager.places.filter{$0.name == "taskPool"}[0]
let processPool2 = correctTaskManager.places.filter{$0.name == "processPool"}[0]
let inProgress2 = correctTaskManager.places.filter{$0.name == "inProgress"}[0]
let PlaceSec = correctTaskManager.places.filter{$0.name == "PlaceSec"}[0]
//On ajoute une nouvelle place

// Execution de la gestionnaire des taches
let t21 = create2.fire(from: [taskPool2: 0, processPool2: 0, inProgress2: 0, PlaceSec: 0])
print("t1 (create) ",t21!)
let t22 = spawn2.fire(from: t21!)
print("t2 (spawn) ",t22!)
let t23 = spawn2.fire(from: t22!)
print("t3 (spawn)",t23!) // t1 - t3 : crée 1 jeton dans taskPool et 2 dans processPool comme auparavant
let t24 = exec2.fire(from: t23!)
print("t4 (exec) ",t24!) // t4 : Dans ce nouveau cas, une seule exécution est possible
let t25 = success2.fire(from: t24!)
print("t5 (success) ",t25!) // Transition:  success
let t27 = fail2.fire(from: t24!)
print("t5 (fail) ",t27!) //  "fail"
// La correction cest par le blocage de l'exécution 1 task/1 process
// et par la creation d'une nouvelle place  "PlaceSec"
// Donc au final on envoie qu'un seul jeton a "exec"
