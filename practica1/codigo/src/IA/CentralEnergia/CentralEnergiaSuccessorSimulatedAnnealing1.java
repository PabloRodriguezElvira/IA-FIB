package IA.CentralEnergia;

import IA.Energia.Central;
import aima.search.framework.Successor;
import aima.search.framework.SuccessorFunction;

import java.util.ArrayList;

public class CentralEnergiaSuccessorSimulatedAnnealing1 implements SuccessorFunction {

    public int getRandomNumber(int min, int max) {
        return (int) Math.floor(((Math.random() * (max - min + 1)) + min));
    }

    public ArrayList<Successor> getSuccessors(Object aState) {
        ArrayList<Successor> retVal = new ArrayList<>();
        CentralEnergiaEstado estado = (CentralEnergiaEstado) aState;

        // Generamos un estado aleatorio con operador de asignar y otro con intercambiar y decidimos aleatoriamente
        // con cual de ellos nos quedamos.

        final int MAX_COUNTER = 1000;
        int counter = 0;

        // Asignar Random
        do {
            int clienteAsignar = getRandomNumber(0, estado._n_clientes - 1);
            int centralAsignar = getRandomNumber(0, estado._n_centrales - 1);

            CentralEnergiaEstado estadoAsignar = new CentralEnergiaEstado(estado);
            if (estadoAsignar.asignar(clienteAsignar, centralAsignar)) {
                retVal.add(new Successor("cliente " + clienteAsignar + " asignado a central " + centralAsignar
                        + " (" + estadoAsignar.calculaBeneficio() + ")", estadoAsignar));
                break;
            }
            counter++;
        } while (counter <= MAX_COUNTER);

        counter = 0;

        // Intercambiar Random
        do {
            int clienteIntercambiar1 = getRandomNumber(0, estado._n_clientes - 1);
            int clienteIntercambiar2 = getRandomNumber(0, estado._n_clientes - 1);

            CentralEnergiaEstado estadoIntercambiar = new CentralEnergiaEstado(estado);
            if (estadoIntercambiar.intercambiar(clienteIntercambiar1, clienteIntercambiar2)) {
                retVal.add(new Successor("cliente " + clienteIntercambiar1 + " intercambiado por " + clienteIntercambiar2
                        + " (" + estadoIntercambiar.calculaBeneficio() + ")", estadoIntercambiar));
                break;
            }
            counter++;
        } while (counter <= MAX_COUNTER);

        ArrayList<Successor> nuevoRetVal = new ArrayList<>();
        int randomEstado = getRandomNumber(0, retVal.size() - 1);
        nuevoRetVal.add(retVal.get(randomEstado));

        return nuevoRetVal;
    }
}