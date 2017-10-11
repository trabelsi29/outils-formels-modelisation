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

let m1 = create.fire(from: [taskPool: 0, processPool: 0, inProgress: 0])
print("m1 (create) ",m1!)
let m2 = spawn.fire(from: m1!)
print("m2 (spawn) ",m2!)
let m3 = spawn.fire(from: m2!)
print("m3 (spawn)",m3!) 

// m1 - m3 : creation d 1 jeton dans taskPool, et 2 jetons dans processPool

let m4 = exec.fire(from: m3!)
print("m4 (exec) ",m4!)
let m5 = exec.fire(from: m4!)
print("m5 (exec)",m5!) 
// m4 - m5 : execution deux fois est possible, vu le nombre de jetons
let m6 = success.fire(from: m5!)
print("m6 (success) ",m6!) // Transition:  success

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
let m21 = create2.fire(from: [taskPool2: 0, processPool2: 0, inProgress2: 0, PlaceSec: 0])
print("m1 (create) ",m21!)
let m22 = spawn2.fire(from: m21!)
print("m2 (spawn) ",m22!)
let m23 = spawn2.fire(from: m22!)
print("m3 (spawn)",m23!) // m1 - m3 : crée 1 jeton dans taskPool et 2 dans processPool comme auparavant
let m24 = exec2.fire(from: m23!)
print("m4 (exec) ",m24!) // m4 : Dans ce nouveau cas, une seule exécution est possible
let m25 = success2.fire(from: m24!)
print("m5 (success) ",m25!) // Transition:  success
let m27 = fail2.fire(from: m24!)
print("m5 (fail) ",m27!) //  "fail"
// La correction cest par le blocage de l'exécution 1 task/1 process
// et par la creation d'une nouvelle place  "PlaceSec"
// Donc au final on envoie qu'un seul jeton a "exec"
