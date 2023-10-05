import argparse
import random as rand
from dataclasses import dataclass
from typing import List, Tuple


class Formatter:
    def __init__(self):
        self.objects = {}
        self.init = []

    def add_objects(self, type: str, elements: List[str]):
        self.objects[type] = elements

    def add_init_function(self, name: str, value: int, element: str = ""):
        self.init.append(
            f"(= ({name}{' '+element if element != '' else ''}) {value})")

    def add_init_elements(self, name: str, elements: List[str]):
        self.init.append(f"({name} {' '.join(elements)})")

    def generate_objects(self, numSep: int = 8):
        sep = f"\n" + " ".join(['' for _ in range(numSep)])
        output = ""
        for key in self.objects.keys():
            output += sep + " ".join(self.objects[key]) + " - " + key
        return output

    def generate_inits(self, numSep: int = 8):
        sep = f"\n" + " ".join(['' for _ in range(numSep)])
        output = sep + sep.join(self.init)
        return output

    def generate(self) -> str:
        return f'''
(define (problem Problema0) (:domain VidaEnMarte_Extension1)
    (:objects {self.generate_objects()}
    ) 

    (:init {self.generate_inits()} 
    )

    (:goal (or (forall (?p - peticion) (Servida ?p)) (= (recursosDisponibles) 0)))
    (:metric maximize (+ (* (prioridadTotal) 5) (* (combusibleTotal) 2)))
)
'''


@dataclass
class Node:
    name: str
    elements: List[str]


@dataclass
class Peticion:
    name: str
    contenido: str
    destino: str
    prioridad: int


def create_graph(asentamientos: List[str], almacenes: List[str]) -> Tuple[List[Node], List[List[bool]]]:
    numAsentamientos = len(asentamientos)
    numAlmacenes = len(almacenes)

    numVertexs = numAsentamientos + numAlmacenes

    # Crear matriz N x N, donde true significa que existe una conexión entre los dos vértices
    matrix = [[False for _ in range(numVertexs)]
              for _ in range(numVertexs)]

    nodes = [Node(name, []) for name in asentamientos + almacenes]

    for v in range(numVertexs):
        num = rand.randint(2, numVertexs-2)

        while num > 0:
            u = rand.randint(0, numVertexs-2)
            if not matrix[v][u] and v != u:
                matrix[v][u] = True
                num -= 1

    return nodes, matrix


class Problem:
    def __init__(self, numRovers: int, numPersonal: int, numSuministro: int, numAsentamientos: int, numAlmacenes: int, numPeticiones: int):
        self.rovers = [f"rover{i}" for i in range(numRovers)]
        self.personal = [f"personal{i}" for i in range(numPersonal)]
        self.suministros = [f"suministro{i}" for i in range(numSuministro)]
        self.asentamientos = [
            f"asentamiento{i}" for i in range(numAsentamientos)]
        self.almacenes = [f"almacen{i}" for i in range(numAlmacenes)]

        self.nodes, self.matrix = create_graph(
            self.asentamientos, self.almacenes)

        # Position rovers
        for rover in self.rovers:
            id = rand.randint(0, len(self.nodes)-1)
            self.nodes[id].elements.append(rover)

        # Position personal
        for persona in self.personal:
            id = rand.randint(0, numAsentamientos-1)
            self.nodes[id].elements.append(persona)

        # Position suministros
        for suministro in self.suministros:
            id = rand.randint(0, numAlmacenes-1)
            self.nodes[numAsentamientos + id].elements.append(suministro)

        # Generate petitions
        self.peticiones = []
        opciones = self.personal.copy() + self.suministros.copy()
        i = 0
        while i < numPeticiones:
            opcion = rand.choice(opciones)
            asentamiento = rand.choice(self.asentamientos)
            id = self.asentamientos.index(asentamiento)

            if opcion not in self.nodes[id].elements:
                self.peticiones.append(
                    Peticion(f"id{i}", opcion, asentamiento, rand.randint(1, 3)))
                opciones.remove(opcion)
                i += 1

    def print(self) -> str:
        formatter = Formatter()

        # Objects
        formatter.add_objects("rover", self.rovers)
        formatter.add_objects("personal", self.personal)
        formatter.add_objects("suministro", self.suministros)
        formatter.add_objects("asentamiento", self.asentamientos)
        formatter.add_objects("almacen", self.almacenes)
        formatter.add_objects(
            "peticion", [pet.name for pet in self.peticiones])

        # (= (recursosDisponibles) 8)
        formatter.add_init_function("recursosDisponibles", 8)

        # personalEnRover, suministrosEnRover & combustibleEnRover
        COMBUSTIBLE_BASE = 8
        for rover in self.rovers:
            formatter.add_init_function("personalEnRover", 0, rover)
            formatter.add_init_function("suministrosEnRover", 0, rover)
            formatter.add_init_function(
                "combustibleEnRover", str(COMBUSTIBLE_BASE), rover)

        # combustibleTotal
        formatter.add_init_function(
            "combusibleTotal", COMBUSTIBLE_BASE * len(self.rovers))

        # prioridadTotal
        formatter.add_init_function("prioridadTotal", 0)

        # Prioridad Peticiones
        for peticion in self.peticiones:
            formatter.add_init_function(
                "prioridad", peticion.prioridad, peticion.name)

        # Conexion nodos
        for row in range(len(self.matrix)):
            for col in range(len(self.matrix)):
                if self.matrix[row][col]:
                    formatter.add_init_elements(
                        "Conecta", [self.nodes[row].name, self.nodes[col].name])

        # Información nodos
        for node in self.nodes:
            for element in node.elements:
                if "rover" in element:
                    formatter.add_init_elements(
                        "Estacionado", [element, node.name])
                else:
                    formatter.add_init_elements("En", [element, node.name])

        # Información peticiones
        for peticion in self.peticiones:
            formatter.add_init_elements(
                "ContenidoPeticion", [peticion.name, peticion.contenido])
            formatter.add_init_elements(
                "DestinoPeticion", [peticion.name, peticion.destino])

        return formatter.generate()


if __name__ == "__main__":
    parser = argparse.ArgumentParser()

    parser.add_argument("-r", "--rovers", default=4, help="Número de rovers")
    parser.add_argument("-pe", "--personal", default=10,
                        help="Número de personal")
    parser.add_argument("-s", "--suministro", default=6,
                        help="Número de suministros")
    parser.add_argument("-as", "--asentamientos", default=4,
                        help="Número de asentamientos")
    parser.add_argument("-al", "--almacenes", default=2,
                        help="Número de almacenes")
    parser.add_argument("-p", "--peticiones", default=6,
                        help="Número de peticiones")

    args = parser.parse_args()

    problem = Problem(int(args.rovers), int(args.personal), int(args.suministro),
                      int(args.asentamientos), int(args.almacenes), int(args.peticiones))
    s = problem.print()
    print(s)
