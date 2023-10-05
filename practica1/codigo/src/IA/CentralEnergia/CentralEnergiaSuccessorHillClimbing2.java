package IA.CentralEnergia;

import aima.search.framework.Successor;
import aima.search.framework.SuccessorFunction;

import java.util.ArrayList;
import java.util.List;

public class CentralEnergiaSuccessorHillClimbing2 implements SuccessorFunction {

    public ArrayList<Successor> getSuccessors(Object aState) {
        //SUCESORES GENERADOS POR EL OPERADOR DE ASIGNAR
        ArrayList<Successor> retVal = new ArrayList<>();
        CentralEnergiaEstado estado = (CentralEnergiaEstado) aState;

        // Asignar
        for (int i = 0; i < estado.asigClientes.size(); ++i) {
            for (int j = 0; j < estado.consumoCentrales.size(); ++j) {
                CentralEnergiaEstado nuevoEstado = new CentralEnergiaEstado(estado);
                if (nuevoEstado.asignar(i, j)) {
                    retVal.add(new Successor("cliente " + i + " asignado a central " + j + " ("
                            + nuevoEstado.calculaBeneficio() + ")" + " Número de clientes asignados: "
                            + nuevoEstado.contarClientesAsignados() + " CLIENTES GARANTIZADOS NO ASIGNADOS: "
                            + nuevoEstado.numClientesGarNoAsig(), nuevoEstado));
                }
            }
        }

        return retVal;
    }
}
