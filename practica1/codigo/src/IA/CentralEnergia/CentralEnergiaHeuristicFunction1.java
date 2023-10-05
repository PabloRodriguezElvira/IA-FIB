package IA.CentralEnergia;

import aima.search.framework.HeuristicFunction;

//Aquesta funció només té en compte el benefici
public class CentralEnergiaHeuristicFunction1 implements HeuristicFunction {
    //final int PHI = 2000000;
    public double getHeuristicValue(Object state) {
        CentralEnergiaEstado estado = (CentralEnergiaEstado) state;
        //return -estado.calculaBeneficio() + estado.numClientesGarNoAsig()*PHI;
        return estado.calculaDistancia();
    }
}
