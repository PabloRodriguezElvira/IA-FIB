package IA.CentralEnergia;

import aima.search.framework.Successor;
import aima.search.framework.SuccessorFunction;

import java.util.ArrayList;

public class CentralEnergiaSuccessorSimulatedAnnealing2 implements SuccessorFunction {

    public int getRandomNumber(int min, int max) {
        return (int)Math.floor(((Math.random() * (max- min + 1)) + min));
    }

    public ArrayList<Successor> getSuccessors(Object aState) {
        ArrayList<Successor> retVal = new ArrayList<>();
        CentralEnergiaEstado estado = (CentralEnergiaEstado) aState;

        //Escogemos un estado aleatorio con el operador de asignar.

        boolean operadorAceptado = false;
        // Asignar Random
        while (!operadorAceptado) {
            int clienteAsignar = getRandomNumber(0, estado._n_clientes-1);
            int centralAsignar = getRandomNumber(0, estado._n_centrales-1);

            CentralEnergiaEstado estadoAsignar = new CentralEnergiaEstado(estado);
            if (estadoAsignar.asignar(clienteAsignar, centralAsignar)) {
                retVal.add(new Successor("cliente " + clienteAsignar + " asignado a central " + centralAsignar + " (" +
                        estadoAsignar.calculaBeneficio() + ")", estadoAsignar));
                operadorAceptado = true;
            }
        }
        return retVal;
    }
}
