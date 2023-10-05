package IA.CentralEnergia;

import aima.search.framework.*;
import aima.search.informed.HillClimbingSearch;
import aima.search.informed.SimulatedAnnealingSearch;

import java.sql.SQLOutput;
import java.util.*;

import static java.lang.Thread.sleep;

public class Main {
    public static void main(String[] args) throws Exception {

        int tipA = 5; //+5
        int tipB = 10; //+10
        int tipC = 25; //+25
        int seedCen = 1234;
        int numCli = 1000;
        double propXG = 0.25;
        double propMG = 0.3;
        double propG = 0.45;
        double propGar = 0.75;
        int seedCli = 1234;
        System.out.println("Seed centrales: " + seedCen);
        System.out.println("Seed clientes: " + seedCli);
        CentralEnergiaEstado estado = new CentralEnergiaEstado(new int[]{tipA, tipB, tipC}, seedCen, numCli,
                                      new double[]{propXG, propMG, propG}, propGar, seedCli);

        estado.generaSolucionNormal();

        estado.imprimirEstado();
        System.out.println("Beneficio inicial: " + estado.calculaBeneficio());
        System.out.println("Clientes garantizados NO asignados: " + estado.numClientesGarNoAsig());

        //HC
        boolean hillClimbing = true;
        boolean succesor1 = true;
        boolean heuristic1 = true;

        //SA
        /*boolean hillClimbing = false;
        boolean succesor1 = true;
        boolean heuristic1 = true;*/

        HeuristicFunction heuristicFunction = heuristic1 ? new CentralEnergiaHeuristicFunction1() : new CentralEnergiaHeuristicFunction2();

        if (hillClimbing) {
            SuccessorFunction successorFunction = succesor1 ? new CentralEnergiaSuccessorHillClimbing1() : new CentralEnergiaSuccessorHillClimbing2();
            ejecutarHillClimbing(estado, successorFunction, heuristicFunction);
        } else {
            SuccessorFunction successorFunction = succesor1 ? new CentralEnergiaSuccessorSimulatedAnnealing1() : new CentralEnergiaSuccessorSimulatedAnnealing2();
            ejecutarSimulatedAnnealing(estado, successorFunction, heuristicFunction);
        }
    }

    private static void ejecutarHillClimbing(CentralEnergiaEstado estado, SuccessorFunction funcionSucesores, HeuristicFunction heuristicFunction) {
        try {
            Problem problema = new Problem(estado, funcionSucesores, new CentralEnergiaGoalTest(), heuristicFunction);
            Search search = new HillClimbingSearch();

            long start = System.currentTimeMillis();
            SearchAgent agent = new SearchAgent(problema, search);
            long elapsedTime = System.currentTimeMillis() - start;

            printActions(agent.getActions());
            printInstrumentation(agent.getInstrumentation());

            System.out.println("Time elapsed: " + (elapsedTime / 1000.f) + "s");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static int getRandomNumber(int min, int max) {
        return (int)Math.floor(((Math.random() * (max- min + 1)) + min));
    }
    private static void ejecutarSimulatedAnnealing(CentralEnergiaEstado estado, SuccessorFunction funcionSucesores, HeuristicFunction heuristicFunction) {
        try {
            Problem problema = new Problem(estado, funcionSucesores, new CentralEnergiaGoalTest(), heuristicFunction);
            Search search = new SimulatedAnnealingSearch(10000, 20, 10, 0.05);

            long start = System.currentTimeMillis();
            SearchAgent agent = new SearchAgent(problema, search);
            long elapsedTime = System.currentTimeMillis() - start;

            CentralEnergiaEstado estadoFinal = (CentralEnergiaEstado) agent.getActions().get(0);
            System.out.println("Beneficio final: " + estadoFinal.calculaBeneficio());

            printInstrumentation(agent.getInstrumentation());

            System.out.println("Time elapsed: " + (elapsedTime / 1000.f) + "s");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static void printActions(List actions) {
        for (Object action : actions) {
            String accion = (String) action;
            System.out.println(accion);
        }
    }

    private static void printInstrumentation(Properties properties) {
        Iterator keys = properties.keySet().iterator();
        while (keys.hasNext()) {
            String key = (String) keys.next();
            String property = properties.getProperty(key);
            System.out.println(key + " : " + property);
        }
    }
}
