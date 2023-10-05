package IA.CentralEnergia;

import aima.search.framework.GoalTest;

public class CentralEnergiaGoalTest implements GoalTest {
    public boolean isGoalState(Object aState) {
        CentralEnergiaEstado estado = (CentralEnergiaEstado) aState;
        return (estado.isGoalState());
    }
}
