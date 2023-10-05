package IA.CentralEnergia;

import IA.Energia.Central;
import IA.Energia.Cliente;
import aima.search.framework.HeuristicFunction;

public class CentralEnergiaHeuristicFunction2 implements HeuristicFunction {
    public double getHeuristicValue(Object state) {
        CentralEnergiaEstado estado = (CentralEnergiaEstado) state;
        
        double produccionPerdida = 0.f;
        for (int centralId = 0; centralId < estado._n_centrales; ++centralId) {
            if (estado.consumoCentrales.get(centralId) == 0.) {
                continue;
            }

            Central central = estado._centrales.get(centralId);
            produccionPerdida += central.getProduccion() - estado.consumoCentrales.get(centralId);

            /*
            double produccionPerdidaCentral = central.getProduccion() - estado.consumoCentrales.get(centralId);
            produccionPerdidaCentral = switch (central.getTipo()) {
                case Central.CENTRALA -> produccionPerdidaCentral * 50  + 20_000;
                case Central.CENTRALB -> produccionPerdidaCentral * 80  + 5_000;
                case Central.CENTRALC -> produccionPerdidaCentral * 150 + 1_500;
                default -> throw new IllegalStateException("Unexpected value: " + central.getTipo());
            };

            produccionPerdida += produccionPerdidaCentral;
            */
        }

        for (int clienteId = 0; clienteId < estado._n_clientes; ++clienteId) {
            Cliente cliente = estado._clientes.get(clienteId);
            if (estado.asigClientes.get(clienteId) == -1) {
                continue;
            }

            Central centralAsignado = estado._centrales.get(estado.asigClientes.get(clienteId));

            int[] posCliente = new int[]{cliente.getCoordX(), cliente.getCoordY()};
            int[] posCentral = new int[]{centralAsignado.getCoordX(), centralAsignado.getCoordY()};

            double consumoCliente = cliente.getConsumo();
            /*
            if (cliente.getContrato() == Cliente.GARANTIZADO) {
                consumoCliente = switch (cliente.getTipo()) {
                    case Cliente.CLIENTEXG -> 400;
                    case Cliente.CLIENTEMG -> 500;
                    case Cliente.CLIENTEG -> 600;
                    default -> throw new IllegalStateException("Unexpected value: " + cliente.getTipo());
                };
            } else if (cliente.getContrato() == Cliente.NOGARANTIZADO) {
                consumoCliente = switch (cliente.getTipo()) {
                    case Cliente.CLIENTEXG -> 300;
                    case Cliente.CLIENTEMG -> 400;
                    case Cliente.CLIENTEG -> 500;
                    default -> throw new IllegalStateException("Unexpected value: " + cliente.getTipo());
                };
            }
            */

            produccionPerdida += consumoCliente * estado.calcularPerdidaDistancia(posCliente, posCentral);
        }

        return produccionPerdida*produccionPerdida;
    }
}
