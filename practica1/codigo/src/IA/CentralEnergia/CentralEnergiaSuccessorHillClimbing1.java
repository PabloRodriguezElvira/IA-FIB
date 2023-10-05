package IA.CentralEnergia;

import aima.search.framework.Successor;
import aima.search.framework.SuccessorFunction;

import java.util.ArrayList;

public class CentralEnergiaSuccessorHillClimbing1 implements SuccessorFunction {
    public ArrayList<Successor> getSuccessors(Object aState) {
        // SUCESORES GENERADOS POR LOS OPERADORES ASIGNAR, DESASIGNAR, VOLCAR E INTERCAMBIAR

        ArrayList<Successor> retVal = new ArrayList<>();
        CentralEnergiaEstado estado = (CentralEnergiaEstado) aState;

        // Asignar
        for (int i = 0; i < estado.asigClientes.size(); ++i) {
            for (int j = 0; j < estado.consumoCentrales.size(); ++j) {
                CentralEnergiaEstado nuevoEstado = new CentralEnergiaEstado(estado);
                if (nuevoEstado.asignar(i, j)) {
                    retVal.add(new Successor("cliente " + i + " asignado a central " + j + " (" + nuevoEstado.calculaBeneficio() + ")"
                            + " Número de clientes asignados: " + nuevoEstado.contarClientesAsignados(), nuevoEstado));
                }
            }
        }

        // Desasignar
        /*for (int i = 0; i < estado.asigClientes.size(); ++i) {
            CentralEnergiaEstado nuevoEstado = new CentralEnergiaEstado(estado);
            if (nuevoEstado.desasignar(i)) {
                retVal.add(new Successor("cliente " + i + " desasignado (" + nuevoEstado.calculaBeneficio() + ")"
                        + " Número de clientes asignados: " + nuevoEstado.contarClientesAsignados(), nuevoEstado));
            }
        }

        // Volcar
        /*for (int i = 0; i < estado.consumoCentrales.size(); ++i) {
            for (int j = i + 1; j < estado.consumoCentrales.size(); ++j) {
                CentralEnergiaEstado nuevoEstado = new CentralEnergiaEstado(estado);
                if (nuevoEstado.volcar(i, j)) {
                    retVal.add(new Successor("central " + i + " volcada a " + j + " (" + nuevoEstado.calculaBeneficio() + ")"
                            + " Número de clientes asignados: " + nuevoEstado.contarClientesAsignados(), nuevoEstado));
                }
            }
        }*/

        // Intercambiar
        for (int i = 0; i < estado.asigClientes.size(); ++i) {
            for (int j = i + 1; j < estado.asigClientes.size(); j += 1) {
                CentralEnergiaEstado nuevoEstado = new CentralEnergiaEstado(estado);
                if (nuevoEstado.intercambiar(i, j)) {
                    retVal.add(new Successor("cliente " + i + " intercambiado por " + j + " (" + nuevoEstado.calculaBeneficio() + ")"
                            + " Número de clientes asignados: " + nuevoEstado.contarClientesAsignados(), nuevoEstado));
                }
            }
        }

        return retVal;
    }
}
